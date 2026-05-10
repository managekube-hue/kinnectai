"""Compute KinScore command handler."""
from app.domain.kinscore.entities import KinScore, ScoreStatus
from app.infrastructure.postgres.repository import KinScoreRepository
from app.infrastructure.kafka.producer import EventProducer


class ComputeKinScoreCommand:
    """Command to compute a kinship score."""
    user_id: str
    match_id: str
    data: dict


class ComputeKinScoreHandler:
    """Handles kinship score computation."""

    def __init__(self, repo: KinScoreRepository, producer: EventProducer):
        self.repo = repo
        self.producer = producer

    def handle(self, cmd: ComputeKinScoreCommand) -> KinScore:
        """Execute the command."""
        # Create score entity
        score = KinScore(
            id=f"score_{cmd.user_id}_{cmd.match_id}",
            user_id=cmd.user_id,
            match_id=cmd.match_id,
            score=0.0,
            confidence=0.0,
            features={},
            status=ScoreStatus.PENDING,
        )

        try:
            # Validate
            score.validate()

            # Persist pending
            self.repo.create(score)

            # TODO: Call actual kinship algorithm
            # This would integrate with kin_score_algorithm.py
            computed_score, confidence, features = self._compute(cmd.data)

            # Update entity
            score.mark_computed(computed_score, confidence, features)
            self.repo.update(score)

            # Publish event
            self.producer.publish_score_computed(score)

        except Exception as e:
            score.mark_failed(str(e))
            self.repo.update(score)
            self.producer.publish_score_failed(score)
            raise

        return score

    def _compute(self, data: dict) -> tuple:
        """Call kinship algorithm."""
        # TODO: integrate with actual algorithm
        return 85.5, 0.92, {"shared_ancestors": 3}
