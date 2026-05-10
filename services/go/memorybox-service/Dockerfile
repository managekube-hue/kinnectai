FROM golang:1.22-alpine AS builder

WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o memorybox-service ./cmd/api

FROM alpine:3.19
RUN apk add --no-cache ca-certificates

WORKDIR /app
COPY --from=builder /build/memorybox-service .

EXPOSE 8090
HEALTHCHECK --interval=10s --timeout=5s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8090/healthz || exit 1

ENTRYPOINT ["./memorybox-service"]
