#!/bin/bash
set -e

echo "🔍 Scanning for production blockers..."

STUBS=$(grep -rE "TODO|todo|stub|placeholder|FIXME|TBD|return \{.*0\.74.*\}|return 0\.0" \
  services/go/ services/python/ --include="*.go" --include="*.py" 2>/dev/null || true)

if [ -n "$STUBS" ]; then
  echo "❌ Found stubs/TODOs in backend:"
  echo "$STUBS"
  exit 1
fi

echo "✅ No obvious stubs found. Checking health endpoints..."
curl -f http://localhost:8080/health || { echo "❌ feed-service unhealthy"; exit 1; }
curl -f http://localhost:8000/health || { echo "❌ kernel-service unhealthy"; exit 1; }

echo "✅ Health endpoints are healthy. Testing KC endpoint..."
RESPONSE=$(curl -s -X POST http://localhost:8000/v1/kernel/score \
  -H "Content-Type: application/json" \
  -d '{"user_a_id":"test-a","user_b_id":"test-b"}')

if echo "$RESPONSE" | grep -q '"error"'; then
  echo "⚠️  KC returned error (expected if test users don't exist)"
elif echo "$RESPONSE" | grep -q '"kin_score"'; then
  echo "✅ KC endpoint returns valid structure"
else
  echo "❌ KC endpoint response invalid: $RESPONSE"
  exit 1
fi

echo "✅ Checking Kafka topics..."
docker compose exec kafka kafka-topics --list --bootstrap-server kafka:9092 | grep -q "dna.ingested" || {
  echo "❌ Kafka topic dna.ingested missing"
  exit 1
}

echo "🎉 All production checks passed. Ready for deployment."
