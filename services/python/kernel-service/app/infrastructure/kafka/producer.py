"""Kafka producer for kernel service events."""
import json
from typing import Dict, Any
from kafka import KafkaProducer
from app.domain.kinscore.entities import KinScore


class EventProducer:
    """Publishes kernel service events to Kafka."""

    def __init__(self, brokers: list):
        self.producer = KafkaProducer(
            bootstrap_servers=brokers,
            value_serializer=lambda v: json.dumps(v).encode('utf-8')
        )

    def publish_score_computed(self, score: KinScore):
        """Publish score.computed event."""
        event = {
            "event_type": "score.computed",
            "score_id": score.id,
            "user_id": score.user_id,
            "match_id": score.match_id,
            "score": score.score,
            "confidence": score.confidence,
            "features": score.features,
            "timestamp": score.updated_at.isoformat(),
        }
        self.producer.send('kernel-events', value=event, key=score.user_id.encode())
        self.producer.flush()

    def publish_score_failed(self, score: KinScore):
        """Publish score.failed event."""
        event = {
            "event_type": "score.failed",
            "score_id": score.id,
            "user_id": score.user_id,
            "error": score.error_message,
            "timestamp": score.updated_at.isoformat(),
        }
        self.producer.send('kernel-events', value=event, key=score.user_id.encode())
        self.producer.flush()

    def close(self):
        self.producer.close()
