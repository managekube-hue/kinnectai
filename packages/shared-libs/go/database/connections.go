// shared-libs/go/database
// Database connection pools and utilities

package database

// PostgreSQL connection pool
type PostgresPool struct {
	DSN string
	// implement pgx.Pool
}

// Neo4j driver
type Neo4jDriver struct {
	URI string
	// implement neo4j.Driver
}

// Redis client
type RedisClient struct {
	Addr string
	// implement redis.Client
}

// Cassandra session
type CassandraSession struct {
	Nodes []string
	// implement gocql.Session
}
