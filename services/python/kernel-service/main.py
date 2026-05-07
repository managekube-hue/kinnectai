from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import os
from kin_score_algorithm import KCKernel

app = FastAPI(title="Kinnection Coefficient Kernel", version="1.0.0")

class BioIdentityVector(BaseModel):
    user_a_id: str
    user_b_id: str

_kernel: KCKernel | None = None


def get_kernel() -> KCKernel:
    global _kernel
    if _kernel is None:
        pg_dsn = os.getenv(
            "POSTGRES_DSN",
            "postgresql://kinnect:kinnect_dev_password@localhost:5432/kinnectai",
        )
        neo4j_uri = os.getenv("NEO4J_URI", "bolt://localhost:7687")
        neo4j_user = os.getenv("NEO4J_USER", "neo4j")
        neo4j_pass = os.getenv("NEO4J_PASSWORD", "kinnect_neo4j_password")
        cassandra_hosts = os.getenv("CASSANDRA_HOSTS", "localhost").split(",")
        cassandra_keyspace = os.getenv("CASSANDRA_KEYSPACE", "kinnectai_events")
        _kernel = KCKernel(
            pg_dsn,
            neo4j_uri,
            neo4j_user,
            neo4j_pass,
            cassandra_hosts,
            cassandra_keyspace,
        )
    return _kernel

@app.get("/health")
def health_check():
    return {"status": "healthy", "service": "kernel-service"}

@app.post("/v1/kernel/score")
def calculate_kin_score(payload: BioIdentityVector):
    try:
        kernel = get_kernel()
        result = kernel.calculate_kin_score(payload.user_a_id, payload.user_b_id)
        return result
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc))
