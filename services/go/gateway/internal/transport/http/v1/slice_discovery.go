package v1

import "net/http"

func registerDiscoverySlice(mux *http.ServeMux) {
	mux.HandleFunc("GET /discover", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "DISCOVERY_SERVICE_URL", "http://discovery-service:8004")
	})
	mux.HandleFunc("GET /matches", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "DISCOVERY_SERVICE_URL", "http://discovery-service:8004")
	})
	mux.HandleFunc("GET /suggestions", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "DISCOVERY_SERVICE_URL", "http://discovery-service:8004")
	})
	mux.HandleFunc("GET /connections", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "DISCOVERY_SERVICE_URL", "http://discovery-service:8004")
	})
	mux.HandleFunc("GET /feed", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "FEED_SERVICE_URL", "http://feed-service:8080")
	})
}
