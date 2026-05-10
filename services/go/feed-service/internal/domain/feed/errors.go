package feed

import "fmt"

// DomainError represents errors in the feed domain layer
type DomainError interface {
	error
	Code() string
	Message() string
	StatusCode() int
}

// FeedNotFoundError indicates feed does not exist
type FeedNotFoundError struct {
	FeedID string
	UserID string
}

func (e *FeedNotFoundError) Error() string {
	return fmt.Sprintf("feed not found: feedID=%s, userID=%s", e.FeedID, e.UserID)
}

func (e *FeedNotFoundError) Code() string {
	return "FEED_NOT_FOUND"
}

func (e *FeedNotFoundError) Message() string {
	return "The requested feed does not exist"
}

func (e *FeedNotFoundError) StatusCode() int {
	return 404
}

// InvalidScoreError indicates score is outside valid range [0, 1]
type InvalidScoreError struct {
	Score float64
}

func (e *InvalidScoreError) Error() string {
	return fmt.Sprintf("invalid score: %.2f (must be 0-1)", e.Score)
}

func (e *InvalidScoreError) Code() string {
	return "INVALID_SCORE"
}

func (e *InvalidScoreError) Message() string {
	return "Feed item score must be between 0 and 1"
}

func (e *InvalidScoreError) StatusCode() int {
	return 400
}

// EmptyFeedError indicates feed has no items
type EmptyFeedError struct {
	UserID string
}

func (e *EmptyFeedError) Error() string {
	return fmt.Sprintf("empty feed for user: %s", e.UserID)
}

func (e *EmptyFeedError) Code() string {
	return "EMPTY_FEED"
}

func (e *EmptyFeedError) Message() string {
	return "No content available for your feed"
}

func (e *EmptyFeedError) StatusCode() int {
	return 204
}

// PolicyViolationError indicates content violates policy
type PolicyViolationError struct {
	ContentID string
	PolicyName string
	Reason    string
}

func (e *PolicyViolationError) Error() string {
	return fmt.Sprintf("policy violation: content=%s, policy=%s, reason=%s", 
		e.ContentID, e.PolicyName, e.Reason)
}

func (e *PolicyViolationError) Code() string {
	return "POLICY_VIOLATION"
}

func (e *PolicyViolationError) Message() string {
	return "Content does not meet policy requirements"
}

func (e *PolicyViolationError) StatusCode() int {
	return 403
}

// RankingEngineError indicates ranking calculation failed
type RankingEngineError struct {
	UserID string
	Reason string
}

func (e *RankingEngineError) Error() string {
	return fmt.Sprintf("ranking engine failed for user %s: %s", e.UserID, e.Reason)
}

func (e *RankingEngineError) Code() string {
	return "RANKING_ENGINE_ERROR"
}

func (e *RankingEngineError) Message() string {
	return "Failed to generate feed recommendations"
}

func (e *RankingEngineError) StatusCode() int {
	return 500
}

// InvalidUserIDError indicates user ID is invalid or missing
type InvalidUserIDError struct {
	Reason string
}

func (e *InvalidUserIDError) Error() string {
	return fmt.Sprintf("invalid user ID: %s", e.Reason)
}

func (e *InvalidUserIDError) Code() string {
	return "INVALID_USER_ID"
}

func (e *InvalidUserIDError) Message() string {
	return "User ID is required and must be valid"
}

func (e *InvalidUserIDError) StatusCode() int {
	return 400
}

// ConcurrencyError indicates optimistic locking conflict
type ConcurrencyError struct {
	FeedID  string
	Current int64
	Expected int64
}

func (e *ConcurrencyError) Error() string {
	return fmt.Sprintf("concurrent modification: feedID=%s, current=%d, expected=%d", 
		e.FeedID, e.Current, e.Expected)
}

func (e *ConcurrencyError) Code() string {
	return "CONCURRENCY_ERROR"
}

func (e *ConcurrencyError) Message() string {
	return "Feed was modified by another request. Please retry."
}

func (e *ConcurrencyError) StatusCode() int {
	return 409
}
