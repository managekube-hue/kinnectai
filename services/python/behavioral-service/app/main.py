from fastapi import FastAPI
import logging

# Service: behavioral-service
# Port: 8087
# Responsibility: Kafka ingestion, Layer 4/5 aggregation, sentiment NLP, ATT compliance
# Critical Dependencies: Kafka, Cassandra, LexisNexis Metabase

app = FastAPI(title="behavioral-service", version="1.0.0")

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@app.get("/healthz")
def health():
    return {"status": "healthy", "service": "behavioral-service"}

@app.get("/readyz")
def ready():
    return {"ready": True}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8087)
