package feed

import (
	"context"
	"fmt"
	"math"
	"time"

	stream "github.com/GetStream/stream-go2/v8"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
)

const pageSize = 20

// Service assembles The Line — the CR-ranked feed.
type Service struct {
	db           *pgxpool.Pool
	streamClient *stream.Client
}

func NewService(db *pgxpool.Pool, streamClient *stream.Client) *Service {
	return &Service{db: db, streamClient: streamClient}
}

// GetLine returns the CR-ranked Line feed for a user.
// Algorithm: Score = CR(viewer, creator) × RecencyDecay × ContentBoost × EchoBoost
func (s *Service) GetLine(ctx context.Context, viewerID uuid.UUID, page int) (*LineResponse, error) {
	if page < 1 {
		page = 1
	}
	offset := (page - 1) * pageSize

	rows, err := s.db.Query(ctx, `
		SELECT
			m.id, m.user_id,
			u.username, COALESCE(u.profile_picture_url, ''),
			m.content_type, COALESCE(m.caption, ''),
			COALESCE(m.media_url, ''), COALESCE(m.thumbnail_url, ''),
			COALESCE(ks.kin_score, 0.0) AS kin_score,
			COALESCE(ks.relationship, 'unknown') AS relationship,
			m.is_echo, m.echo_date,
			(SELECT COUNT(*) FROM pulses p WHERE p.memory_id = m.id) AS pulse_count,
			m.created_at
		FROM memories m
		JOIN users u ON u.id = m.user_id
		-- Only surface content from confirmed Kinnections
		JOIN kinnections k ON (
			(k.user_a_id = $1 AND k.user_b_id = m.user_id)
			OR (k.user_b_id = $1 AND k.user_a_id = m.user_id)
		) AND k.status = 'confirmed'
		LEFT JOIN kin_scores ks ON (
			(ks.user_a_id = $1 AND ks.user_b_id = m.user_id)
			OR (ks.user_b_id = $1 AND ks.user_a_id = m.user_id)
		)
		WHERE m.status = 'active'
		ORDER BY m.created_at DESC
		LIMIT $2 OFFSET $3`,
		viewerID, pageSize+1, offset,
	)
	if err != nil {
		return nil, fmt.Errorf("get line: %w", err)
	}
	defer rows.Close()

	var rawItems []LineItem
	for rows.Next() {
		var item LineItem
		var echoDate *string
		if err := rows.Scan(
			&item.MemoryID, &item.CreatorID,
			&item.CreatorUsername, &item.CreatorPictureURL,
			&item.ContentType, &item.Caption,
			&item.MediaURL, &item.ThumbnailURL,
			&item.KinScore, &item.Relationship,
			&item.IsEcho, &echoDate,
			&item.PulseCount, &item.CreatedAt,
		); err != nil {
			return nil, err
		}
		item.EchoDate = echoDate
		item.DisplayScore = kinScoreToDisplay(item.KinScore)
		item.RankScore = s.rankScore(item)
		rawItems = append(rawItems, item)
	}

	// Sort by rank score descending (CR-first ranking)
	sortByRankScore(rawItems)

	hasMore := len(rawItems) > pageSize
	if hasMore {
		rawItems = rawItems[:pageSize]
	}

	return &LineResponse{
		Items:    rawItems,
		NextPage: page + 1,
		HasMore:  hasMore,
	}, nil
}

// CreateMemory stores a new post and publishes it to GetStream.
func (s *Service) CreateMemory(ctx context.Context, creatorID uuid.UUID, req CreateMemoryRequest) (*LineItem, error) {
	memID := uuid.New()
	now := time.Now().UTC()

	var branchID *uuid.UUID
	if req.BranchID != "" {
		bid, err := uuid.Parse(req.BranchID)
		if err == nil {
			branchID = &bid
		}
	}

	_, err := s.db.Exec(ctx, `
		INSERT INTO memories (id, user_id, content_type, caption, media_url, thumbnail_url,
		                      branch_id, is_echo, echo_date, status, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, 'active', $10, $10)`,
		memID, creatorID, req.ContentType, req.Caption, req.MediaURL, req.ThumbnailURL,
		branchID, req.IsEcho, nullableDate(req.EchoDate), now,
	)
	if err != nil {
		return nil, fmt.Errorf("create memory: db insert: %w", err)
	}

	// Publish to GetStream activity feed
	userFeed, err := s.streamClient.FlatFeed("user", creatorID.String())
	if err != nil {
		return nil, fmt.Errorf("create memory: getstream feed: %w", err)
	}

	activity := stream.Activity{
		Actor:  fmt.Sprintf("User:%s", creatorID.String()),
		Verb:   "post",
		Object: fmt.Sprintf("Memory:%s", memID.String()),
		Extra: map[string]interface{}{
			"content_type":  req.ContentType,
			"caption":       req.Caption,
			"media_url":     req.MediaURL,
			"thumbnail_url": req.ThumbnailURL,
			"is_echo":       req.IsEcho,
		},
	}

	if _, err = userFeed.AddActivity(ctx, activity); err != nil {
		// Log but don't fail the request — DB write succeeded
		fmt.Printf("warn: getstream activity publish failed for memory %s: %v\n", memID, err)
	}

	return &LineItem{
		MemoryID:    memID,
		CreatorID:   creatorID,
		ContentType: req.ContentType,
		Caption:     req.Caption,
		MediaURL:    req.MediaURL,
		ThumbnailURL: req.ThumbnailURL,
		CreatedAt:   now,
	}, nil
}

// PulseMemory records a Pulse (reaction) on a Memory.
func (s *Service) PulseMemory(ctx context.Context, userID, memoryID uuid.UUID, pulseType string) error {
	_, err := s.db.Exec(ctx, `
		INSERT INTO pulses (id, user_id, memory_id, pulse_type, created_at)
		VALUES ($1, $2, $3, $4, NOW())
		ON CONFLICT (user_id, memory_id) DO NOTHING`,
		uuid.New(), userID, memoryID, pulseType,
	)
	return err
}

// ─── Feed Ranking ────────────────────────────────────────────────────────────

// rankScore implements: Score = CR × RecencyDecay × ContentBoost × EchoBoost
// CR is always the dominant factor as per the patent specification.
func (s *Service) rankScore(item LineItem) float64 {
	cr := item.KinScore
	if cr <= 0 {
		cr = 0.001
	}

	// Recency decay: exponential half-life of 48h
	hoursAgo := time.Since(item.CreatedAt).Hours()
	recencyDecay := math.Exp(-0.693 * hoursAgo / 48)

	// Content type boost
	contentBoost := 1.0
	switch item.ContentType {
	case "bloom":
		contentBoost = 1.3
	case "video":
		contentBoost = 1.2
	case "audio":
		contentBoost = 1.1
	}

	// Echo boost: elevate on-this-day memories
	echoBoost := 1.0
	if item.IsEcho {
		echoBoost = 2.0
	}

	// Ripple boost: cap at 2× to prevent viral > biological ranking
	rippleBoost := 1.0 + math.Min(float64(item.PulseCount)*0.01, 1.0)

	return cr * recencyDecay * contentBoost * echoBoost * rippleBoost
}

func sortByRankScore(items []LineItem) {
	for i := 1; i < len(items); i++ {
		for j := i; j > 0 && items[j].RankScore > items[j-1].RankScore; j-- {
			items[j], items[j-1] = items[j-1], items[j]
		}
	}
}

func kinScoreToDisplay(cr float64) int {
	if cr <= 0 {
		return 0
	}
	display := int(math.Round((math.Log(cr/0.001) / math.Log(0.5/0.001)) * 100))
	if display < 0 {
		return 0
	}
	if display > 100 {
		return 100
	}
	return display
}

func nullableDate(s string) interface{} {
	if s == "" {
		return nil
	}
	return s
}
