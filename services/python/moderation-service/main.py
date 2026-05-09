from __future__ import annotations

from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI(title="kinnect-moderation-service", version="1.0.0")


class ModerateRequest(BaseModel):
    content: str
    content_id: str
    author_id: str


class ModerateResponse(BaseModel):
    decision: str
    reasons: list[str]


BLOCKED_TERMS = {"kill", "terror", "exploit", "dox"}


@app.get("/healthz")
def healthz() -> dict[str, str]:
    return {"status": "ok"}


@app.post("/moderate", response_model=ModerateResponse)
def moderate(payload: ModerateRequest) -> ModerateResponse:
    content = payload.content.lower()
    reasons = [f"matched_term:{term}" for term in BLOCKED_TERMS if term in content]
    decision = "review" if reasons else "allow"
    return ModerateResponse(decision=decision, reasons=reasons)
