// SRS §23.1 Category 6 — Kinnection / Graph Domain extended types
package graph

import (
	"time"

	"github.com/google/uuid"
)

// Kinnection is a confirmed biological or chosen family link between two users.
type Kinnection struct {
	ID               uuid.UUID  `json:"id"`
	UserAID          uuid.UUID  `json:"user_a_id"`
	UserBID          uuid.UUID  `json:"user_b_id"`
	RelationshipType string     `json:"relationship_type"`
	Status           string     `json:"status"` // pending | confirmed | disputed
	KinScore         float64    `json:"kin_score"`
	ConfirmedAt      *time.Time `json:"confirmed_at,omitempty"`
	CreatedAt        time.Time  `json:"created_at"`
}

// KinnectionList is the paginated list of a user's kinnections.
type KinnectionList struct {
	Kinnections []KinnectionListKinnectionsInner `json:"kinnections"`
	Total       int                              `json:"total"`
	NextCursor  string                           `json:"next_cursor,omitempty"`
}

// KinnectionListKinnectionsInner is a summary entry in the kinnections list.
type KinnectionListKinnectionsInner struct {
	KinnectionID     uuid.UUID `json:"kinnection_id"`
	RelatedUserID    uuid.UUID `json:"related_user_id"`
	DisplayName      string    `json:"display_name"`
	AvatarURL        string    `json:"avatar_url,omitempty"`
	RelationshipType string    `json:"relationship_type"`
	KinScore         float64   `json:"kin_score"`
}

// KinnectionPath describes the shortest known relationship path between two users.
type KinnectionPath struct {
	FromUserID uuid.UUID             `json:"from_user_id"`
	ToUserID   uuid.UUID             `json:"to_user_id"`
	Path       []KinnectionPathPathInner `json:"path"`
	Hops       int                   `json:"hops"`
}

// KinnectionPathPathInner is a single hop in a relationship path.
type KinnectionPathPathInner struct {
	UserID           uuid.UUID `json:"user_id"`
	DisplayName      string    `json:"display_name"`
	RelationshipType string    `json:"relationship_from_prev"`
}

// KinnectionEdge is a typed directed edge in the family graph.
type KinnectionEdge struct {
	EdgeID    uuid.UUID `json:"edge_id"`
	FromID    uuid.UUID `json:"from_id"`
	ToID      uuid.UUID `json:"to_id"`
	EdgeType  string    `json:"edge_type"` // parent | child | sibling | cousin
	Weight    float64   `json:"weight"`
}

// Branch represents a family lineage branch in the tree.
type Branch struct {
	BranchID    uuid.UUID   `json:"branch_id"`
	Label       string      `json:"label"`        // e.g. "Sullivan Maternal Line"
	AncestorIDs []uuid.UUID `json:"ancestor_ids"`
	MemberIDs   []uuid.UUID `json:"member_ids"`
	Generation  int         `json:"generation"`
}

// TreePerson is a node in the rendered family tree.
type TreePerson struct {
	PersonID    uuid.UUID  `json:"person_id"`
	DisplayName string     `json:"display_name"`
	BirthYear   *int       `json:"birth_year,omitempty"`
	DeathYear   *int       `json:"death_year,omitempty"`
	IsLiving    bool       `json:"is_living"`
	AvatarURL   string     `json:"avatar_url,omitempty"`
	Verified    bool       `json:"verified"`
}

// RelationshipPath is a resolved ancestor path used for GEDCOM merge analysis.
type RelationshipPath struct {
	PathID        uuid.UUID   `json:"path_id"`
	Nodes         []uuid.UUID `json:"nodes"`
	EdgeTypes     []string    `json:"edge_types"`
	TotalDistance int         `json:"total_distance"`
}

// BranchMergeCandidate is a potential branch union found during genealogy analysis.
type BranchMergeCandidate struct {
	CandidateID   uuid.UUID `json:"candidate_id"`
	BranchAID     uuid.UUID `json:"branch_a_id"`
	BranchBID     uuid.UUID `json:"branch_b_id"`
	Confidence    float64   `json:"confidence"`
	CommonPersonID *uuid.UUID `json:"common_person_id,omitempty"`
	ProposedAt    time.Time `json:"proposed_at"`
}

// GEDCOMMergeResult captures the outcome of a GEDCOM import merge.
type GEDCOMMergeResult struct {
	ImportID       uuid.UUID `json:"import_id"`
	PersonsMerged  int       `json:"persons_merged"`
	PersonsCreated int       `json:"persons_created"`
	Conflicts      int       `json:"conflicts"`
	CompletedAt    time.Time `json:"completed_at"`
}

// GraphTraversalMetrics captures performance data for graph queries.
type GraphTraversalMetrics struct {
	QueryID      uuid.UUID     `json:"query_id"`
	NodesVisited int           `json:"nodes_visited"`
	EdgesTraversed int         `json:"edges_traversed"`
	LatencyMs    int64         `json:"latency_ms"`
	Algorithm    string        `json:"algorithm"` // bfs | dijkstra | a_star
	ExecutedAt   time.Time     `json:"executed_at"`
}
