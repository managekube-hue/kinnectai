#!/usr/bin/env python3
"""
behavioral-service main entry point

Handles behavioral event ingestion, aggregation, and analysis.
Reads from Kafka (behavioral-events topic), persists to Cassandra/PostgreSQL.
"""

import asyncio
import logging
import os
from typing import Optional

from app.domain.behavior import BehaviorService
from app.infrastructure.postgres import PostgresPool
from app.infrastructure.cassandra import CassandraCluster
from app.events.consumers import BehaviorEventConsumer
from app.jobs import AnalyticsAggregator, AnomalyDetector


logger = logging.getLogger(__name__)


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

        # Start event processing and jobs
        try:
            await asyncio.gather(
                self._process_events(),
                self._run_aggregation_job(),
                self._run_anomaly_detection_job(),
            )
        except KeyboardInterrupt:
            logger.info("Shutdown signal received")
            await self.shutdown()

    async def _process_events(self):
        """Main event processing loop"""
        logger.info("Starting event processing...")
        async for event in self.kafka_consumer.consume():
            try:
                logger.debug(f"Processing event: {event}")
                # TODO: Route event to appropriate handler
                # - Parse Avro schema
                # - Apply policies (consent, GDPR)
                # - Ingest to Cassandra (time-series)
                # - Update PostgreSQL aggregates
                # - Publish to downstream topics if needed
            except Exception as e:
                logger.error(f"Event processing error: {e}")
                # Send to dead-letter queue

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

    def _load_config(self) -> dict:
        """Load configuration from environment"""
        return {
            "env": os.getenv("ENV", "development"),
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
