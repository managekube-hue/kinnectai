FROM golang:1.22-alpine AS builder

WORKDIR /build
COPY go.mod ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o identity-service ./cmd/api

FROM alpine:3.19
RUN apk add --no-cache ca-certificates curl

WORKDIR /app
COPY --from=builder /build/identity-service .

EXPOSE 8001
HEALTHCHECK --interval=10s --timeout=5s --start-period=5s --retries=3 \
  CMD curl -fsS http://localhost:8001/health || exit 1

ENTRYPOINT ["./identity-service"]
