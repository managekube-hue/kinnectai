package middleware

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"sync"
	"strings"
	"time"

	"gateway/internal/domain/auth"
)

// Middleware is a handler wrapper
type Middleware func(http.Handler) http.Handler

// Chain applies multiple middlewares in order (FIFO)
func Chain(middlewares ...Middleware) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		for i := len(middlewares) - 1; i >= 0; i-- {
			next = middlewares[i](next)
		}
		return next
	}
}

// RequestLogging logs incoming HTTP requests and responses
func RequestLogging(logger *log.Logger) Middleware {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			start := time.Now()
			
			logger.Printf("%s %s %s (from %s)",
				r.Method,
				r.RequestURI,
				r.Proto,
				r.RemoteAddr,
			)

			// Wrap response writer to capture status code
			wrapped := &statusCodeWriter{ResponseWriter: w}
			next.ServeHTTP(wrapped, r)

			duration := time.Since(start)
			logger.Printf("%s %s -> %d (took %v)",
				r.Method,
				r.RequestURI,
				wrapped.StatusCode,
				duration,
			)
		})
	}
}

// CORS enables cross-origin requests
func CORS(allowedOrigins []string) Middleware {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			origin := r.Header.Get("Origin")
			
			// Check if origin is allowed
			originAllowed := false
			for _, allowedOrigin := range allowedOrigins {
				if allowedOrigin == "*" || allowedOrigin == origin {
					originAllowed = true
					break
				}
			}

			if originAllowed {
				w.Header().Set("Access-Control-Allow-Origin", origin)
				w.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
				w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
				w.Header().Set("Access-Control-Max-Age", "3600")
			}

			if r.Method == http.MethodOptions {
				w.WriteHeader(http.StatusOK)
				return
			}

			next.ServeHTTP(w, r)
		})
	}
}

// Authentication validates JWT tokens in Authorization header
func Authentication(authService *auth.AuthService) Middleware {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			// Skip auth for health/ready endpoints
			if r.URL.Path == "/health" || r.URL.Path == "/ready" || r.URL.Path == "/metrics" ||
				r.URL.Path == "/auth/signup" || r.URL.Path == "/auth/register" ||
				r.URL.Path == "/auth/login" || r.URL.Path == "/auth/token" ||
				r.URL.Path == "/auth/validate" || r.URL.Path == "/auth/logout" ||
				r.URL.Path == "/feed" || r.URL.Path == "/line" ||
				r.URL.Path == "/v1/auth/signup" || r.URL.Path == "/v1/auth/login" ||
				r.URL.Path == "/v1/auth/token" || r.URL.Path == "/v1/auth/validate" ||
				r.URL.Path == "/v1/auth/logout" || r.URL.Path == "/v1/users" {
				next.ServeHTTP(w, r)
				return
			}

			// Extract token from Authorization header
			authHeader := r.Header.Get("Authorization")
			if authHeader == "" {
				http.Error(w, "Missing authorization header", http.StatusUnauthorized)
				return
			}

			parts := strings.SplitN(authHeader, " ", 2)
			if len(parts) != 2 || parts[0] != "Bearer" {
				http.Error(w, "Invalid authorization header format", http.StatusUnauthorized)
				return
			}

			token := parts[1]

			// Validate token
			claims, err := authService.ValidateToken(r.Context(), token)
			if err != nil {
				http.Error(w, fmt.Sprintf("Invalid token: %v", err), http.StatusUnauthorized)
				return
			}

			// Add claims to request context
			ctx := context.WithValue(r.Context(), "user_id", claims.UserID)
			ctx = context.WithValue(ctx, "token_claims", claims)
			
			next.ServeHTTP(w, r.WithContext(ctx))
		})
	}
}

// RateLimit implements token bucket rate limiting per user
func RateLimit(requestsPerSecond int) Middleware {
	type limiterState struct {
		tokens     float64
		lastRefill time.Time
	}

	var (
		mu       sync.Mutex
		states   = map[string]*limiterState{}
		capacity = float64(requestsPerSecond)
		rate     = float64(requestsPerSecond)
	)

	if requestsPerSecond <= 0 {
		capacity = 1000
		rate = 1000
	}

	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			key := r.RemoteAddr
			if userID, ok := r.Context().Value("user_id").(string); ok && userID != "" {
				key = userID
			}

			now := time.Now()
			mu.Lock()
			state, ok := states[key]
			if !ok {
				state = &limiterState{tokens: capacity, lastRefill: now}
				states[key] = state
			}

			elapsed := now.Sub(state.lastRefill).Seconds()
			state.tokens += elapsed * rate
			if state.tokens > capacity {
				state.tokens = capacity
			}
			state.lastRefill = now

			if state.tokens < 1 {
				mu.Unlock()
				http.Error(w, "Rate limit exceeded", http.StatusTooManyRequests)
				return
			}
			state.tokens -= 1
			mu.Unlock()

			next.ServeHTTP(w, r)
		})
	}
}

// ErrorHandling catches panics and converts to HTTP 500 responses
func ErrorHandling() Middleware {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			defer func() {
				if err := recover(); err != nil {
					w.Header().Set("Content-Type", "application/json")
					w.WriteHeader(http.StatusInternalServerError)
					fmt.Fprintf(w, `{"error":"Internal server error","status":500}`)
				}
			}()

			next.ServeHTTP(w, r)
		})
	}
}

// statusCodeWriter wraps ResponseWriter to capture status code
type statusCodeWriter struct {
	http.ResponseWriter
	StatusCode int
}

func (w *statusCodeWriter) WriteHeader(statusCode int) {
	w.StatusCode = statusCode
	w.ResponseWriter.WriteHeader(statusCode)
}

func (w *statusCodeWriter) Write(b []byte) (int, error) {
	if w.StatusCode == 0 {
		w.StatusCode = http.StatusOK
	}
	return w.ResponseWriter.Write(b)
}
