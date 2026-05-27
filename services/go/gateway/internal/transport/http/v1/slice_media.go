package v1

import "net/http"

func registerMediaSlice(mux *http.ServeMux) {
	mux.HandleFunc("POST /upload", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "MEDIA_SERVICE_URL", "http://media-service:8082")
	})
	mux.HandleFunc("GET /gallery", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "MEDIA_SERVICE_URL", "http://media-service:8082")
	})
	mux.HandleFunc("GET /photos", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "MEDIA_SERVICE_URL", "http://media-service:8082")
	})
	mux.HandleFunc("GET /albums", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "MEDIA_SERVICE_URL", "http://media-service:8082")
	})
	mux.HandleFunc("GET /media/", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "MEDIA_SERVICE_URL", "http://media-service:8082")
	})
}
