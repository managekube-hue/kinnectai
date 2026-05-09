-- Node Constraints
CREATE CONSTRAINT user_id IF NOT EXISTS FOR (u:User) REQUIRE u.id IS UNIQUE;
CREATE CONSTRAINT tree_node_id IF NOT EXISTS FOR (t:TreeNode) REQUIRE t.id IS UNIQUE;
CREATE CONSTRAINT branch_id IF NOT EXISTS FOR (b:Branch) REQUIRE b.id IS UNIQUE;

-- Core Relationships
CREATE INDEX kinnection_edge IF NOT EXISTS FOR ()-[r:KINNECTION]-() ON (r.cr_score);
CREATE INDEX location_edge IF NOT EXISTS FOR ()-[r:LIVES_IN]-() ON (r.city);
CREATE INDEX IF NOT EXISTS FOR ()-[r:KNOWN_ASSOCIATE]-() ON (r.relationship_strength);
CREATE INDEX IF NOT EXISTS FOR ()-[r:SHARED_BRANCH]-() ON (r.branch_id);

-- Sample Branch Detection Query (Discovery Phase 2)
MATCH (u1:User {id: $user_a})-[:SHARED_BRANCH*1..6]-(b:Branch)<-[:SHARED_BRANCH*1..6]-(u2:User {id: $user_b})
RETURN u1, u2, b, count(b) as shared_branch_count
WHERE u1 <> u2;
