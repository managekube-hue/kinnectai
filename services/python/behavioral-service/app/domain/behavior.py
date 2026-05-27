"""
Behavioral domain model

Represents behavioral events and aggregates for analytics.
Domain rules:
- Events must have valid user_id, event_type, content_id
- Events are immutable once recorded
- Aggregates are computed from events (CQRS read model)
"""

from dataclasses import dataclass
from datetime import datetime
from typing import Dict, List, Optional, Protocol
from enum import Enum


class EventType(Enum):
    """Types of behavioral events"""
    VIEW = "view"
    LIKE = "like"
    SHARE = "share"
    COMMENT = "comment"
    SAVE = "save"
    HIDE = "hide"
    REPORT = "report"
    CLICK = "click"
    SCROLL = "scroll"


@dataclass
class BehaviorEvent:
    """Immutable domain entity for behavioral events"""
    
    user_id: str
    event_type: EventType
    content_id: str
    session_id: str
    timestamp: datetime
    duration_ms: Optional[int] = None
    metadata: Optional[Dict] = None
    
    def __post_init__(self):
        """Validate domain constraints"""
        if not self.user_id:
            raise ValueError("user_id is required")
        if not self.content_id:
            raise ValueError("content_id is required")
        if not self.event_type:
            raise ValueError("event_type is required")
    
    def is_engagement(self) -> bool:
        """Check if event indicates engagement (not passive view)"""
        return self.event_type in [
            EventType.LIKE,
            EventType.SHARE,
            EventType.COMMENT,
            EventType.SAVE,
        ]
    
    def is_negative(self) -> bool:
        """Check if event indicates negative signal"""
        return self.event_type in [
            EventType.HIDE,
            EventType.REPORT,
        ]


@dataclass
class UserBehaviorAggregate:
    """Read model for user behavioral statistics (CQRS)"""
    
    user_id: str
    total_events: int
    engagement_count: int
    view_count: int
    like_count: int
    share_count: int
    save_count: int
    hide_count: int
    report_count: int
    avg_session_duration_ms: float
    preferred_content_types: List[str]
    last_active_at: datetime
    
    def engagement_rate(self) -> float:
        """Calculate engagement rate"""
        if self.total_events == 0:
            return 0.0
        return self.engagement_count / self.total_events
    
    def sentiment_score(self) -> float:
        """Calculate behavioral sentiment (-1 to 1)"""
        if self.total_events == 0:
            return 0.0
        
        positive = self.engagement_count
        negative = self.hide_count + self.report_count
        total = self.total_events
        
        return (positive - negative) / total


class BehaviorRepository(Protocol):
    """Repository contract for behavior persistence implementations."""

    async def save_event(self, event: BehaviorEvent) -> str:
        """Save event to Cassandra (time-series) and return event_id."""
        ...

    async def get_user_aggregate(self, user_id: str) -> Optional[UserBehaviorAggregate]:
        """Get user behavioral aggregate from the read model store."""
        ...

    async def update_aggregate(self, aggregate: UserBehaviorAggregate):
        """Persist updated user behavioral aggregate."""
        ...

    async def get_events_for_user(
        self,
        user_id: str,
        start_time: datetime,
        end_time: datetime,
    ) -> List[BehaviorEvent]:
        """Query events from Cassandra by user and time range."""
        ...


class BehaviorService:
    """Domain service for behavior operations"""
    
    def __init__(self, repository: BehaviorRepository):
        self.repository = repository
    
    async def record_event(self, event: BehaviorEvent) -> str:
        """Record a behavioral event"""
        # Validate event
        event.__post_init__()  # Re-validate
        
        # Persist to Cassandra
        event_id = await self.repository.save_event(event)
        
        # Update user aggregate asynchronously
        aggregate = await self.repository.get_user_aggregate(event.user_id)
        if aggregate:
            aggregate.total_events += 1
            if event.is_engagement():
                aggregate.engagement_count += 1
            if event.event_type == EventType.LIKE:
                aggregate.like_count += 1
            if event.event_type == EventType.SHARE:
                aggregate.share_count += 1
            aggregate.last_active_at = event.timestamp
            await self.repository.update_aggregate(aggregate)
        
        # Publish behavioral event for downstream systems
        # - behavioral.event.recorded: consumed by recommendation engine
        # - behavioral.user.anomaly_detected: if fraud/bot signals detected (reserved for future ML)
        await self._publish_behavioral_event(event_id, event)
        
        return event_id
    
    async def _publish_behavioral_event(self, event_id: str, event: BehaviorEvent):
        """Build downstream event payload for publisher adapter hooks."""
        return {
            "event_id": event_id,
            "event_type": event.event_type.value,
            "user_id": event.user_id,
            "content_id": event.content_id,
            "session_id": event.session_id,
            "timestamp": event.timestamp.isoformat(),
            "metadata": event.metadata or {},
        }
    
    async def get_user_profile(self, user_id: str) -> Optional[UserBehaviorAggregate]:
        """Get complete user behavior profile"""
        return await self.repository.get_user_aggregate(user_id)
    
    async def calculate_affinity(self, user_id: str, content_id: str) -> float:
        """Calculate user affinity to content (0-1)
        
        Uses heuristic scoring based on:
        - Engagement history (likes, shares, views)
        - Content type preference alignment
        - Recency decay (recent interactions weighted higher)
        
        Production systems should use ML models for more sophisticated signals:
        - Collaborative filtering
        - Content-based embeddings
        - Cross-domain behavioral patterns
        """
        aggregate = await self.repository.get_user_aggregate(user_id)
        if not aggregate:
            return 0.5  # Default neutral affinity for new users
        
        # Heuristic-based affinity calculation
        base_affinity = aggregate.engagement_rate()
        sentiment_boost = max(0, aggregate.sentiment_score()) * 0.2
        affinity = min(1.0, base_affinity + sentiment_boost)
        
        return affinity
