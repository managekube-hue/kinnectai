package moderation

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

type fakeReportCreator struct {
	resp       *ReportResponse
	err        error
	called     bool
	reporterID uuid.UUID
	req        CreateReportRequest
}

func (f *fakeReportCreator) CreateReport(_ context.Context, reporterID uuid.UUID, req CreateReportRequest) (*ReportResponse, error) {
	f.called = true
	f.reporterID = reporterID
	f.req = req
	if f.err != nil {
		return nil, f.err
	}
	return f.resp, nil
}

func TestReportContentCreatesReport(t *testing.T) {
	gin.SetMode(gin.TestMode)

	reporterID := uuid.New()
	service := &fakeReportCreator{
		resp: &ReportResponse{
			ReportID:   uuid.New(),
			Status:     reportStatusPending,
			ReporterID: reporterID,
		},
	}

	h := NewHandler(service)
	r := gin.New()
	r.Use(func(c *gin.Context) {
		c.Set("user_id", reporterID.String())
		c.Next()
	})

	group := r.Group("/moderation")
	h.RegisterRoutes(group)

	body, _ := json.Marshal(CreateReportRequest{
		ContentID: "memory_123",
		Reason:    "spam",
		Details:   "details",
	})

	req := httptest.NewRequest(http.MethodPost, "/moderation/report", bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	if w.Code != http.StatusCreated {
		t.Fatalf("unexpected status: got %d want %d", w.Code, http.StatusCreated)
	}
	if !service.called {
		t.Fatal("expected service CreateReport to be called")
	}
	if service.reporterID != reporterID {
		t.Fatalf("unexpected reporter id: got %s want %s", service.reporterID, reporterID)
	}
	if service.req.ContentID != "memory_123" || service.req.Reason != "spam" {
		t.Fatalf("unexpected request payload: %+v", service.req)
	}
}

func TestReportContentReturnsUnauthorizedWithoutUser(t *testing.T) {
	gin.SetMode(gin.TestMode)

	h := NewHandler(&fakeReportCreator{})
	r := gin.New()
	group := r.Group("/moderation")
	h.RegisterRoutes(group)

	body, _ := json.Marshal(CreateReportRequest{ContentID: "x", Reason: "spam"})
	req := httptest.NewRequest(http.MethodPost, "/moderation/report", bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	if w.Code != http.StatusUnauthorized {
		t.Fatalf("unexpected status: got %d want %d", w.Code, http.StatusUnauthorized)
	}
}

func TestReportContentReturnsInternalServerErrorOnServiceFailure(t *testing.T) {
	gin.SetMode(gin.TestMode)

	reporterID := uuid.New()
	service := &fakeReportCreator{err: errors.New("db error")}
	h := NewHandler(service)
	r := gin.New()
	r.Use(func(c *gin.Context) {
		c.Set("user_id", reporterID.String())
		c.Next()
	})

	group := r.Group("/moderation")
	h.RegisterRoutes(group)

	body, _ := json.Marshal(CreateReportRequest{ContentID: "x", Reason: "spam"})
	req := httptest.NewRequest(http.MethodPost, "/moderation/report", bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	if w.Code != http.StatusInternalServerError {
		t.Fatalf("unexpected status: got %d want %d", w.Code, http.StatusInternalServerError)
	}
}
