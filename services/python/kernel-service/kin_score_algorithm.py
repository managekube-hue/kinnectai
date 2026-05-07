"""
Kinnection Coefficient (KC) Kernel — PRODUCTION IMPLEMENTATION
Immutable Algorithm v2 — Sections 4.1–4.3
"""
from dataclasses import dataclass
from typing import Dict, Optional, List
import numpy as np
import psycopg2
from neo4j import GraphDatabase
from cassandra.cluster import Cluster
from pgvector.psycopg2 import register_vector
import logging

logger = logging.getLogger(__name__)

@dataclass
class UserBioIdentity:
    user_id: str
    dna_cr: float
    shared_haplogroups: int
    facial_cosine: float
    surname_match: bool
    geo_overlap_cities: int
    known_associate_overlap: int
    historical_markers_shared: int
    reunion_sentiment_boost: float
    vault_memories_recent: int
    steward_designated: bool
    baby_product_purchase: bool
    existing_dna_kit: bool
    inactive_90_days: bool
    distance_km: float
    shared_active_branch: bool
    previous_dismissal: bool

class KCKernel:
    # Trade Secret Weights (Immutable Algorithm v2, Section 4.1)
    WEIGHTS = {
        "dna_cr_verified": 40.0,
        "shared_haplogroup": 10.0,
        "facial_similarity": 30.0,
        "surname_geo": 15.0,
        "address_overlap": 8.0,
        "associate_overlap": 12.0,
        "historical_marker": 6.0,
        "sentiment_boost": 5.0,
        "vault_creation": 8.0,
        "steward": 15.0,
        "baby_product": 25.0,
        "existing_dna": 5.0
    }

    MODIFIERS = {
        "previous_dismissal": 0.30,
        "inactive_90_days": 0.50,
        "distance_5000km": 0.70,
        "shared_active_branch": 1.20,
        "recent_life_event": 1.30,
        "strong_distant_branch": 1.15
    }

    def __init__(self, pg_dsn: str, neo4j_uri: str, neo4j_user: str, neo4j_pass: str,
                 cassandra_hosts: List[str], cassandra_keyspace: str):
        # PostgreSQL + pgvector
        self.pg_conn = psycopg2.connect(pg_dsn)
        register_vector(self.pg_conn)

        # Neo4j
        self.neo4j_driver = GraphDatabase.driver(neo4j_uri, auth=(neo4j_user, neo4j_pass))

        # Cassandra
        cass_cluster = Cluster(cassandra_hosts)
        self.cass_session = cass_cluster.connect(cassandra_keyspace)

    def calculate_kin_score(self, user_a_id: str, user_b_id: str) -> Dict:
        try:
            # 1. Pull Layer 2 (Bioidentity) from pgvector
            embeddings = self._fetch_embeddings(user_a_id, user_b_id)
            facial_cosine = self._cosine_similarity(
                embeddings.get("facial_a"), embeddings.get("facial_b")
            )

            # 2. Pull Layer 1 + 3 (Graph) from Neo4j
            graph_signals = self._fetch_graph_signals(user_a_id, user_b_id)

            # 3. Pull Layer 4 + 5 (Behavioral/Transaction) from Cassandra/PostgreSQL
            behavioral = self._fetch_behavioral(user_b_id)

            # 4. Assemble BioIdentity Vector
            bio = UserBioIdentity(
                user_id=user_b_id,
                dna_cr=embeddings.get("dna_cr", 0.0),
                shared_haplogroups=embeddings.get("haplogroup_match", 0),
                facial_cosine=facial_cosine,
                surname_match=graph_signals.get("surname_match", False),
                geo_overlap_cities=graph_signals.get("geo_overlap", 0),
                known_associate_overlap=graph_signals.get("associate_overlap", 0),
                historical_markers_shared=graph_signals.get("historical_markers", 0),
                reunion_sentiment_boost=behavioral.get("sentiment_boost", 0.0),
                vault_memories_recent=behavioral.get("vault_count", 0),
                steward_designated=behavioral.get("steward", False),
                baby_product_purchase=behavioral.get("baby_purchase", False),
                existing_dna_kit=behavioral.get("dna_kit", False),
                inactive_90_days=behavioral.get("inactive_90d", False),
                distance_km=graph_signals.get("distance_km", 9999.0),
                shared_active_branch=graph_signals.get("shared_branch", False),
                previous_dismissal=behavioral.get("prev_dismissal", False)
            )

            # 5. Compute Raw Score
            raw_score = self._apply_weights(bio)

            # 6. Apply Modifiers
            final_score = self._apply_modifiers(raw_score, bio)

            # 7. Threshold Routing
            action = self._route_by_threshold(final_score)

            return {
                "kin_score": round(final_score, 2),
                "confidence": self._compute_confidence(bio),
                "relationship_guess": self._guess_relationship(bio.dna_cr, final_score),
                "action": action,
                "cache_ttl": 300 if final_score > 50 else 3600,
                "layers_used": {
                    "dna": bio.dna_cr > 0,
                    "facial": facial_cosine > 0,
                    "graph": graph_signals.get("geo_overlap", 0) > 0,
                    "behavioral": behavioral.get("vault_count", 0) > 0
                }
            }
        except Exception as e:
            logger.error(f"KC calculation failed for {user_a_id}->{user_b_id}: {e}")
            # Fallback: return minimal score with low confidence
            return {
                "kin_score": 0.0,
                "confidence": 0.0,
                "relationship_guess": "Unknown",
                "action": "filter_out",
                "error": str(e)
            }

    def _fetch_embeddings(self, a: str, b: str) -> dict:
        """Fetch bioidentity embeddings from PostgreSQL + pgvector"""
        with self.pg_conn.cursor() as cur:
            cur.execute("""
                SELECT
                    u.user_id,
                    COALESCE(u.dna_cr, 0.0) as dna_cr,
                    COALESCE(u.haplogroup_match, 0) as haplogroup_match,
                    u.facial_embedding,
                    u.voice_embedding,
                    u.haplogroup_embedding
                FROM bioidentity_embeddings u
                WHERE u.user_id IN (%s, %s)
            """, (a, b))
            rows = cur.fetchall()
            result = {"dna_cr": 0.0, "haplogroup_match": 0}
            for row in rows:
                uid, dna_cr, hap_match, facial, voice, hap_emb = row
                if uid == a:
                    result["facial_a"] = facial
                    result["voice_a"] = voice
                    result["hap_emb_a"] = hap_emb
                elif uid == b:
                    result["facial_b"] = facial
                    result["voice_b"] = voice
                    result["hap_emb_b"] = hap_emb
                result["dna_cr"] = max(result["dna_cr"], dna_cr)
                result["haplogroup_match"] = max(result["haplogroup_match"], hap_match)
            return result

    def _fetch_graph_signals(self, a: str, b: str) -> dict:
        """Fetch graph signals from Neo4j"""
        with self.neo4j_driver.session() as session:
            result = session.run("""
                MATCH (ua:User {id: $a}), (ub:User {id: $b})
                OPTIONAL MATCH (ua)-[:LIVES_IN]->(loc:Location)<-[:LIVES_IN]-(ub)
                OPTIONAL MATCH (ua)-[:KNOWN_ASSOCIATE]-(assoc:Person)-[:KNOWN_ASSOCIATE]-(ub)
                OPTIONAL MATCH (ua)-[:SHARED_BRANCH]-(br:Branch)<-[:SHARED_BRANCH]-(ub)
                OPTIONAL MATCH (ua)-[:HISTORICAL_MARKER]->(hm:Marker)<-[:HISTORICAL_MARKER]-(ub)
                WITH ua, ub,
                     count(DISTINCT loc) as geo_overlap,
                     count(DISTINCT assoc) as assoc_overlap,
                     count(DISTINCT br) as branch_overlap,
                     count(DISTINCT hm) as marker_overlap,
                     ua.location as loc_a, ub.location as loc_b
                RETURN geo_overlap, assoc_overlap, branch_overlap, marker_overlap, loc_a, loc_b
            """, a=a, b=b)
            record = result.single()
            if not record:
                return {"surname_match": False, "geo_overlap": 0, "associate_overlap": 0,
                        "historical_markers": 0, "distance_km": 9999.0, "shared_branch": False}
            return {
                "surname_match": True,
                "geo_overlap": record["geo_overlap"] or 0,
                "associate_overlap": record["assoc_overlap"] or 0,
                "historical_markers": record["marker_overlap"] or 0,
                "distance_km": self._haversine_distance(
                    record["loc_a"], record["loc_b"]
                ) if record["loc_a"] and record["loc_b"] else 9999.0,
                "shared_branch": (record["branch_overlap"] or 0) > 0
            }

    def _fetch_behavioral(self, user_id: str) -> dict:
        """Fetch behavioral signals from Cassandra"""
        query = """
            SELECT
                AVG(sentiment_score) as sentiment_boost,
                COUNT(CASE WHEN event_type = 'vault_created' THEN 1 END) as vault_count,
                MAX(CASE WHEN event_type = 'steward_designated' THEN 1 ELSE 0 END) as steward,
                MAX(CASE WHEN event_type = 'baby_product_purchase' THEN 1 ELSE 0 END) as baby_purchase,
                MAX(CASE WHEN event_type = 'dna_kit_connected' THEN 1 ELSE 0 END) as dna_kit,
                MAX(CASE WHEN last_active < dateof(now()) - 90d THEN 1 ELSE 0 END) as inactive_90d,
                MAX(CASE WHEN event_type = 'discovery_dismissed' THEN 1 ELSE 0 END) as prev_dismissal
            FROM user_behavioral_events
            WHERE user_id = %s AND event_timestamp > dateof(now()) - 365d
        """
        try:
            row = self.cass_session.execute(query, (user_id,)).one()
            if row:
                return {
                    "sentiment_boost": float(row.sentiment_boost or 0.0),
                    "vault_count": int(row.vault_count or 0),
                    "steward": bool(row.steward),
                    "baby_purchase": bool(row.baby_purchase),
                    "dna_kit": bool(row.dna_kit),
                    "inactive_90d": bool(row.inactive_90d),
                    "prev_dismissal": bool(row.prev_dismissal)
                }
        except Exception as e:
            logger.warning(f"Cassandra query failed for {user_id}: {e}")
        return {
            "sentiment_boost": 0.0, "vault_count": 0, "steward": False,
            "baby_purchase": False, "dna_kit": False, "inactive_90d": False, "prev_dismissal": False
        }

    def _apply_weights(self, bio: UserBioIdentity) -> float:
        score = 0.0
        if bio.dna_cr > 0:
            score += self.WEIGHTS["dna_cr_verified"] * min(bio.dna_cr / 0.50, 1.0)
        score += min(bio.shared_haplogroups * self.WEIGHTS["shared_haplogroup"], 20.0)
        score += min(bio.facial_cosine * self.WEIGHTS["facial_similarity"], 30.0)
        if bio.surname_match:
            score += self.WEIGHTS["surname_geo"]
        score += min(bio.geo_overlap_cities * self.WEIGHTS["address_overlap"], 32.0)
        score += min(bio.known_associate_overlap * self.WEIGHTS["associate_overlap"], 48.0)
        score += min(bio.historical_markers_shared * self.WEIGHTS["historical_marker"], 18.0)
        score += min(bio.reunion_sentiment_boost * self.WEIGHTS["sentiment_boost"], 5.0)
        score += min(bio.vault_memories_recent * self.WEIGHTS["vault_creation"], 32.0)
        if bio.steward_designated:
            score += self.WEIGHTS["steward"]
        if bio.baby_product_purchase:
            score += self.WEIGHTS["baby_product"]
        if bio.existing_dna_kit:
            score += self.WEIGHTS["existing_dna"]
        return score

    def _apply_modifiers(self, raw: float, bio: UserBioIdentity) -> float:
        mod = 1.0
        if bio.previous_dismissal:
            mod *= self.MODIFIERS["previous_dismissal"]
        if bio.inactive_90_days:
            mod *= self.MODIFIERS["inactive_90_days"]
        if bio.distance_km > 5000:
            mod *= self.MODIFIERS["distance_5000km"]
        if bio.shared_active_branch:
            mod *= self.MODIFIERS["shared_active_branch"]
        if bio.baby_product_purchase or bio.steward_designated:
            mod *= self.MODIFIERS["recent_life_event"]
        if not bio.shared_active_branch and bio.dna_cr < 0.01:
            mod *= self.MODIFIERS["strong_distant_branch"]
        return raw * mod

    def _route_by_threshold(self, score: float) -> str:
        if score >= 80: return "auto_discovery_card"
        if score >= 50: return "soft_discovery_card"
        if score >= 25: return "log_candidate"
        return "filter_out"

    def _cosine_similarity(self, a: np.ndarray, b: np.ndarray) -> float:
        if a is None or b is None or len(a) == 0 or len(b) == 0:
            return 0.0
        return float(np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b)))

    def _compute_confidence(self, bio: UserBioIdentity) -> float:
        verified = sum([
            bio.dna_cr > 0, bio.facial_cosine > 0, bio.surname_match,
            bio.geo_overlap_cities > 0, bio.vault_memories_recent > 0
        ])
        return round((verified / 5.0) * 0.95, 2)

    def _guess_relationship(self, dna_cr: float, score: float) -> str:
        if dna_cr >= 0.25: return "Parent / Child / Half-Sibling"
        if dna_cr >= 0.125: return "1st Cousin / Grandparent"
        if dna_cr >= 0.0625: return "2nd Cousin"
        if dna_cr >= 0.03125: return "3rd Cousin"
        if score >= 50: return "Probable Distant Kin (Ancestral Branch)"
        return "Unverified Connection"

    def _haversine_distance(self, loc1: Dict, loc2: Dict) -> float:
        """Calculate distance between two {lat, lng} dicts in km"""
        if not loc1 or not loc2:
            return 9999.0
        from math import radians, sin, cos, sqrt, atan2
        R = 6371.0  # Earth radius in km
        lat1, lon1 = radians(loc1.get("lat", 0)), radians(loc1.get("lng", 0))
        lat2, lon2 = radians(loc2.get("lat", 0)), radians(loc2.get("lng", 0))
        dlat = lat2 - lat1
        dlon = lon2 - lon1
        a = sin(dlat/2)**2 + cos(lat1)*cos(lat2)*sin(dlon/2)**2
        c = 2 * atan2(sqrt(a), sqrt(1-a))
        return R * c
        "existing_dna": 5.0,
    }

    MODIFIERS = {
        "previous_dismissal": 0.30,
        "inactive_90_days": 0.50,
        "distance_5000km": 0.70,
        "shared_active_branch": 1.20,
        "recent_life_event": 1.30,
        "strong_distant_branch": 1.15,
    }

    def __init__(
        self,
        pg_dsn: str,
        neo4j_uri: str,
        neo4j_user: str,
        neo4j_pass: str,
        cassandra_hosts: str = "",
        cassandra_port: str = "9042",
        cassandra_user: str = "",
        cassandra_pass: str = "",
        cassandra_keyspace: str = "kinnectai_events",
    ):
        self.pg_conn = psycopg2.connect(pg_dsn)
        self.neo4j_driver = GraphDatabase.driver(neo4j_uri, auth=(neo4j_user, neo4j_pass))
        self.cassandra_session = None

        cassandra_hosts_list = [host.strip() for host in cassandra_hosts.split(",") if host.strip()]
        if cassandra_hosts_list:
            auth_provider = None
            if cassandra_user and cassandra_pass:
                auth_provider = PlainTextAuthProvider(username=cassandra_user, password=cassandra_pass)
            try:
                cluster = Cluster(cassandra_hosts_list, port=int(cassandra_port), auth_provider=auth_provider)
                self.cassandra_session = cluster.connect(cassandra_keyspace)
            except Exception as exc:
                print(f"warning: cassandra connection failed, falling back to query-only mode: {exc}")

    def calculate_kin_score(self, user_a_id: str, user_b_id: str) -> Dict:
        embeddings = self._fetch_embeddings(user_a_id, user_b_id)
        facial_cosine = self._cosine_similarity(embeddings["facial_a"], embeddings["facial_b"])
        graph_signals = self._fetch_graph_signals(user_a_id, user_b_id)
        behavioral = self._fetch_behavioral(user_b_id)

        bio = UserBioIdentity(
            user_id=user_b_id,
            dna_cr=embeddings["dna_cr"],
            shared_haplogroups=embeddings["haplogroup_match"],
            facial_cosine=facial_cosine,
            surname_match=graph_signals["surname_match"],
            geo_overlap_cities=graph_signals["geo_overlap"],
            known_associate_overlap=graph_signals["associate_overlap"],
            historical_markers_shared=graph_signals["historical_markers"],
            reunion_sentiment_boost=behavioral["sentiment_boost"],
            vault_memories_recent=behavioral["vault_count"],
            steward_designated=behavioral["steward"],
            baby_product_purchase=behavioral["baby_purchase"],
            existing_dna_kit=behavioral["dna_kit"],
            inactive_90_days=behavioral["inactive_90d"],
            distance_km=graph_signals["distance_km"],
            shared_active_branch=graph_signals["shared_branch"],
            previous_dismissal=behavioral["prev_dismissal"],
        )

        raw_score = self._apply_weights(bio)
        final_score = self._apply_modifiers(raw_score, bio)
        action = self._route_by_threshold(final_score)

        return {
            "kin_score": round(final_score, 2),
            "confidence": self._compute_confidence(bio),
            "relationship_guess": self._guess_relationship(bio.dna_cr, final_score),
            "action": action,
            "cache_ttl": 300 if final_score > 50 else 3600,
        }

    def _apply_weights(self, bio: UserBioIdentity) -> float:
        score = 0.0
        if bio.dna_cr > 0:
            score += self.WEIGHTS["dna_cr_verified"] * min(bio.dna_cr / 0.50, 1.0)
        score += min(bio.shared_haplogroups * self.WEIGHTS["shared_haplogroup"], 20.0)
        score += min(bio.facial_cosine * self.WEIGHTS["facial_similarity"], 30.0)
        if bio.surname_match:
            score += self.WEIGHTS["surname_geo"]
        score += min(bio.geo_overlap_cities * self.WEIGHTS["address_overlap"], 32.0)
        score += min(bio.known_associate_overlap * self.WEIGHTS["associate_overlap"], 48.0)
        score += min(bio.historical_markers_shared * self.WEIGHTS["historical_marker"], 18.0)
        score += min(bio.reunion_sentiment_boost * self.WEIGHTS["sentiment_boost"], 5.0)
        score += min(bio.vault_memories_recent * self.WEIGHTS["vault_creation"], 32.0)
        if bio.steward_designated:
            score += self.WEIGHTS["steward"]
        if bio.baby_product_purchase:
            score += self.WEIGHTS["baby_product"]
        if bio.existing_dna_kit:
            score += self.WEIGHTS["existing_dna"]
        return score

    def _apply_modifiers(self, raw: float, bio: UserBioIdentity) -> float:
        mod = 1.0
        if bio.previous_dismissal:
            mod *= self.MODIFIERS["previous_dismissal"]
        if bio.inactive_90_days:
            mod *= self.MODIFIERS["inactive_90_days"]
        if bio.distance_km > 5000:
            mod *= self.MODIFIERS["distance_5000km"]
        if bio.shared_active_branch:
            mod *= self.MODIFIERS["shared_active_branch"]
        if bio.baby_product_purchase or bio.steward_designated:
            mod *= self.MODIFIERS["recent_life_event"]
        if not bio.shared_active_branch and bio.dna_cr < 0.01:
            mod *= self.MODIFIERS["strong_distant_branch"]
        return raw * mod

    def _route_by_threshold(self, score: float) -> str:
        if score >= 80:
            return "auto_discovery_card"
        if score >= 50:
            return "soft_discovery_card"
        if score >= 25:
            return "log_candidate"
        return "filter_out"

    def _fetch_embeddings(self, a: str, b: str) -> dict:
        with self.pg_conn.cursor() as cur:
            cur.execute(
                """
                SELECT user_id::text, dna_cr, haplogroup_match, facial_embedding::float8[]
                FROM bioidentity_embeddings
                WHERE user_id IN (%s, %s)
                """,
                (a, b),
            )
            rows = cur.fetchall()

        embeddings = {"dna_cr": 0.0, "haplogroup_match": 0, "facial_a": None, "facial_b": None}
        for row in rows:
            user_id, dna_cr, haplogroup_match, facial_array = row
            if user_id == b:
                embeddings["dna_cr"] = float(dna_cr or 0.0)
                embeddings["haplogroup_match"] = int(haplogroup_match or 0)
            vector = np.array(facial_array, dtype=float) if facial_array is not None else None
            if user_id == a:
                embeddings["facial_a"] = vector
            elif user_id == b:
                embeddings["facial_b"] = vector

        return embeddings

    def _fetch_graph_signals(self, a: str, b: str) -> dict:
        surname_match = False
        with self.pg_conn.cursor() as cur:
            cur.execute(
                "SELECT user_id::text, COALESCE(surname, '') FROM users WHERE user_id IN (%s, %s)",
                (a, b),
            )
            user_rows = {str(row[0]): row[1] for row in cur.fetchall()}
            surname_match = (
                user_rows.get(a, "").strip().lower() != "" and
                user_rows.get(a, "").strip().lower() == user_rows.get(b, "").strip().lower()
            )

        with self.neo4j_driver.session() as session:
            result = session.run(
                """
                MATCH (ua:User {id: $a}), (ub:User {id: $b})
                OPTIONAL MATCH (ua)-[:LIVES_IN]->(loc)<-[:LIVES_IN]-(ub)
                OPTIONAL MATCH (ua)-[:KNOWN_ASSOCIATE]-(assoc)-[:KNOWN_ASSOCIATE]-(ub)
                OPTIONAL MATCH (ua)-[:SHARED_BRANCH]-(branch)<-[:SHARED_BRANCH]-(ub)
                OPTIONAL MATCH (ua)-[:LIVES_IN]->(locA:Location)
                OPTIONAL MATCH (ub)-[:LIVES_IN]->(locB:Location)
                OPTIONAL MATCH (ua)-[:MENTIONED_IN]->(marker:HistoricalMarker)<-[:MENTIONED_IN]-(ub)
                RETURN count(DISTINCT loc) AS geo,
                       count(DISTINCT assoc) AS assoc,
                       count(DISTINCT branch) AS branch,
                       count(DISTINCT marker) AS markers,
                       head(collect(locA.latitude)) AS latA,
                       head(collect(locA.longitude)) AS lonA,
                       head(collect(locB.latitude)) AS latB,
                       head(collect(locB.longitude)) AS lonB
                """,
                a=a,
                b=b,
            )
            record = result.single()

        distance_km = 9999.0
        if record and record["latA"] is not None and record["lonA"] is not None and record["latB"] is not None and record["lonB"] is not None:
            distance_km = self._haversine_distance(
                float(record["latA"]),
                float(record["lonA"]),
                float(record["latB"]),
                float(record["lonB"]),
            )

        return {
            "surname_match": surname_match,
            "geo_overlap": int(record["geo"]) if record else 0,
            "associate_overlap": int(record["assoc"]) if record else 0,
            "historical_markers": int(record["markers"]) if record else 0,
            "distance_km": distance_km,
            "shared_branch": bool(record["branch"]) if record else False,
        }

    def _fetch_behavioral(self, user_id: str) -> dict:
        data = {
            "sentiment_boost": 0.0,
            "vault_count": 0,
            "steward": False,
            "baby_purchase": False,
            "dna_kit": False,
            "inactive_90d": True,
            "prev_dismissal": False,
        }

        with self.pg_conn.cursor() as cur:
            cur.execute(
                "SELECT last_active, steward_user_id IS NOT NULL AS steward FROM users WHERE user_id = %s",
                (user_id,),
            )
            row = cur.fetchone()
            if row:
                last_active, steward_flag = row
                data["steward"] = bool(steward_flag)
                if last_active is not None:
                    data["inactive_90d"] = (
                        datetime.datetime.utcnow() - last_active
                    ).days >= 90

            cur.execute(
                "SELECT COUNT(1) FROM memories WHERE (creator_id = %s OR recipient_id = %s) AND created_at >= NOW() - INTERVAL '90 days'",
                (user_id, user_id),
            )
            row = cur.fetchone()
            data["vault_count"] = int(row[0]) if row and row[0] is not None else 0

            cur.execute(
                "SELECT EXISTS(SELECT 1 FROM bioidentity_embeddings WHERE user_id = %s)",
                (user_id,),
            )
            row = cur.fetchone()
            data["dna_kit"] = bool(row[0]) if row else False

        if self.cassandra_session is not None:
            try:
                query = "SELECT event_type, event_payload FROM behavioral_events WHERE user_id = %s LIMIT 200"
                rows = self.cassandra_session.execute(query, (uuid.UUID(user_id),))
                for row in rows:
                    event_type = str(row.event_type).lower()
                    payload = row.event_payload
                    if event_type in {"baby_product_purchase", "baby_purchase", "baby_product"}:
                        data["baby_purchase"] = True
                    if event_type in {"dismissal", "connection_dismissed", "candidate_rejected"}:
                        data["prev_dismissal"] = True
                    if "sentiment" in event_type:
                        score = 0.0
                        if payload:
                            try:
                                parsed = json.loads(payload)
                                if isinstance(parsed, dict):
                                    score = float(parsed.get("score", parsed.get("sentiment", 0.0)))
                                else:
                                    score = float(parsed)
                            except Exception:
                                try:
                                    score = float(payload)
                                except Exception:
                                    score = 0.0
                        data["sentiment_boost"] = max(data["sentiment_boost"], min(max(score, 0.0), 1.0))
            except Exception as exc:
                print(f"warning: cassandra behavioral event query failed: {exc}")

        return data

    def _cosine_similarity(self, a: Optional[np.ndarray], b: Optional[np.ndarray]) -> float:
        if a is None or b is None:
            return 0.0
        try:
            return float(np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b)))
        except Exception:
            return 0.0

    def _compute_confidence(self, bio: UserBioIdentity) -> float:
        verified = sum([
            bool(bio.dna_cr > 0),
            bool(bio.facial_cosine > 0),
            bool(bio.surname_match),
            bool(bio.geo_overlap_cities > 0),
            bool(bio.vault_memories_recent > 0),
        ])
        return round((verified / 5.0) * 0.95, 2)

    def _guess_relationship(self, dna_cr: float, score: float) -> str:
        if dna_cr >= 0.25:
            return "Parent / Child / Half-Sibling"
        if dna_cr >= 0.125:
            return "1st Cousin / Grandparent"
        if dna_cr >= 0.0625:
            return "2nd Cousin"
        if dna_cr >= 0.03125:
            return "3rd Cousin"
        if score >= 50:
            return "Probable Distant Kin (Ancestral Branch)"
        return "Unverified Connection"

    def _haversine_distance(self, lat1: float, lon1: float, lat2: float, lon2: float) -> float:
        radius = 6371.0
        dlat = math.radians(lat2 - lat1)
        dlon = math.radians(lon2 - lon1)
        a = math.sin(dlat / 2) ** 2 + math.cos(math.radians(lat1)) * math.cos(math.radians(lat2)) * math.sin(dlon / 2) ** 2
        c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
        return radius * c
