package feed

import (
	"time"

	"github.com/google/uuid"
)

// LineItem is a ranked post in The Line feed.
type LineItem struct {
	MemoryID          uuid.UUID `json:"memory_id"`
	CreatorID         uuid.UUID `json:"creator_id"`
	CreatorUsername   string    `json:"creator_username"`
	CreatorPictureURL string    `json:"creator_picture_url"`
	ContentType       string    `json:"content_type"`
	Caption           string    `json:"caption"`
	MediaURL          string    `json:"media_url"`
	ThumbnailURL      string    `json:"thumbnail_url"`
	KinScore          float64   `json:"kin_score"`
	DisplayScore      int       `json:"display_score"`
	Relationship      string    `json:"relationship"`
	RankScore         float64   `json:"rank_score"`
	PulseCount        int       `json:"pulse_count"`
	IsEcho            bool      `json:"is_echo"`
	EchoDate          *string   `json:"echo_date,omitempty"`
	CreatedAt         time.Time `json:"created_at"`
}

// LineResponse is the paginated Line feed.
type LineResponse struct {
	Items    []LineItem `json:"items"`
	NextPage int        `json:"next_page"`
	HasMore  bool       `json:"has_more"`
}

// CreateMemoryRequest is the payload for posting to The Line.
type CreateMemoryRequest struct {
	ContentType  string `json:"content_type"  binding:"required,oneof=video bloom audio photo text"`
	Caption      string `json:"caption"       binding:"omitempty,max=500"`
	MediaURL     string `json:"media_url"     binding:"omitempty,url"`
	ThumbnailURL string `json:"thumbnail_url" binding:"omitempty,url"`
	BranchID     string `json:"branch_id"`
	IsEcho       bool   `json:"is_echo"`
	EchoDate     string `json:"echo_date"`    // YYYY-MM-DD
}
