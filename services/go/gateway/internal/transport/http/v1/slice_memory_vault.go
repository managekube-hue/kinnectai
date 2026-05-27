package v1

import "net/http"

func registerMemoryVaultSlice(mux *http.ServeMux) {
	mux.HandleFunc("GET /memorybox", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "MEMORYBOX_SERVICE_URL", "http://memorybox-service:8090")
	})
	mux.HandleFunc("GET /vault", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "MEMORYBOX_SERVICE_URL", "http://memorybox-service:8090")
	})
	mux.HandleFunc("GET /archive", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "MEMORYBOX_SERVICE_URL", "http://memorybox-service:8090")
	})
	mux.HandleFunc("GET /memory/", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "MEMORYBOX_SERVICE_URL", "http://memorybox-service:8090")
	})
}
