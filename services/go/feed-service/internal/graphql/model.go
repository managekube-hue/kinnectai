// SRS §23.1 Category 17 — GraphQL types
package graphql

import "github.com/google/uuid"

// TreeGraphQuery is the input to a GraphQL family-tree query.
type TreeGraphQuery struct {
	RootUserID uuid.UUID `json:"root_user_id"`
	Depth      int       `json:"depth"`
	BranchIDs  []uuid.UUID `json:"branch_ids,omitempty"`
	Filter     string    `json:"filter,omitempty"` // all | living | historical
}

// TreeGraphConnection is a paginated GraphQL connection for tree nodes.
type TreeGraphConnection struct {
	Edges    []TreeGraphEdge `json:"edges"`
	PageInfo PageInfo        `json:"page_info"`
	Total    int             `json:"total_count"`
}

// TreeGraphEdge is a single edge in a GraphQL tree connection.
type TreeGraphEdge struct {
	Node   interface{} `json:"node"`
	Cursor GraphCursor `json:"cursor"`
}

// PageInfo holds GraphQL Relay-spec pagination info.
type PageInfo struct {
	HasNextPage     bool   `json:"has_next_page"`
	HasPreviousPage bool   `json:"has_previous_page"`
	StartCursor     string `json:"start_cursor,omitempty"`
	EndCursor       string `json:"end_cursor,omitempty"`
}

// GraphCursor is an opaque pagination cursor value.
type GraphCursor struct {
	Encoded string `json:"cursor"`
}

// ResolverBatchMetadata tracks batching metadata for DataLoader resolvers.
type ResolverBatchMetadata struct {
	ResolverName string `json:"resolver_name"`
	BatchSize    int    `json:"batch_size"`
	CacheHits    int    `json:"cache_hits"`
	LatencyMs    int64  `json:"latency_ms"`
}

// PartialFailureResult is the GraphQL partial-error envelope.
type PartialFailureResult struct {
	Data   interface{}    `json:"data"`
	Errors []GraphQLError `json:"errors,omitempty"`
}

// GraphQLError is a single error in a GraphQL response.
type GraphQLError struct {
	Message   string                 `json:"message"`
	Locations []GraphQLErrorLocation `json:"locations,omitempty"`
	Path      []interface{}          `json:"path,omitempty"`
	Extensions map[string]interface{} `json:"extensions,omitempty"`
}

// GraphQLErrorLocation identifies where in the query an error occurred.
type GraphQLErrorLocation struct {
	Line   int `json:"line"`
	Column int `json:"column"`
}
