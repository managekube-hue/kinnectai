.PHONY: dev-stack dev-api test

dev-stack:
	powershell -ExecutionPolicy Bypass -File .\scripts\dev\dev-stack.ps1

dev-api:
	powershell -ExecutionPolicy Bypass -File .\scripts\dev\dev-api.ps1

test:
	@echo "Run service- and app-specific tests from their directories"
