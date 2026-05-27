package v1

import "net/http"

func registerBehavioralSlice(mux *http.ServeMux) {
	mux.HandleFunc("POST /pulses", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "BEHAVIORAL_SERVICE_URL", "http://behavioral-service:8002")
	})
	mux.HandleFunc("GET /pulses", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "BEHAVIORAL_SERVICE_URL", "http://behavioral-service:8002")
	})
	mux.HandleFunc("GET /analytics", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "BEHAVIORAL_SERVICE_URL", "http://behavioral-service:8002")
	})
	mux.HandleFunc("GET /activity", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "BEHAVIORAL_SERVICE_URL", "http://behavioral-service:8002")
	})
	mux.HandleFunc("GET /engagement", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "BEHAVIORAL_SERVICE_URL", "http://behavioral-service:8002")
	})
}
