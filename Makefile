.PHONY: all lint test build proto-generate dev-up dev-down ci release

# Delegate to Taskfile for cross-language orchestration
all: lint test build

lint:
	@task lint

test:
	@task test

build:
	@task build

proto-generate:
	@task proto-generate

dev-up:
	@task dev-up

dev-down:
	docker compose down

ci: lint test build

release:
	@echo "🔒 Releasing version $(VERSION)"
	@task build
	@docker build -t kinnectai/gateway:$(VERSION) services/gateway
	@docker push kinnectai/gateway:$(VERSION)
	@kubectl set image deployment/gateway gateway=kinnectai/gateway:$(VERSION) -n prod
