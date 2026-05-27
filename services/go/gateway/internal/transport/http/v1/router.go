package v1

import (
	"fmt"
	"net/http"

	"gateway/internal/domain/auth"
)

// Router handles API v1 routing and request forwarding
type Router struct {
	authService *auth.AuthService
	mux         *http.ServeMux
}

// NewRouter creates a new API v1 router
func NewRouter(authService *auth.AuthService) *Router {
	r := &Router{
		authService: authService,
		mux:         http.NewServeMux(),
	}

	registerIdentitySlice(r.mux)
	registerKinshipGraphSlice(r.mux)
	registerDiscoverySlice(r.mux)
	registerBehavioralSlice(r.mux)
	registerMemoryVaultSlice(r.mux)
	registerMediaSlice(r.mux)
	registerRealtimeSlice(r.mux)
	registerDNASlice(r.mux)
	registerCommerceSlice(r.mux)

	// Health checks
	r.mux.HandleFunc("GET /health", r.handleHealth)

	return r
}

// ServeHTTP implements http.Handler interface
func (r *Router) ServeHTTP(w http.ResponseWriter, req *http.Request) {
	r.mux.ServeHTTP(w, req)
}

// Health Check

func (r *Router) handleHealth(w http.ResponseWriter, req *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, `{"status":"healthy","service":"api-v1"}`)
}
