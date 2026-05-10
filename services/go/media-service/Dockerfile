FROM golang:1.22-alpine AS builder

WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o media-service ./cmd/api

FROM jrottenberg/ffmpeg:5.1-alpine

RUN apk add --no-cache ca-certificates

WORKDIR /app
COPY --from=builder /build/media-service .

EXPOSE 8088
HEALTHCHECK --interval=10s --timeout=5s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8088/healthz || exit 1

ENTRYPOINT ["./media-service"]
