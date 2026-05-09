package moderation

import (
	"context"
	"encoding/json"
	"errors"
	"strings"
	"testing"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/segmentio/kafka-go"
)

type mockReportStore struct {
	lastSQL  string
	lastArgs []interface{}
	err      error
}

func (m *mockReportStore) Exec(_ context.Context, sql string, args ...interface{}) (pgconn.CommandTag, error) {
	m.lastSQL = sql
	m.lastArgs = args
	if m.err != nil {
		return pgconn.CommandTag{}, m.err
	}
	return pgconn.CommandTag{}, nil
}

type mockKafkaWriter struct {
	messages []kafka.Message
	err      error
}

func (m *mockKafkaWriter) WriteMessages(_ context.Context, msgs ...kafka.Message) error {
	m.messages = append(m.messages, msgs...)
	if m.err != nil {
		return m.err
	}
	return nil
}

func TestServiceDeterminePriority(t *testing.T) {
	svc := &Service{}

	cases := []struct {
		reason   string
		expected string
	}{
		{reason: "harassment", expected: reportPriorityUrgent},
		{reason: "hate_speech", expected: reportPriorityUrgent},
		{reason: "spam", expected: reportPriorityHigh},
		{reason: "misinformation", expected: reportPriorityHigh},
		{reason: "privacy_violation", expected: reportPriorityNormal},
		{reason: "something_else", expected: reportPriorityLow},
	}

	for _, tc := range cases {
		if got := svc.determinePriority(tc.reason); got != tc.expected {
			t.Fatalf("determinePriority(%q) = %q, want %q", tc.reason, got, tc.expected)
		}
	}
}

func TestCreateReportPersistsAndQueuesTask(t *testing.T) {
	db := &mockReportStore{}
	kafkaWriter := &mockKafkaWriter{}
	svc := &Service{db: db, kafkaWriter: kafkaWriter, kafkaTopic: "moderation-reports"}

	reporterID := uuid.New()
	req := CreateReportRequest{
		ContentID: "memory_123",
		Reason:    "hate_speech",
		Details:   "sample details",
	}

	resp, err := svc.CreateReport(context.Background(), reporterID, req)
	if err != nil {
		t.Fatalf("CreateReport returned error: %v", err)
	}

	if resp.Status != reportStatusPending {
		t.Fatalf("unexpected status: got %q want %q", resp.Status, reportStatusPending)
	}
	if resp.ReportID == uuid.Nil {
		t.Fatal("expected non-nil report ID")
	}
	if resp.ReporterID != reporterID {
		t.Fatalf("unexpected reporter ID: got %s want %s", resp.ReporterID, reporterID)
	}

	if !strings.Contains(db.lastSQL, "INSERT INTO moderation_reports") {
		t.Fatalf("expected insert SQL, got %q", db.lastSQL)
	}
	if len(db.lastArgs) != 9 {
		t.Fatalf("unexpected arg count: got %d want 9", len(db.lastArgs))
	}
	if gotPriority, ok := db.lastArgs[7].(string); !ok || gotPriority != reportPriorityUrgent {
		t.Fatalf("expected urgent priority in DB args, got %#v", db.lastArgs[7])
	}

	if len(kafkaWriter.messages) != 1 {
		t.Fatalf("expected 1 kafka message, got %d", len(kafkaWriter.messages))
	}

	var payload map[string]interface{}
	if err := json.Unmarshal(kafkaWriter.messages[0].Value, &payload); err != nil {
		t.Fatalf("failed to decode kafka payload: %v", err)
	}
	if payload["priority"] != reportPriorityUrgent {
		t.Fatalf("unexpected queued priority: got %v want %q", payload["priority"], reportPriorityUrgent)
	}
	if payload["reason"] != req.Reason {
		t.Fatalf("unexpected queued reason: got %v want %q", payload["reason"], req.Reason)
	}
}

func TestCreateReportReturnsErrorWhenInsertFails(t *testing.T) {
	db := &mockReportStore{err: errors.New("insert failed")}
	kafkaWriter := &mockKafkaWriter{}
	svc := &Service{db: db, kafkaWriter: kafkaWriter, kafkaTopic: "moderation-reports"}

	_, err := svc.CreateReport(context.Background(), uuid.New(), CreateReportRequest{ContentID: "x", Reason: "spam"})
	if err == nil {
		t.Fatal("expected error from failed insert")
	}
	if len(kafkaWriter.messages) != 0 {
		t.Fatalf("expected no kafka messages when insert fails, got %d", len(kafkaWriter.messages))
	}
}

func TestCreateReportSucceedsEvenWhenKafkaFails(t *testing.T) {
	db := &mockReportStore{}
	kafkaWriter := &mockKafkaWriter{err: errors.New("kafka down")}
	svc := &Service{db: db, kafkaWriter: kafkaWriter, kafkaTopic: "moderation-reports"}

	resp, err := svc.CreateReport(context.Background(), uuid.New(), CreateReportRequest{ContentID: "x", Reason: "spam"})
	if err != nil {
		t.Fatalf("expected success despite kafka failure, got error: %v", err)
	}
	if resp == nil || resp.ReportID == uuid.Nil {
		t.Fatal("expected valid response")
	}
}
