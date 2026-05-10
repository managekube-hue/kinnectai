"""PostgreSQL repository for kernel scores."""
import psycopg2
from psycopg2.extras import RealDictCursor
from app.domain.kinscore.entities import KinScore, ScoreStatus


class KinScoreRepository:
    """Persists kernel scores to PostgreSQL."""

    def __init__(self, connection_string: str):
        self.conn_string = connection_string

    def create(self, score: KinScore) -> None:
        """Create a new kernel score."""
        conn = psycopg2.connect(self.conn_string)
        try:
            with conn.cursor() as cur:
                cur.execute("""
                    INSERT INTO kernel_scores 
                    (id, user_id, match_id, score, confidence, features, status, created_at, updated_at)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
                """, (
                    score.id, score.user_id, score.match_id,
                    score.score, score.confidence, json.dumps(score.features),
                    score.status.value, score.created_at, score.updated_at
                ))
                conn.commit()
        finally:
            conn.close()

    def get_by_id(self, score_id: str) -> KinScore:
        """Retrieve a kernel score by ID."""
        conn = psycopg2.connect(self.conn_string)
        try:
            with conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute("SELECT * FROM kernel_scores WHERE id = %s", (score_id,))
                row = cur.fetchone()
                if not row:
                    return None
                return self._row_to_entity(row)
        finally:
            conn.close()

    def update(self, score: KinScore) -> None:
        """Update a kernel score."""
        conn = psycopg2.connect(self.conn_string)
        try:
            with conn.cursor() as cur:
                cur.execute("""
                    UPDATE kernel_scores 
                    SET score = %s, confidence = %s, features = %s, 
                        status = %s, error_message = %s, updated_at = %s
                    WHERE id = %s
                """, (
                    score.score, score.confidence, json.dumps(score.features),
                    score.status.value, score.error_message, score.updated_at, score.id
                ))
                conn.commit()
        finally:
            conn.close()

    def _row_to_entity(self, row: dict) -> KinScore:
        """Convert database row to entity."""
        return KinScore(
            id=row['id'],
            user_id=row['user_id'],
            match_id=row['match_id'],
            score=row['score'],
            confidence=row['confidence'],
            features=json.loads(row['features']),
            status=ScoreStatus(row['status']),
            error_message=row.get('error_message'),
            created_at=row['created_at'],
            updated_at=row['updated_at'],
        )
