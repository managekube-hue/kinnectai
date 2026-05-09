"""
Idempotent Kafka event consumer for the behavioral-service (PRD Item 108).

Architecture
------------
- Consumes from a Kafka topic (default: ``behavioral-events``).
- Uses a ``processed_events`` PostgreSQL table as a dedup store.
  INSERT â€¦ ON CONFLICT DO NOTHING acts as an atomic check-and-set so that
  replayed or duplicated messages are silently skipped.
- Successfully processed events are handed to :func:`process` for downstream
  enrichment / storage.

Schema (must be created by migration before service starts)
-----------------------------------------------------------
    CREATE TABLE IF NOT EXISTS processed_events (
        event_id    TEXT        PRIMARY KEY,
        processed_at TIMESTAMPTZ DEFAULT NOW()
    );

Environment variables
---------------------
    KAFKA_BROKERS        Comma-separated broker list, e.g. "kafka:9092"
    KAFKA_TOPIC          Topic name (default: behavioral-events)
    KAFKA_GROUP_ID       Consumer group (default: behavioral-service)
    POSTGRES_DSN         Standard libpq DSN
"""

from __future__ import annotations

import json
import logging
import os
from typing import Any

import psycopg2
from kafka import KafkaConsumer  # type: ignore[import-untyped]

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

KAFKA_BROKERS: list[str] = os.environ.get("KAFKA_BROKERS", "kafka:9092").split(",")
KAFKA_TOPIC: str = os.environ.get("KAFKA_TOPIC", "behavioral-events")
KAFKA_GROUP_ID: str = os.environ.get("KAFKA_GROUP_ID", "behavioral-service")
POSTGRES_DSN: str = os.environ.get("POSTGRES_DSN", "")


# ---------------------------------------------------------------------------
# Database helpers
# ---------------------------------------------------------------------------

def _get_db_conn() -> psycopg2.extensions.connection:
    return psycopg2.connect(POSTGRES_DSN)


def _try_claim_event(conn: psycopg2.extensions.connection, event_id: str) -> bool:
    """Returns True if the event is new (claimed successfully), False if duplicate."""
    with conn.cursor() as cur:
        cur.execute(
            "INSERT INTO processed_events (event_id) VALUES (%s) ON CONFLICT DO NOTHING",
            (event_id,),
        )
        claimed = cur.rowcount > 0
        conn.commit()
        return claimed


def _mark_processed(conn: psycopg2.extensions.connection, event_id: str) -> None:
    with conn.cursor() as cur:
        cur.execute(
            "UPDATE processed_events SET processed_at = NOW() WHERE event_id = %s",
            (event_id,),
        )
        conn.commit()


# ---------------------------------------------------------------------------
# Event processing
# ---------------------------------------------------------------------------

def process(event: dict[str, Any]) -> None:
    """Handle a deduplicated event.  Extend this function with downstream logic."""
    event_type = event.get("type", "unknown")
    logger.info("Processing event type=%s id=%s", event_type, event.get("event_id"))


def consume_event(
    event: dict[str, Any],
    conn: psycopg2.extensions.connection,
) -> None:
    """Idempotently consume a single decoded event.

    Parameters
    ----------
    event:
        Decoded event dict.  Must contain an ``event_id`` key.
    conn:
        Open psycopg2 connection (caller owns lifecycle).
    """
    event_id: str | None = event.get("event_id")
    if not event_id:
        logger.warning("Received event without event_id, skipping: %s", event)
        return

    if not _try_claim_event(conn, event_id):
        logger.info("Duplicate event %s â€” skipping", event_id)
        return

    try:
        process(event)
        _mark_processed(conn, event_id)
    except Exception:
        logger.exception("Error processing event %s", event_id)
        # The row was already inserted; a re-delivery would be deduplicated.
        # Raise to let the consumer decide on retry / DLQ policy.
        raise


# ---------------------------------------------------------------------------
# Consumer loop (called from service entrypoint)
# ---------------------------------------------------------------------------

def run_consumer() -> None:
    """Start the blocking Kafka consumer loop."""
    consumer = KafkaConsumer(
        KAFKA_TOPIC,
        bootstrap_servers=KAFKA_BROKERS,
        group_id=KAFKA_GROUP_ID,
        auto_offset_reset="earliest",
        enable_auto_commit=False,
        value_deserializer=lambda m: json.loads(m.decode("utf-8")),
    )

    conn = _get_db_conn()
    logger.info(
        "Behavioral consumer started â€” topic=%s brokers=%s",
        KAFKA_TOPIC,
        KAFKA_BROKERS,
    )

    try:
        for message in consumer:
            event: dict[str, Any] = message.value
            try:
                consume_event(event, conn)
                consumer.commit()
            except Exception:
                logger.exception(
                    "Failed to process message offset=%s, will not commit",
                    message.offset,
                )
    finally:
        conn.close()
        consumer.close()


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    run_consumer()
