"""Compute KinScore command handler."""
import os

from app.domain.kinscore.entities import KinScore, ScoreStatus
from app.infrastructure.postgres.repository import KinScoreRepository
from app.infrastructure.kafka.producer import EventProducer
from app.kin_score_algorithm import KCKernel


class ComputeKinScoreCommand:
    """Command to compute a kinship score."""
    user_id: str
    match_id: str
    data: dict


class ComputeKinScoreHandler:
    """Handles kinship score computation."""

    _kernel: KCKernel | None = None

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

            # Execute Kinnection Coefficient algorithm with current user inputs.
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
        if ComputeKinScoreHandler._kernel is None:
            pg_dsn = os.getenv(
                "POSTGRES_DSN",
                "postgresql://kinnect:kinnect_dev_password@localhost:5432/kinnectai",
            )
            neo4j_uri = os.getenv("NEO4J_URI", "bolt://localhost:7687")
            neo4j_user = os.getenv("NEO4J_USER", "neo4j")
            neo4j_pass = os.getenv("NEO4J_PASSWORD", "kinnect_neo4j_password")
            cassandra_hosts = os.getenv("CASSANDRA_HOSTS", "localhost").split(",")
            cassandra_keyspace = os.getenv("CASSANDRA_KEYSPACE", "kinnectai_events")
            ComputeKinScoreHandler._kernel = KCKernel(
                pg_dsn,
                neo4j_uri,
                neo4j_user,
                neo4j_pass,
                cassandra_hosts,
                cassandra_keyspace,
            )

        user_a = str(data.get("user_id") or data.get("user_a_id") or "")
        user_b = str(data.get("match_id") or data.get("user_b_id") or "")
        if not user_a or not user_b:
            raise ValueError("user_id and match_id are required for kin score computation")

        result = ComputeKinScoreHandler._kernel.calculate_kin_score(user_a, user_b)

        score = float(result.get("kin_score", 0.0))
        confidence = float(result.get("confidence", 0.0))

        consent_flags = int(data.get("consent_flags", 0xFFFF))
        fallback_applied = (consent_flags & 0x02) == 0
        if fallback_applied:
            score = max(0.0, min(100.0, score * 0.60))
            confidence = max(0.0, min(1.0, confidence * 0.60))

        features = {
            "action": result.get("action", "filter_out"),
            "relationship_guess": result.get("relationship_guess", "Unknown"),
            "cache_ttl": result.get("cache_ttl", 3600),
            "layers_used": result.get("layers_used", {}),
            "fallback_applied": fallback_applied,
        }

        return score, confidence, features
