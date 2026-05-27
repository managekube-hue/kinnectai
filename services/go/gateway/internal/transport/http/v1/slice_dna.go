package v1

import "net/http"

func registerDNASlice(mux *http.ServeMux) {
	mux.HandleFunc("GET /dna", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "DNA_INGEST_SERVICE_URL", "http://dna-ingest-service:8008")
	})
	mux.HandleFunc("POST /dna/upload", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "DNA_INGEST_SERVICE_URL", "http://dna-ingest-service:8008")
	})
	mux.HandleFunc("GET /dna/results", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "DNA_INGEST_SERVICE_URL", "http://dna-ingest-service:8008")
	})
	mux.HandleFunc("GET /dna/matches", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "DNA_INGEST_SERVICE_URL", "http://dna-ingest-service:8008")
	})
	mux.HandleFunc("GET /dna/insights", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "DNA_INGEST_SERVICE_URL", "http://dna-ingest-service:8008")
	})
}
