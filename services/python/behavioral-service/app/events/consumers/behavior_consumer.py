"""
Kafka consumer for behavioral events

Subscribes to behavioral-events topic (Avro schema).
Handles event deserialization, parsing, and routing to domain logic.
"""

import asyncio
import json
import logging
from typing import AsyncIterator, List, Dict, Any

from confluent_kafka import Consumer, KafkaError
from confluent_kafka.schema_registry import SchemaRegistryClient
from confluent_kafka.schema_registry.avro import AvroDeserializer


logger = logging.getLogger(__name__)


class BehaviorEvent:
    """Domain model for behavioral events"""

    def __init__(self, data: Dict[str, Any]):
        self.user_id = data.get("user_id")
        self.session_id = data.get("session_id")
        self.event_type = data.get("event_type")  # "view", "like", "share", etc.
        self.content_id = data.get("content_id")
        self.timestamp = data.get("timestamp")
        self.metadata = data.get("metadata", {})

    def __repr__(self):
        return f"BehaviorEvent(user_id={self.user_id}, event_type={self.event_type}, content_id={self.content_id})"


class BehaviorEventConsumer:
    """Consumes behavioral events from Kafka"""

    def __init__(self, brokers: List[str], group_id: str, topics: List[str]):
        self.brokers = brokers
        self.group_id = group_id
        self.topics = topics
        self.consumer = None
        self.deserializer = None
        self._running = False

    async def start(self):
        """Initialize Kafka consumer and schema registry"""
        logger.info(f"Starting Kafka consumer: brokers={self.brokers}, group={self.group_id}")

        # TODO: Initialize Schema Registry client
        # schema_registry_url = "http://schema-registry:8081"
        # schema_registry_client = SchemaRegistryClient({"url": schema_registry_url})
        # self.deserializer = AvroDeserializer(schema_registry_client)

        # Configure Kafka consumer
        conf = {
            "bootstrap.servers": ",".join(self.brokers),
            "group.id": self.group_id,
            "auto.offset.reset": "earliest",
            "enable.auto.commit": True,
            "max.poll.interval.ms": 600000,
        }

        self.consumer = Consumer(conf)
        self.consumer.subscribe(self.topics)
        self._running = True
        logger.info(f"Consumer subscribed to topics: {self.topics}")

    async def consume(self) -> AsyncIterator[BehaviorEvent]:
        """Async generator for consuming events"""
        while self._running:
            try:
                msg = self.consumer.poll(timeout=1.0)

                if msg is None:
                    await asyncio.sleep(0.1)
                    continue

                if msg.error():
                    if msg.error().code() == KafkaError._PARTITION_EOF:
                        logger.debug("Reached end of partition")
                    else:
                        logger.error(f"Consumer error: {msg.error()}")
                    continue

                # TODO: Deserialize using Avro schema
                # value = self.deserializer(msg.value(), SerializationContext(...))
                
                # For now, assume JSON format
                event_data = json.loads(msg.value().decode("utf-8"))
                event = BehaviorEvent(event_data)
                
                logger.debug(f"Received event: {event}")
                yield event

            except json.JSONDecodeError as e:
                logger.error(f"Failed to parse event JSON: {e}")
                continue
            except Exception as e:
                logger.error(f"Consumer error: {e}")
                await asyncio.sleep(1)

    async def stop(self):
        """Stop consuming and close connection"""
        logger.info("Stopping Kafka consumer...")
        self._running = False
        if self.consumer:
            self.consumer.close()
        logger.info("Consumer stopped")

    async def seek_to_beginning(self):
        """Seek to beginning of topics (for replaying)"""
        if self.consumer:
            # TODO: Implement seek to beginning
            pass

    async def get_lag(self) -> Dict[str, int]:
        """Get current consumer lag per topic"""
        # TODO: Implement lag calculation
        return {}
