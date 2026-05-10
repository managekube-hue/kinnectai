# Chaos Engineering Tests
# Weekly experiments: pod failure, latency injection, network partition

# Scenarios:
# - Kill feed-service pod → verify failover
# - Inject 500ms latency to Neo4j → verify KC fallback
# - Partition Kafka broker → verify producer retry logic
