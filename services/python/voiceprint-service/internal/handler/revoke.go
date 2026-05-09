package handler

import (
	"encoding/json"
	"net/http"
	"sync"
	"time"
)

type revocationState string

const (
	statePending   revocationState = "pending"
	stateApproved  revocationState = "approved"
	stateRevoked   revocationState = "revoked"
	stateCompleted revocationState = "completed"
)

type revokeRequest struct {
	VoiceprintID string `json:"voiceprint_id"`
	Reason       string `json:"reason"`
	RequestedBy  string `json:"requested_by"`
}

type revokeResponse struct {
	VoiceprintID string          `json:"voiceprint_id"`
	State        revocationState `json:"state"`
	UpdatedAt    string          `json:"updated_at"`
}

type RevocationHandler struct {
	mu     sync.Mutex
	states map[string]revocationState
}

func NewRevocationHandler() *RevocationHandler {
	return &RevocationHandler{states: make(map[string]revocationState)}
}

func (h *RevocationHandler) transition(id string) revocationState {
	current := h.states[id]
	switch current {
	case "":
		h.states[id] = statePending
	case statePending:
		h.states[id] = stateApproved
	case stateApproved:
		h.states[id] = stateRevoked
	case stateRevoked:
		h.states[id] = stateCompleted
	}
	return h.states[id]
}

func (h *RevocationHandler) Revoke(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req revokeRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "invalid request", http.StatusBadRequest)
		return
	}
	if req.VoiceprintID == "" {
		http.Error(w, "voiceprint_id is required", http.StatusBadRequest)
		return
	}

	h.mu.Lock()
	state := h.transition(req.VoiceprintID)
	h.mu.Unlock()

	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(revokeResponse{
		VoiceprintID: req.VoiceprintID,
		State:        state,
		UpdatedAt:    time.Now().UTC().Format(time.RFC3339),
	})
}
