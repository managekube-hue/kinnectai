package v1

import "net/http"

func registerIdentitySlice(mux *http.ServeMux) {
	mux.HandleFunc("POST /auth/signup", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "IDENTITY_SERVICE_URL", "http://identity-service:8001")
	})
		mux.HandleFunc("POST /auth/register", func(w http.ResponseWriter, req *http.Request) {
			proxyToService(w, req, "IDENTITY_SERVICE_URL", "http://identity-service:8001")
		})
	mux.HandleFunc("POST /auth/login", func(w http.ResponseWriter, req *http.Request) {
		req.URL.Path = "/v1/auth/token"
		proxyToService(w, req, "IDENTITY_SERVICE_URL", "http://identity-service:8001")
	})
	mux.HandleFunc("POST /auth/validate", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "IDENTITY_SERVICE_URL", "http://identity-service:8001")
	})
	mux.HandleFunc("POST /auth/logout", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "IDENTITY_SERVICE_URL", "http://identity-service:8001")
	})
	mux.HandleFunc("GET /account", func(w http.ResponseWriter, req *http.Request) {
		req.URL.Path = "/v1/users/me"
		proxyToService(w, req, "IDENTITY_SERVICE_URL", "http://identity-service:8001")
	})
	mux.HandleFunc("PATCH /settings", func(w http.ResponseWriter, req *http.Request) {
		req.URL.Path = "/v1/users/me"
		proxyToService(w, req, "IDENTITY_SERVICE_URL", "http://identity-service:8001")
	})
	mux.HandleFunc("GET /security", func(w http.ResponseWriter, req *http.Request) {
		req.URL.Path = "/v1/users/me"
		proxyToService(w, req, "IDENTITY_SERVICE_URL", "http://identity-service:8001")
	})
}
