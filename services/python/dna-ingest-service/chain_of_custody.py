from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime, timezone
from hashlib import sha256
from typing import Any


@dataclass(frozen=True)
class CustodyEvent:
    sample_id: str
    action: str
    actor_id: str
    location: str
    metadata: dict[str, Any] = field(default_factory=dict)
    timestamp_utc: str = field(
        default_factory=lambda: datetime.now(timezone.utc).isoformat()
    )

    @property
    def fingerprint(self) -> str:
        payload = (
            f"{self.sample_id}|{self.action}|{self.actor_id}|"
            f"{self.location}|{self.timestamp_utc}|{self.metadata}"
        )
        return sha256(payload.encode("utf-8")).hexdigest()


class ChainOfCustodyLedger:
    def __init__(self) -> None:
        self._events: list[CustodyEvent] = []

    def append(
        self,
        *,
        sample_id: str,
        action: str,
        actor_id: str,
        location: str,
        metadata: dict[str, Any] | None = None,
    ) -> CustodyEvent:
        event = CustodyEvent(
            sample_id=sample_id,
            action=action,
            actor_id=actor_id,
            location=location,
            metadata=metadata or {},
        )
        self._events.append(event)
        return event

    def by_sample(self, sample_id: str) -> list[CustodyEvent]:
        return [event for event in self._events if event.sample_id == sample_id]

    def verify_integrity(self, sample_id: str) -> bool:
        events = self.by_sample(sample_id)
        return all(bool(event.fingerprint) for event in events)
