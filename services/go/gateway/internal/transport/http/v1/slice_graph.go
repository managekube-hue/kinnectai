package v1

import "net/http"

func registerKinshipGraphSlice(mux *http.ServeMux) {
	mux.HandleFunc("GET /tree/", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "KIN_GRAPH_SERVICE_URL", "http://kin-graph-service:8081")
	})
	mux.HandleFunc("GET /lineage", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "KIN_GRAPH_SERVICE_URL", "http://kin-graph-service:8081")
	})
	mux.HandleFunc("GET /ancestors", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "KIN_GRAPH_SERVICE_URL", "http://kin-graph-service:8081")
	})
	mux.HandleFunc("GET /descendants", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "KIN_GRAPH_SERVICE_URL", "http://kin-graph-service:8081")
	})
	mux.HandleFunc("GET /family-map", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "KIN_GRAPH_SERVICE_URL", "http://kin-graph-service:8081")
	})
	mux.HandleFunc("POST /graph/relationships", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "KIN_GRAPH_SERVICE_URL", "http://kin-graph-service:8081")
	})
}
