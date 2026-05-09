package main

import (
	"encoding/json"
	"log"
	"net/http"
	"strings"
)

type ModerateRequest struct {
	Content   string `json:"content"`
	ContentID string `json:"content_id"`
	AuthorID  string `json:"author_id"`
}

type ModerateResponse struct {
	Decision string   `json:"decision"`
	Reasons  []string `json:"reasons"`
}

func moderateHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req ModerateRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "invalid request body", http.StatusBadRequest)
		return
	}

	decision := "allow"
	reasons := make([]string, 0)
	content := strings.ToLower(req.Content)

	blockedTerms := []string{"kill", "terror", "exploit", "dox"}
	for _, term := range blockedTerms {
		if strings.Contains(content, term) {
			decision = "review"
			reasons = append(reasons, "matched_term:"+term)
		}
	}

	resp := ModerateResponse{Decision: decision, Reasons: reasons}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(resp)
}

func healthHandler(w http.ResponseWriter, _ *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	_, _ = w.Write([]byte(`{"status":"ok"}`))
}

func main() {
	mux := http.NewServeMux()
	mux.HandleFunc("/healthz", healthHandler)
	mux.HandleFunc("/moderate", moderateHandler)

	log.Println("moderation-service listening on :8094")
	if err := http.ListenAndServe(":8094", mux); err != nil {
		log.Fatal(err)
	}
}
