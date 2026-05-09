# Kernel Service

Kernel orchestration and intelligence core.

Responsibilities:
- Coordinate scoring/intelligence workflows used by other services.
- Expose kernel APIs for score calculation and explainability.

Out of scope:
- Feed assembly and timeline serving (owned by feed-service).
- Candidate generation (owned by discovery-service).
- Behavioral event pipelines (owned by behavioral-service).

## Local development

```bash
cd services/python/kernel-service
pip install -r requirements.txt
python -m app.main
```

## Docker

```bash
docker build -t kinnectai/kernel-service ./services/python/kernel-service
```
