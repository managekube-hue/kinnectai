package v1

import "net/http"

func registerRealtimeSlice(mux *http.ServeMux) {
	mux.HandleFunc("GET /rooms", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "ROOMS_SERVICE_URL", "http://rooms-service:8083")
	})
	mux.HandleFunc("POST /rooms", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "ROOMS_SERVICE_URL", "http://rooms-service:8083")
	})
	mux.HandleFunc("GET /room/", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "ROOMS_SERVICE_URL", "http://rooms-service:8083")
	})
	mux.HandleFunc("GET /live", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "ROOMS_SERVICE_URL", "http://rooms-service:8083")
	})
	mux.HandleFunc("GET /chat", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "ROOMS_SERVICE_URL", "http://rooms-service:8083")
	})
}
