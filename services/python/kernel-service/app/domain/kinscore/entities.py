"""Kernel score domain entity."""
from dataclasses import dataclass
from datetime import datetime
from typing import Optional
from enum import Enum


class ScoreStatus(str, Enum):
    PENDING = "pending"
    COMPUTED = "computed"
    FAILED = "failed"


@dataclass
class KinScore:
    """KinScore aggregate root."""
    
    id: str
    user_id: str
    match_id: str
    score: float
    confidence: float
    features: dict
    status: ScoreStatus
    error_message: Optional[str] = None
    created_at: datetime = None
    updated_at: datetime = None

    def __post_init__(self):
        if self.created_at is None:
            self.created_at = datetime.utcnow()
        if self.updated_at is None:
            self.updated_at = datetime.utcnow()

    def validate(self) -> bool:
        """Enforce domain invariants."""
        if not self.id or not self.user_id or not self.match_id:
            raise ValueError("KinScore: missing required fields")
        if not 0 <= self.score <= 100:
            raise ValueError("KinScore: score must be 0-100")
        if not 0 <= self.confidence <= 1:
            raise ValueError("KinScore: confidence must be 0-1")
        return True

    def mark_computed(self, score: float, confidence: float, features: dict):
        """Mark score as computed."""
        self.score = score
        self.confidence = confidence
        self.features = features
        self.status = ScoreStatus.COMPUTED
        self.updated_at = datetime.utcnow()

    def mark_failed(self, error: str):
        """Mark score computation as failed."""
        self.status = ScoreStatus.FAILED
        self.error_message = error
        self.updated_at = datetime.utcnow()
