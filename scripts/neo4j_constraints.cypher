// Neo4j constraints and indexes for the biological graph
// Run once on database initialization

// ─── User nodes ───────────────────────────────────────────
CREATE CONSTRAINT user_id_unique IF NOT EXISTS
FOR (u:User) REQUIRE u.id IS UNIQUE;

CREATE CONSTRAINT user_username_unique IF NOT EXISTS
FOR (u:User) REQUIRE u.username IS UNIQUE;

// ─── Branch nodes ─────────────────────────────────────────
CREATE CONSTRAINT branch_id_unique IF NOT EXISTS
FOR (b:Branch) REQUIRE b.id IS UNIQUE;

// ─── Historical person nodes (AADR) ───────────────────────
CREATE CONSTRAINT historical_person_id_unique IF NOT EXISTS
FOR (h:HistoricalPerson) REQUIRE h.aadr_id IS UNIQUE;

// ─── Indexes for fast Kin Score queries ───────────────────
CREATE INDEX user_haplogroup IF NOT EXISTS
FOR (u:User) ON (u.haplogroup_maternal);

CREATE INDEX user_kin_score IF NOT EXISTS
FOR ()-[r:KINNECTED]-() ON (r.kin_score);

CREATE INDEX user_surname IF NOT EXISTS
FOR (u:User) ON (u.surname_anchor);

// ─── Example relationship schema (Cypher DDL comments) ────
//
// (:User)-[:KINNECTED {
//   kin_score: Float,
//   relationship_type: String,
//   confirmation_method: String,
//   confirmed_at: DateTime
// }]->(:User)
//
// (:User)-[:MEMBER_OF]->(:Branch)
//
// (:User)-[:DESCENDS_FROM {
//   confidence: Float,
//   shared_snp_count: Integer,
//   haplogroup_distance: Float
// }]->(:HistoricalPerson)
//
// (:HistoricalPerson)-[:ANCESTRAL_MATCH {
//   shared_snps: Integer,
//   confidence: Float
// }]->(:User)
