package graph

import (
	"context"
	"encoding/json"
	"fmt"
	"math"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/neo4j/neo4j-go-driver/v5/neo4j"
	"github.com/redis/go-redis/v9"
)

const (
	kinScoreCacheTTL = 10 * time.Minute
	kinScoreCacheKey = "kin_score:%s:%s" // userA:userB (sorted)
)

// Service manages the biological graph and CR score computation.
type Service struct {
	db     *pgxpool.Pool
	neo4j  neo4j.DriverWithContext
	redis  *redis.Client
}

func NewService(db *pgxpool.Pool, neo4j neo4j.DriverWithContext, redis *redis.Client) *Service {
	return &Service{db: db, neo4j: neo4j, redis: redis}
}

// GetKinScore returns the Coefficient of Relationship between two users.
// Checks Redis cache first; falls back to Neo4j graph computation.
func (s *Service) GetKinScore(ctx context.Context, userAID, userBID uuid.UUID) (*KinScoreResult, error) {
	// Normalize: always use lexicographically lower ID as "A"
	a, b := normalizeIDs(userAID, userBID)
	cacheKey := fmt.Sprintf(kinScoreCacheKey, a, b)

	// Cache check
	if cached, err := s.redis.Get(ctx, cacheKey).Bytes(); err == nil {
		var result KinScoreResult
		if json.Unmarshal(cached, &result) == nil {
			result.FromCache = true
			return &result, nil
		}
	}

	// Compute from Neo4j graph
	result, err := s.computeKinScore(ctx, a, b)
	if err != nil {
		return nil, err
	}

	// Cache result
	if data, err := json.Marshal(result); err == nil {
		s.redis.Set(ctx, cacheKey, data, kinScoreCacheTTL)
	}

	return result, nil
}

// computeKinScore runs the shortest-path query in Neo4j and computes CR.
func (s *Service) computeKinScore(ctx context.Context, userAID, userBID string) (*KinScoreResult, error) {
	session := s.neo4j.NewSession(ctx, neo4j.SessionConfig{AccessMode: neo4j.AccessModeRead})
	defer session.Close(ctx)

	result, err := session.Run(ctx, `
		MATCH (a:User {id: $userA}), (b:User {id: $userB})
		MATCH path = shortestPath((a)-[:KINNECTED*..10]-(b))
		RETURN length(path) AS degrees, 
		       [r IN relationships(path) | r.kin_score] AS scores,
		       [r IN relationships(path) | r.relationship_type] AS types`,
		map[string]interface{}{"userA": userAID, "userB": userBID},
	)
	if err != nil {
		return nil, fmt.Errorf("neo4j shortest path: %w", err)
	}

	var degrees int
	var kinScore float64
	var relationshipType string

	if result.Next(ctx) {
		record := result.Record()
		degrees = int(record.Values[0].(int64))
		scores := record.Values[1].([]interface{})
		types := record.Values[2].([]interface{})

		// Compute CR as product of edge CR scores along path
		kinScore = 1.0
		for _, s := range scores {
			if v, ok := s.(float64); ok {
				kinScore *= v
			}
		}

		// Infer relationship from degrees of separation
		if len(types) > 0 {
			relationshipType = inferRelationship(degrees)
		}
	} else {
		// No path found — unrelated
		kinScore = 0.0
		degrees = -1
		relationshipType = "unrelated"
	}

	aUID, _ := uuid.Parse(userAID)
	bUID, _ := uuid.Parse(userBID)

	res := &KinScoreResult{
		UserAID:          aUID,
		UserBID:          bUID,
		KinScore:         kinScore,
		DisplayScore:     kinScoreToDisplay(kinScore),
		RelationshipType: relationshipType,
		Confidence:       computeConfidence(degrees, kinScore),
		DegreesOfSep:     degrees,
		FromCache:        false,
	}

	// Persist to PostgreSQL for history and analytics
	s.persistKinScore(ctx, res)

	return res, nil
}

// RequestKinnection creates a pending Kinnection request.
func (s *Service) RequestKinnection(ctx context.Context, requesterID uuid.UUID, req KinnectionRequest) (*KinnectionResponse, error) {
	id := uuid.New()
	_, err := s.db.Exec(ctx, `
		INSERT INTO kinnections (id, user_a_id, user_b_id, relationship_type, confirmation_method, status, requested_at)
		VALUES ($1, $2, $3, $4, 'identity', 'pending', NOW())
		ON CONFLICT (user_a_id, user_b_id) DO NOTHING`,
		id, requesterID, req.TargetUserID, req.RelationshipType,
	)
	if err != nil {
		return nil, fmt.Errorf("request kinnection: %w", err)
	}
	return &KinnectionResponse{
		ID:               id,
		UserAID:          requesterID,
		UserBID:          req.TargetUserID,
		RelationshipType: req.RelationshipType,
		Status:           "pending",
	}, nil
}

// ConfirmKinnection accepts a pending request and writes the Neo4j edge.
func (s *Service) ConfirmKinnection(ctx context.Context, kinnectionID, userID uuid.UUID) (*KinnectionResponse, error) {
	var k KinnectionResponse
	err := s.db.QueryRow(ctx, `
		UPDATE kinnections
		SET status = 'confirmed', confirmed_at = NOW()
		WHERE id = $1 AND user_b_id = $2 AND status = 'pending'
		RETURNING id, user_a_id, user_b_id, relationship_type, status`,
		kinnectionID, userID,
	).Scan(&k.ID, &k.UserAID, &k.UserBID, &k.RelationshipType, &k.Status)
	if err != nil {
		return nil, fmt.Errorf("confirm kinnection: %w", err)
	}

	// Write Neo4j edge
	if err := s.writeNeo4jEdge(ctx, k); err != nil {
		// Log but don't fail — will be reconciled by background job
		fmt.Printf("warn: neo4j edge write failed for kinnection %s: %v\n", k.ID, err)
	}

	return &k, nil
}

// writeNeo4jEdge persists a confirmed Kinnection as a graph edge.
func (s *Service) writeNeo4jEdge(ctx context.Context, k KinnectionResponse) error {
	session := s.neo4j.NewSession(ctx, neo4j.SessionConfig{AccessMode: neo4j.AccessModeWrite})
	defer session.Close(ctx)

	crScore := relationshipToCR(k.RelationshipType)

	_, err := session.Run(ctx, `
		MERGE (a:User {id: $userA})
		MERGE (b:User {id: $userB})
		MERGE (a)-[r:KINNECTED]-(b)
		SET r.kin_score = $kinScore,
		    r.relationship_type = $relType,
		    r.confirmation_method = 'identity',
		    r.confirmed_at = datetime()`,
		map[string]interface{}{
			"userA":    k.UserAID.String(),
			"userB":    k.UserBID.String(),
			"kinScore": crScore,
			"relType":  k.RelationshipType,
		},
	)
	return err
}

func (s *Service) persistKinScore(ctx context.Context, r *KinScoreResult) {
	s.db.Exec(ctx, `
		INSERT INTO kin_scores (user_a_id, user_b_id, kin_score, relationship, confidence, computed_at)
		VALUES ($1, $2, $3, $4, $5, NOW())
		ON CONFLICT (user_a_id, user_b_id) DO UPDATE
		SET kin_score = $3, relationship = $4, confidence = $5, computed_at = NOW()`,
		r.UserAID, r.UserBID, r.KinScore, r.RelationshipType, r.Confidence,
	)
}

// ─── Helpers ────────────────────────────────────────────────────────────────

func normalizeIDs(a, b uuid.UUID) (string, string) {
	as, bs := a.String(), b.String()
	if as < bs {
		return as, bs
	}
	return bs, as
}

// kinScoreToDisplay converts 0.0–1.0 CR to a 0–100 user-facing score.
func kinScoreToDisplay(cr float64) int {
	if cr <= 0 {
		return 0
	}
	// Log scale: 0.5 (sibling) → 100, 0.002 (6th cousin) → ~10
	display := int(math.Round((math.Log(cr/0.001) / math.Log(0.5/0.001)) * 100))
	if display < 0 {
		return 0
	}
	if display > 100 {
		return 100
	}
	return display
}

func computeConfidence(degrees int, kinScore float64) float64 {
	if degrees < 0 {
		return 0.0
	}
	// Confidence decreases with degrees of separation
	return math.Max(0, 1.0-float64(degrees)*0.1)
}

func inferRelationship(degrees int) string {
	switch degrees {
	case 1:
		return "parent_or_child"
	case 2:
		return "sibling_or_grandparent"
	case 3:
		return "first_cousin"
	case 4:
		return "second_cousin"
	case 5:
		return "third_cousin"
	default:
		return "distant_kin"
	}
}

func relationshipToCR(relType string) float64 {
	switch relType {
	case "parent", "child":
		return 0.50
	case "sibling":
		return 0.50
	case "half_sibling":
		return 0.25
	case "grandparent", "grandchild":
		return 0.25
	case "first_cousin":
		return 0.125
	case "second_cousin":
		return 0.03125
	default:
		return 0.0625 // default: first cousin once removed
	}
}
