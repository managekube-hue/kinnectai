package feed

import (
	"context"
	"errors"
	"time"
)

// Feed represents a user's personalized content feed
// This is the aggregate root for the Feed bounded context
type Feed struct {
	ID        string
	UserID    string
	Items     []FeedItem
	CreatedAt time.Time
	UpdatedAt time.Time
	Version   int64
}

// FeedItem represents a single entry in the feed
type FeedItem struct {
	ID           string
	ContentID    string
	ContentType  string // "memory", "post", "photo", "room"
	Score        float64
	Rank         int
	RankingModel string // "v1", "v2_behavioral", etc.
	RankedAt     time.Time
	Metadata     map[string]interface{}
}

// FeedRankingRequest represents input to ranking algorithm
type FeedRankingRequest struct {
	UserID              string
	Limit               int
	BehavioralWeights   BehavioralWeights
	GraphPreferences    GraphPreferences
	ExcludeContentIDs   []string
	IncludeContentTypes []string
}

// BehavioralWeights represents user behavioral signals
type BehavioralWeights struct {
	RecentEngagement float64
	TimeDecay        float64
	UserAffinity     float64
	TrendingFactor   float64
}

// GraphPreferences represents graph-based recommendations
type GraphPreferences struct {
	MaxHopDistance int
	RelationshipTypes []string
	GraphWeights map[string]float64
}

// DomainErrors
var (
	ErrFeedNotFound = errors.New("feed not found")
	ErrEmptyFeed = errors.New("feed cannot be empty")
	ErrInvalidUserID = errors.New("invalid user ID")
	ErrInvalidScore = errors.New("score must be between 0 and 1")
)

// CreateFeed creates a new empty feed for a user
func CreateFeed(userID string) (*Feed, error) {
	if userID == "" {
		return nil, ErrInvalidUserID
	}

	return &Feed{
		ID:        generateFeedID(userID),
		UserID:    userID,
		Items:     []FeedItem{},
		CreatedAt: time.Now(),
		UpdatedAt: time.Now(),
		Version:   1,
	}, nil
}

// AddItem adds a ranked content item to the feed
func (f *Feed) AddItem(item FeedItem) error {
	if item.Score < 0 || item.Score > 1 {
		return ErrInvalidScore
	}

	item.Rank = len(f.Items) + 1
	f.Items = append(f.Items, item)
	f.UpdatedAt = time.Now()
	f.Version++
	
	return nil
}

// RemoveItem removes an item from the feed by content ID
func (f *Feed) RemoveItem(contentID string) {
	for i, item := range f.Items {
		if item.ContentID == contentID {
			f.Items = append(f.Items[:i], f.Items[i+1:]...)
			f.UpdatedAt = time.Now()
			f.Version++
			break
		}
	}
}

// Rerank reorders feed items by score (highest first)
func (f *Feed) Rerank() {
	// TODO: Implement sorting by score with rank recalculation
	f.UpdatedAt = time.Now()
	f.Version++
}

// Truncate limits feed to N items
func (f *Feed) Truncate(limit int) {
	if len(f.Items) > limit {
		f.Items = f.Items[:limit]
		f.UpdatedAt = time.Now()
		f.Version++
	}
}

// ApplyPolicy applies content policies (consent, moderation, lineage)
func (f *Feed) ApplyPolicy(ctx context.Context, policy Policy) error {
	// TODO: Filter items based on policy constraints
	return nil
}

// FeedRepository defines persistence operations for Feed aggregates
type FeedRepository interface {
	// Save persists a feed to storage
	Save(ctx context.Context, feed *Feed) error
	
	// GetByUserID retrieves a user's current feed
	GetByUserID(ctx context.Context, userID string) (*Feed, error)
	
	// GetByID retrieves a specific feed version
	GetByID(ctx context.Context, feedID string) (*Feed, error)
	
	// Delete removes a feed
	Delete(ctx context.Context, feedID string) error
	
	// List retrieves multiple feeds (pagination support needed)
	List(ctx context.Context, limit, offset int) ([]*Feed, error)
}

// Policy interface allows different policy implementations (consent, moderation, etc.)
type Policy interface {
	// Filter returns filtered content IDs based on policy rules
	Filter(ctx context.Context, contentIDs []string, userID string) ([]string, error)
}

// Helper functions
func generateFeedID(userID string) string {
	// TODO: Implement deterministic ID generation
	return "feed_" + userID + "_" + time.Now().Format("20060102150405")
}
