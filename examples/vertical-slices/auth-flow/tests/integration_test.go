// Integration Test - Complete Auth Flow
// This tests the entire vertical slice end-to-end

package tests

import (
	"bytes"
	"context"
	"encoding/json"
	"net/http"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// TestCompleteAuthFlow tests mobile -> gateway -> service -> db -> kafka
func TestCompleteAuthFlow(t *testing.T) {
	// Setup: spin up all services
	setup := setupTestEnvironment(t)
	defer setup.cleanup()

	ctx := context.Background()

	// 1. Mobile makes login request to gateway
	loginRequest := map[string]string{
		"email":    "user@example.com",
		"password": "password123",
	}

	body, _ := json.Marshal(loginRequest)
	req, _ := http.NewRequestWithContext(ctx, "POST", 
		"http://localhost:8080/api/v1/login", bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")

	// 2. Gateway forwards to identity-service
	resp, err := http.DefaultClient.Do(req)
	require.NoError(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)

	var loginResponse map[string]interface{}
	json.NewDecoder(resp.Body).Decode(&loginResponse)
	
	token := loginResponse["token"].(string)
	userId := loginResponse["user"].(map[string]interface{})["id"].(string)

	assert.NotEmpty(t, token)
	assert.NotEmpty(t, userId)

	// 3. Verify user persisted in PostgreSQL
	user := setup.getUser(ctx, userId)
	assert.Equal(t, "user@example.com", user.Email)
	assert.NotNil(t, user.LastLoginAt)

	// 4. Verify session created in PostgreSQL
	session := setup.getSession(ctx, userId, token)
	assert.NotNil(t, session)

	// 5. Verify user.login.success event published to Kafka
	event := setup.getKafkaEvent(ctx, "user.login.success", userId, 5*time.Second)
	assert.NotNil(t, event)
	assert.Equal(t, "user@example.com", event["email"])

	// 6. Verify trace spans recorded in observability
	spans := setup.getTraceSpans(ctx, userId)
	assert.Contains(t, spans, "user.login")
	assert.Contains(t, spans, "db.query")
	assert.Contains(t, spans, "kafka.publish")

	// 7. Mobile makes authenticated request with token
	profileReq, _ := http.NewRequestWithContext(ctx, "GET", 
		"http://localhost:8080/api/v1/profile/"+userId, nil)
	profileReq.Header.Set("Authorization", "Bearer "+token)

	profileResp, err := http.DefaultClient.Do(profileReq)
	require.NoError(t, err)
	assert.Equal(t, http.StatusOK, profileResp.StatusCode)

	// 8. Verify second login creates new session
	resp2, _ := http.DefaultClient.Do(req)
	var loginResponse2 map[string]interface{}
	json.NewDecoder(resp2.Body).Decode(&loginResponse2)
	
	token2 := loginResponse2["token"].(string)
	assert.NotEqual(t, token, token2)

	sessions := setup.getSessionsForUser(ctx, userId)
	assert.Equal(t, 2, len(sessions))
}

// Helper functions
type testSetup struct {
	t *testing.T
	// test infrastructure references
}

func setupTestEnvironment(t *testing.T) *testSetup {
	// Start services in containers or in-memory
	// Initialize databases
	// Return setup with cleanup function
	return &testSetup{t: t}
}

func (s *testSetup) cleanup() {
	// Stop services
	// Cleanup databases
}

func (s *testSetup) getUser(ctx context.Context, userId string) map[string]interface{} {
	// Query PostgreSQL for user
	return nil
}

func (s *testSetup) getSession(ctx context.Context, userId string, token string) map[string]interface{} {
	// Query PostgreSQL for session
	return nil
}

func (s *testSetup) getKafkaEvent(ctx context.Context, eventType string, userId string, timeout time.Duration) map[string]interface{} {
	// Consume from Kafka topic with timeout
	return nil
}

func (s *testSetup) getTraceSpans(ctx context.Context, traceId string) []string {
	// Query observability backend for spans
	return nil
}

func (s *testSetup) getSessionsForUser(ctx context.Context, userId string) []map[string]interface{} {
	// Query PostgreSQL for all sessions
	return nil
}
