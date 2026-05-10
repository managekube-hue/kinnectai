package feed

import (
	"context"
	"errors"
	"log"
)

// FeedService orchestrates domain logic for feed personalization
// This implements application layer - coordinates domain entities and repositories
type FeedService struct {
	repo            FeedRepository
	rankingEngine   RankingEngine
	policyEngine    PolicyEngine
	eventPublisher  EventPublisher
	logger          *log.Logger
}

// NewFeedService creates a new feed service with dependencies
func NewFeedService(
	repo FeedRepository,
	rankingEngine RankingEngine,
	policyEngine PolicyEngine,
	eventPublisher EventPublisher,
	logger *log.Logger,
) *FeedService {
	return &FeedService{
		repo:           repo,
		rankingEngine:  rankingEngine,
		policyEngine:   policyEngine,
		eventPublisher: eventPublisher,
		logger:         logger,
	}
}

// GenerateFeed creates a personalized feed for a user
func (fs *FeedService) GenerateFeed(ctx context.Context, req *FeedRankingRequest) (*Feed, error) {
	fs.logger.Printf("Generating feed for user: %s", req.UserID)

	// 1. Retrieve candidate content from graph service
	candidates, err := fs.rankingEngine.FetchCandidates(ctx, req.UserID)
	if err != nil {
		fs.logger.Printf("Failed to fetch candidates: %v", err)
		return nil, err
	}

	// 2. Score candidates using behavioral + graph signals
	scoredItems, err := fs.rankingEngine.Score(ctx, req, candidates)
	if err != nil {
		fs.logger.Printf("Scoring failed: %v", err)
		return nil, err
	}

	// 3. Apply policies (consent, moderation, lineage)
	policyResp, err := fs.policyEngine.Evaluate(ctx, req.UserID, scoredItems)
	if err != nil {
		fs.logger.Printf("Policy evaluation failed: %v", err)
		return nil, err
	}

	// 4. Create aggregate and populate
	feed, err := CreateFeed(req.UserID)
	if err != nil {
		return nil, err
	}

	for _, item := range policyResp.AllowedItems {
		if err := feed.AddItem(item); err != nil {
			fs.logger.Printf("Failed to add item to feed: %v", err)
			continue
		}
	}

	// 5. Sort by score (highest first) 
	feed.Rerank()

	// 6. Apply limit
	feed.Truncate(req.Limit)

	// 7. Persist to cache + database
	if err := fs.repo.Save(ctx, feed); err != nil {
		fs.logger.Printf("Failed to save feed: %v", err)
		return nil, err
	}

	// 8. Publish event for analytics/tracking
	event := &FeedGeneratedEvent{
		FeedID:         feed.ID,
		UserID:         feed.UserID,
		ItemCount:      len(feed.Items),
		GeneratedAt:    feed.CreatedAt,
		RankingModel:   "v1", // TODO: make configurable
		TotalCandidates: len(candidates),
		FilteredCount:  len(candidates) - len(policyResp.AllowedItems),
	}
	fs.eventPublisher.Publish(ctx, event)

	fs.logger.Printf("Feed generated successfully: %d items", len(feed.Items))
	return feed, nil
}

// GetUserFeed retrieves the current cached feed for a user
func (fs *FeedService) GetUserFeed(ctx context.Context, userID string) (*Feed, error) {
	feed, err := fs.repo.GetByUserID(ctx, userID)
	if err != nil {
		if errors.Is(err, ErrFeedNotFound) {
			// Generate new feed on cache miss
			return fs.GenerateFeed(ctx, &FeedRankingRequest{
				UserID: userID,
				Limit:  50,
				BehavioralWeights: BehavioralWeights{
					RecentEngagement: 0.4,
					TimeDecay:        0.3,
					UserAffinity:     0.2,
					TrendingFactor:   0.1,
				},
			})
		}
		return nil, err
	}
	return feed, nil
}

// RefreshFeed forces regeneration of feed (invalidates cache)
func (fs *FeedService) RefreshFeed(ctx context.Context, userID string) (*Feed, error) {
	fs.logger.Printf("Refreshing feed for user: %s", userID)

	// Regenerate with default parameters
	feed, err := fs.GenerateFeed(ctx, &FeedRankingRequest{
		UserID: userID,
		Limit:  50,
		BehavioralWeights: BehavioralWeights{
			RecentEngagement: 0.4,
			TimeDecay:        0.3,
			UserAffinity:     0.2,
			TrendingFactor:   0.1,
		},
	})

	if err == nil {
		fs.eventPublisher.Publish(ctx, &FeedRefreshedEvent{
			FeedID:    feed.ID,
			UserID:    feed.UserID,
			Timestamp: feed.UpdatedAt,
		})
	}

	return feed, err
}

// RankingEngine interface for scoring candidates
type RankingEngine interface {
	// FetchCandidates retrieves candidate content from graph service
	FetchCandidates(ctx context.Context, userID string) ([]FeedItem, error)
	
	// Score applies ranking algorithms (behavioral, graph-based, trending)
	Score(ctx context.Context, req *FeedRankingRequest, candidates []FeedItem) ([]FeedItem, error)
}

// PolicyEngine interface for content filtering
type PolicyEngine interface {
	// Evaluate applies policies to filter/annotate content
	Evaluate(ctx context.Context, userID string, items []FeedItem) (*PolicyResponse, error)
}

type PolicyResponse struct {
	AllowedItems []FeedItem
	FilteredIDs  []string
	Violations   []PolicyViolation
}

type PolicyViolation struct {
	ContentID string
	Policy    string
	Reason    string
}

// EventPublisher interface for async event handling
type EventPublisher interface {
	Publish(ctx context.Context, event interface{}) error
}

// Domain Events
type FeedGeneratedEvent struct {
	FeedID         string
	UserID         string
	ItemCount      int
	GeneratedAt    interface{}
	RankingModel   string
	TotalCandidates int
	FilteredCount   int
}

type FeedRefreshedEvent struct {
	FeedID    string
	UserID    string
	Timestamp interface{}
}

type FeedViewedEvent struct {
	FeedID      string
	UserID      string
	ContentID   string
	Position    int
	ViewedAt    interface{}
}
