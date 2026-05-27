package v1

import "net/http"

func registerCommerceSlice(mux *http.ServeMux) {
	mux.HandleFunc("GET /billing", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "PAYMENT_SERVICE_URL", "http://payment-service:8093")
	})
	mux.HandleFunc("GET /subscription", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "PAYMENT_SERVICE_URL", "http://payment-service:8093")
	})
	mux.HandleFunc("POST /checkout", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "PAYMENT_SERVICE_URL", "http://payment-service:8093")
	})
	mux.HandleFunc("GET /orders", func(w http.ResponseWriter, req *http.Request) {
		proxyToService(w, req, "PAYMENT_SERVICE_URL", "http://payment-service:8093")
	})
}
