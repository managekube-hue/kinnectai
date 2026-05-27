import json
import logging
import os
import threading
from datetime import datetime, timezone
from uuid import UUID, uuid4

from cassandra.cluster import Cluster
from fastapi import FastAPI
from kafka import KafkaConsumer

app = FastAPI(title="behavioral-service", version="1.0.0")

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class RuntimeState:
    def __init__(self) -> None:
        self.cluster = None
        self.session = None
        self.consumer = None
        self.thread = None
        self.stop_event = threading.Event()


state = RuntimeState()
metrics = {
    "events_processed_total": 0,
    "pulses_received_total": 0,
}
last_user_created_event = None


def _connect_cassandra():
    contact_points = os.getenv("CASSANDRA_CONTACT_POINTS", "cassandra").split(",")
    keyspace = os.getenv("CASSANDRA_KEYSPACE", "kinnectai_events")
    state.cluster = Cluster(contact_points=contact_points)
    state.session = state.cluster.connect()
    state.session.execute(
        """
        CREATE KEYSPACE IF NOT EXISTS kinnectai_events
        WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1}
        """
    )
    state.session.set_keyspace(keyspace)
    state.session.execute(
        """
        CREATE TABLE IF NOT EXISTS behavioral_events (
            user_id uuid,
            event_id uuid,
            event_type text,
            event_payload text,
            created_at timestamp,
            PRIMARY KEY ((user_id), created_at, event_id)
        ) WITH CLUSTERING ORDER BY (created_at DESC)
        """
    )


def _consume_user_events():
    global last_user_created_event
    brokers = os.getenv("KAFKA_BROKERS", "kafka:9092")
    state.consumer = KafkaConsumer(
        "user-events",
        bootstrap_servers=[b.strip() for b in brokers.split(",") if b.strip()],
        group_id="behavioral-service",
        auto_offset_reset="earliest",
        enable_auto_commit=True,
        value_deserializer=lambda m: json.loads(m.decode("utf-8")),
    )
    logger.info("Behavioral consumer started for topic user-events")

    for msg in state.consumer:
        if state.stop_event.is_set():
            break
        payload = msg.value if isinstance(msg.value, dict) else {}
        if payload.get("event_type") != "user.created":
            continue

        user_id_raw = payload.get("user_id")
        try:
            user_id = UUID(str(user_id_raw))
        except Exception:
            logger.warning("Skipping event with invalid user_id: %s", user_id_raw)
            continue

        created_at = payload.get("timestamp")
        try:
            dt = datetime.fromisoformat(str(created_at).replace("Z", "+00:00"))
        except Exception:
            dt = datetime.now(timezone.utc)

        state.session.execute(
            """
            INSERT INTO behavioral_events (user_id, event_id, event_type, event_payload, created_at)
            VALUES (%s, %s, %s, %s, %s)
            """,
            (user_id, uuid4(), "user.created", json.dumps(payload), dt),
        )
        metrics["events_processed_total"] += 1
        last_user_created_event = payload
        logger.info("Persisted user.created for user_id=%s", user_id)


@app.on_event("startup")
def startup_event():
    _connect_cassandra()
    state.thread = threading.Thread(target=_consume_user_events, daemon=True)
    state.thread.start()


@app.on_event("shutdown")
def shutdown_event():
    state.stop_event.set()
    if state.consumer is not None:
        state.consumer.close()
    if state.session is not None:
        state.session.shutdown()
    if state.cluster is not None:
        state.cluster.shutdown()


@app.get("/health")
def health():
    return {"status": "healthy", "service": "behavioral-service"}


@app.get("/ready")
def ready():
    ready_state = state.session is not None and state.consumer is not None
    return {"ready": ready_state}


@app.get("/metrics")
def service_metrics():
    return {
        "behavioral_events_processed_total": metrics["events_processed_total"],
        "behavioral_pulses_received_total": metrics["pulses_received_total"],
        "consumer_connected": state.consumer is not None,
        "cassandra_connected": state.session is not None,
    }


@app.post("/pulses")
def create_pulse(payload: dict):
    if state.session is None:
        return {"success": False, "error": "service not ready"}

    memory_id = str(payload.get("memory_id", "")).strip()
    if not memory_id:
        return {"success": False, "error": "memory_id is required"}

    user_id_raw = payload.get("user_id")
    try:
        user_id = UUID(str(user_id_raw)) if user_id_raw else uuid4()
    except Exception:
        user_id = uuid4()

    event_payload = {
        "event_type": "pulse.created",
        "memory_id": memory_id,
        "user_id": str(user_id),
        "timestamp": datetime.now(timezone.utc).isoformat(),
    }

    state.session.execute(
        """
        INSERT INTO behavioral_events (user_id, event_id, event_type, event_payload, created_at)
        VALUES (%s, %s, %s, %s, %s)
        """,
        (
            user_id,
            uuid4(),
            "pulse.created",
            json.dumps(event_payload),
            datetime.now(timezone.utc),
        ),
    )
    metrics["pulses_received_total"] += 1
    return {"success": True, "memory_id": memory_id}


@app.get("/pulses")
def list_pulses(limit: int = 20):
    if state.session is None:
        return {"items": []}

    rows = state.session.execute(
        """
        SELECT user_id, event_id, event_payload, created_at
        FROM behavioral_events
        LIMIT %s
        """,
        (max(1, min(limit, 200)),),
    )

    items = []
    for row in rows:
        try:
            payload = json.loads(row.event_payload)
        except Exception:
            payload = {"raw": row.event_payload}
        items.append(
            {
                "user_id": str(row.user_id),
                "event_id": str(row.event_id),
                "payload": payload,
                "created_at": row.created_at.isoformat() if row.created_at else None,
            }
        )
    return {"items": items}


@app.get("/verify/last-user-created")
def verify_last_user_created():
    if last_user_created_event is None:
        return {"found": False, "event": None}
    return {"found": True, "event": last_user_created_event}
