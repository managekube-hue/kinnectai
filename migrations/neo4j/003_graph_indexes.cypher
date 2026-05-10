// Neo4j: Create constraints and indexes for Graph operations
// Execute in Neo4j Browser or cypher-shell

CREATE CONSTRAINT user_id_unique IF NOT EXISTS FOR (u:User) REQUIRE u.user_id IS UNIQUE;
CREATE CONSTRAINT kinnection_unique IF NOT EXISTS FOR ()-[k:KINNECTION]-() REQUIRE k.kinnection_id IS UNIQUE;
CREATE CONSTRAINT branch_id_unique IF NOT EXISTS FOR (b:Branch) REQUIRE b.branch_id IS UNIQUE;
CREATE CONSTRAINT treeperson_id_unique IF NOT EXISTS FOR (p:TreePerson) REQUIRE p.person_id IS UNIQUE;

CREATE INDEX idx_user_surname IF NOT EXISTS FOR (u:User) ON (u.surname);
CREATE INDEX idx_kinnection_cr IF NOT EXISTS FOR ()-[k:KINNECTION]-() ON (k.cr_score);
CREATE INDEX idx_branch_geography IF NOT EXISTS FOR (b:Branch) ON (b.geographic_origin);
CREATE INDEX idx_treeperson_name_birth_geo IF NOT EXISTS FOR (p:TreePerson) ON (p.name, p.birth_year, p.geo_region);

CREATE FULLTEXT INDEX user_name_search IF NOT EXISTS FOR (u:User) ON EACH [u.display_name, u.surname];
CREATE FULLTEXT INDEX treeperson_search IF NOT EXISTS FOR (p:TreePerson) ON EACH [p.name];
