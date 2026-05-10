from fastapi import FastAPI
import logging

# Service: photoplay-service
# Port: 8084
# Responsibility: Job queue, ElevenLabs/D-ID/SadTalker orchestration, C2PA watermarking
# Critical Dependencies: Kafka, C2PA SDK, S3

app = FastAPI(title="photoplay-service", version="1.0.0")

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@app.get("/healthz")
def health():
    return {"status": "healthy", "service": "photoplay-service"}

@app.get("/readyz")
def ready():
    return {"ready": True}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8084)
