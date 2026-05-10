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
from typing import Dict, List, Optional
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


class BehaviorRepository:
    """Repository interface for behavior persistence"""
    
    async def save_event(self, event: BehaviorEvent) -> str:
        """Save event to Cassandra (time-series)"""
        # Returns event_id
        pass
    
    async def get_user_aggregate(self, user_id: str) -> Optional[UserBehaviorAggregate]:
        """Get user behavioral aggregate from PostgreSQL"""
        pass
    
    async def update_aggregate(self, aggregate: UserBehaviorAggregate):
        """Update user behavioral aggregate in PostgreSQL"""
        pass
    
    async def get_events_for_user(
        self, 
        user_id: str, 
        start_time: datetime, 
        end_time: datetime,
    ) -> List[BehaviorEvent]:
        """Query events from Cassandra by time range"""
        pass


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
        
        return event_id
        # - Potential fraud/bot signals
        
        # TODO: Publish domain events for downstream systems
        # - behavioral.event.recorded
        # - behavioral.user.anomaly_detected (if applicable)
        
        return event_id
    
    async def get_user_profile(self, user_id: str) -> Optional[UserBehaviorAggregate]:
        """Get complete user behavior profile"""
        return await self.repository.get_user_aggregate(user_id)
    
    async def calculate_affinity(self, user_id: str, content_id: str) -> float:
        """Calculate user affinity to content (0-1)"""
        # TODO: Implement ML-based affinity calculation
        # - History of interactions with similar content
        # - Content-based similarity
        # - Collaborative filtering signals
        return 0.0
