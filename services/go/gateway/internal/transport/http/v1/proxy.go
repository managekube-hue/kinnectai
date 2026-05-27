package v1

import (
	"bytes"
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"
	"time"
)

func proxyToService(w http.ResponseWriter, req *http.Request, envKey, defaultBaseURL string) {
	baseURL := strings.TrimRight(os.Getenv(envKey), "/")
	if baseURL == "" {
		baseURL = defaultBaseURL
	}

	targetPath := req.URL.Path
	if req.URL.RawQuery != "" {
		targetPath += "?" + req.URL.RawQuery
	}

	body, err := io.ReadAll(req.Body)
	if err != nil {
		http.Error(w, "failed to read request body", http.StatusBadRequest)
		return
	}

	upstreamReq, err := http.NewRequestWithContext(req.Context(), req.Method, baseURL+targetPath, bytes.NewReader(body))
	if err != nil {
		http.Error(w, "failed to build upstream request", http.StatusInternalServerError)
		return
	}

	for k, vals := range req.Header {
		for _, v := range vals {
			upstreamReq.Header.Add(k, v)
		}
	}
	if upstreamReq.Header.Get("Content-Type") == "" {
		upstreamReq.Header.Set("Content-Type", "application/json")
	}

	client := &http.Client{Timeout: 20 * time.Second}
	upstreamResp, err := client.Do(upstreamReq)
	if err != nil {
		http.Error(w, fmt.Sprintf("%s unavailable", strings.ToLower(strings.TrimSuffix(envKey, "_URL"))), http.StatusBadGateway)
		return
	}
	defer upstreamResp.Body.Close()

	for k, vals := range upstreamResp.Header {
		for _, v := range vals {
			w.Header().Add(k, v)
		}
	}
	w.WriteHeader(upstreamResp.StatusCode)
	_, _ = io.Copy(w, upstreamResp.Body)
}
