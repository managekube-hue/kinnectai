#!/usr/bin/env python3
"""
behavioral-service main entry point

Handles behavioral event ingestion, aggregation, and analysis.
Reads from Kafka (behavioral-events topic), persists to Cassandra/PostgreSQL.
"""

import asyncio
import json
import logging
import os
import time
from datetime import datetime
from typing import Optional
from aiohttp import web

from app.domain.behavior import BehaviorService
from app.infrastructure.postgres import PostgresPool
from app.infrastructure.cassandra import CassandraCluster
from app.events.consumers import BehaviorEventConsumer
from app.jobs import AnalyticsAggregator, AnomalyDetector


logger = logging.getLogger(__name__)
start_time = time.time()


async def health_handler(request):
    """Health check endpoint"""
    return web.json_response({
        "status": "healthy",
        "service": "behavioral-service",
        "version": "1.0.0",
        "timestamp": datetime.utcnow().isoformat(),
    })


async def ready_handler(request):
    """Readiness check endpoint"""
    service = request.app.get("behavioral_service")
    if service and service.postgres and service.cassandra:
        return web.json_response({"ready": True})
    return web.json_response({"ready": False}, status=503)


async def metrics_handler(request):
    """Prometheus metrics endpoint"""
    uptime = time.time() - start_time
    metrics = f"""# HELP behavioral_uptime_seconds Service uptime
# TYPE behavioral_uptime_seconds gauge
behavioral_uptime_seconds {uptime}

# HELP behavioral_events_processed_total Total events processed
# TYPE behavioral_events_processed_total counter
behavioral_events_processed_total 0
"""
    return web.Response(text=metrics, content_type="text/plain; version=0.0.4")


class BehavioralService:
    """Main service orchestrator"""

    def __init__(self):
        self.postgres: Optional[PostgresPool] = None
        self.cassandra: Optional[CassandraCluster] = None
        self.kafka_consumer: Optional[BehaviorEventConsumer] = None
        self.aggregator: Optional[AnalyticsAggregator] = None
        self.detector: Optional[AnomalyDetector] = None

    async def start(self):
        """Initialize and start all service components"""
        logger.info("Starting behavioral service...")

        # Load configuration
        config = self._load_config()
        logger.info(f"Environment: {config['env']}, Kafka: {config['kafka_brokers']}")

        # Initialize database connections
        self.postgres = PostgresPool(
            host=config["postgres_host"],
            port=config["postgres_port"],
            database=config["postgres_db"],
            user=config["postgres_user"],
            password=config["postgres_password"],
        )
        await self.postgres.connect()
        logger.info("PostgreSQL connected")

        self.cassandra = CassandraCluster(
            contact_points=config["cassandra_contact_points"],
            keyspace=config["cassandra_keyspace"],
        )
        await self.cassandra.connect()
        logger.info("Cassandra connected")

        # Initialize Kafka consumer
        self.kafka_consumer = BehaviorEventConsumer(
            brokers=config["kafka_brokers"],
            group_id="behavioral-service",
            topics=["behavioral-events"],
        )
        await self.kafka_consumer.start()
        logger.info("Kafka consumer started")

        # Initialize background jobs
        self.aggregator = AnalyticsAggregator(
            postgres=self.postgres,
            cassandra=self.cassandra,
        )
        self.detector = AnomalyDetector(
            postgres=self.postgres,
        )

        # Start HTTP server for health checks
        app = web.Application()
        app["behavioral_service"] = self
        app.router.add_get("/health", health_handler)
        app.router.add_get("/ready", ready_handler)
        app.router.add_get("/metrics", metrics_handler)

        runner = web.AppRunner(app)
        await runner.setup()
        
        http_port = int(config.get("http_port", 8002))
        site = web.TCPSite(runner, "0.0.0.0", http_port)
        await site.start()
        logger.info(f"HTTP server listening on port {http_port}")

        # Start event processing and jobs
        try:
            await asyncio.gather(
                self._process_events(),
                self._run_aggregation_job(),
                self._run_anomaly_detection_job(),
            )
        except KeyboardInterrupt:
            logger.info("Shutdown signal received")
            await runner.cleanup()
            await self.shutdown()

    async def _process_events(self):
        """Main event processing loop"""
        logger.info("Starting event processing...")
        async for event in self.kafka_consumer.consume():
            try:
                logger.info(f"Processing event: user={event.user_id}, type={event.event_type}")
                # Route to domain service for validation and persistence
                behavior_svc = BehaviorService(self._get_repository())
                event_id = await behavior_svc.record_event(
                    self._event_to_domain_model(event)
                )
                logger.debug(f"Event persisted: {event_id}")
            except Exception as e:
                logger.error(f"Event processing error: {e}", exc_info=True)
                # In production, send to dead-letter queue

    async def _run_aggregation_job(self):
        """Runs periodic analytics aggregation"""
        logger.info("Aggregation job started")
        while True:
            try:
                await self.aggregator.run()
                await asyncio.sleep(300)  # Run every 5 minutes
            except Exception as e:
                logger.error(f"Aggregation job error: {e}")

    async def _run_anomaly_detection_job(self):
        """Runs periodic anomaly detection"""
        logger.info("Anomaly detection job started")
        while True:
            try:
                await self.detector.run()
                await asyncio.sleep(600)  # Run every 10 minutes
            except Exception as e:
                logger.error(f"Anomaly detection error: {e}")

    async def shutdown(self):
        """Graceful shutdown of all components"""
        logger.info("Shutting down behavioral service...")
        if self.kafka_consumer:
            await self.kafka_consumer.stop()
        if self.postgres:
            await self.postgres.close()
        if self.cassandra:
            await self.cassandra.close()
        logger.info("Shutdown complete")

    def _get_repository(self):
        """Factory for repository"""
        from app.infrastructure.repository import BehaviorRepository
        return BehaviorRepository(postgres=self.postgres, cassandra=self.cassandra)
    
    def _event_to_domain_model(self, event):
        """Convert Kafka event to domain model"""
        from app.domain.behavior import BehaviorEvent, EventType
        from datetime import datetime
        return BehaviorEvent(
            user_id=event.user_id,
            event_type=EventType(event.event_type),
            content_id=event.content_id,
            session_id=event.session_id,
            timestamp=datetime.fromisoformat(event.timestamp) if isinstance(event.timestamp, str) else event.timestamp,
            metadata=event.metadata,
        )

    def _load_config(self) -> dict:
        """Load configuration from environment"""
        return {
            "env": os.getenv("ENV", "development"),
            "http_port": os.getenv("HTTP_PORT", "8002"),
            "kafka_brokers": os.getenv("KAFKA_BROKERS", "localhost:9092").split(","),
            "postgres_host": os.getenv("POSTGRES_HOST", "localhost"),
            "postgres_port": int(os.getenv("POSTGRES_PORT", "5432")),
            "postgres_db": os.getenv("POSTGRES_DB", "kinnectai"),
            "postgres_user": os.getenv("POSTGRES_USER", "postgres"),
            "postgres_password": os.getenv("POSTGRES_PASSWORD", ""),
            "cassandra_contact_points": os.getenv("CASSANDRA_CONTACT_POINTS", "localhost").split(","),
            "cassandra_keyspace": os.getenv("CASSANDRA_KEYSPACE", "behavioral"),
        }


async def main():
    """Entry point"""
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    )
    
    service = BehavioralService()
    await service.start()


if __name__ == "__main__":
    asyncio.run(main())
