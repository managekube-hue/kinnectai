# shared-libs/python/auth
# JWT validation, consent enforcement, step-up auth middleware

import jwt
from typing import List, Dict

class Claims:
    def __init__(self, payload: dict):
        self.sub = payload.get("sub")
        self.iss = payload.get("iss")
        self.aud = payload.get("aud", [])
        self.consent_tiers = payload.get("consent_tiers", [])
        self.scopes = payload.get("scopes", {})
        self.stepup_verified = payload.get("stepup_verified", False)
        self.att_status = payload.get("att_status")
        self.consent_flags = payload.get("consent_flags", 0)

def validate_consent(claims: Claims, tier: str) -> bool:
    """Check if user has required consent tier"""
    return tier in claims.consent_tiers

def validate_scope(claims: Claims, service: str, action: str) -> bool:
    """Check if JWT has required scope"""
    if service not in claims.scopes:
        return False
    return action in claims.scopes[service]
