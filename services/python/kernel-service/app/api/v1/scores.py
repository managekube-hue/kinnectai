"""API v1 routes for kernel service."""
from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from app.infrastructure.postgres.repository import KinScoreRepository
from app.infrastructure.kafka.producer import EventProducer
from app.application.commands.compute_score import ComputeKinScoreCommand, ComputeKinScoreHandler


router = APIRouter(prefix="/api/v1", tags=["kernel"])


class ComputeScoreRequest(BaseModel):
    user_id: str
    match_id: str
    data: dict


class KinScoreResponse(BaseModel):
    id: str
    user_id: str
    match_id: str
    score: float
    confidence: float
    status: str


@router.post("/scores/compute", response_model=KinScoreResponse)
async def compute_score(req: ComputeScoreRequest, repo: KinScoreRepository = Depends()):
    """Compute kinship score."""
    cmd = ComputeKinScoreCommand()
    cmd.user_id = req.user_id
    cmd.match_id = req.match_id
    cmd.data = req.data

    producer = EventProducer(["localhost:9092"])
    handler = ComputeKinScoreHandler(repo, producer)

    try:
        score = handler.handle(cmd)
        producer.close()
        return KinScoreResponse(
            id=score.id,
            user_id=score.user_id,
            match_id=score.match_id,
            score=score.score,
            confidence=score.confidence,
            status=score.status.value,
        )
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/scores/{score_id}", response_model=KinScoreResponse)
async def get_score(score_id: str, repo: KinScoreRepository = Depends()):
    """Get kinship score."""
    score = repo.get_by_id(score_id)
    if not score:
        raise HTTPException(status_code=404, detail="Score not found")

    return KinScoreResponse(
        id=score.id,
        user_id=score.user_id,
        match_id=score.match_id,
        score=score.score,
        confidence=score.confidence,
        status=score.status.value,
    )
