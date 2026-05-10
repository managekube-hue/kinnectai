#!/usr/bin/env python3
# validate-layering.py
# ====================
# Enforces Hexagonal Architecture (Domain-Application-Infrastructure-Transport)
# Prevents layer contamination and ensures proper separation of concerns

import os
from pathlib import Path
import re
import sys

class LayeringValidator:
    LAYER_DEFINITIONS = {
        "domain": {
            "description": "Business logic, entities, value objects, domain events",
            "can_import": ["domain"],
            "file_patterns": ["entity.go", "service.go", "errors.go", "events.go"],
        },
        "application": {
            "description": "Use cases, commands, queries, handlers, DTOs",
            "can_import": ["domain", "application"],
            "file_patterns": ["command*.go", "query*.go", "handler*.go", "dto*.go"],
        },
        "infrastructure": {
            "description": "Database, cache, external service clients",
            "can_import": ["domain", "application", "infrastructure"],
            "file_patterns": ["postgres*.go", "redis*.go", "s3*.go", "mongo*.go"],
        },
        "transport": {
            "description": "HTTP/gRPC handlers, middleware, routing",
            "can_import": ["domain", "application", "infrastructure", "transport"],
            "file_patterns": ["handler*.go", "router*.go", "middleware*.go"],
        },
    }
    
    def __init__(self, services_dir="services"):
        self.services_dir = Path(services_dir)
        self.violations = []
    
    def validate_service(self, service_path):
        """Validate a service's layer structure"""
        service_path = Path(service_path)
        
        # Check required directories exist
        internal_dir = service_path / "internal"
        if not internal_dir.exists():
            self.violations.append({
                "severity": "CRITICAL",
                "file": str(service_path),
                "issue": "Missing internal/ directory",
                "message": "Service must have internal/ directory for layering"
            })
            return
        
        # Check each layer exists
        for layer in ["domain", "application", "infrastructure", "transport"]:
            layer_dir = internal_dir / layer
            if not layer_dir.exists():
                self.violations.append({
                    "severity": "HIGH",
                    "file": str(service_path),
                    "issue": f"Missing {layer}/ layer",
                    "message": f"Service must have internal/{layer}/ directory"
                })
            else:
                self._validate_layer(layer_dir, layer, service_path.name)
    
    def _validate_layer(self, layer_dir, layer_name, service_name):
        """Validate content within a layer"""
        go_files = list(layer_dir.rglob("*.go"))
        
        if layer_name == "domain" and not go_files:
            self.violations.append({
                "severity": "MEDIUM",
                "file": str(layer_dir),
                "layer": layer_name,
                "issue": "Empty domain layer",
                "message": f"{service_name}/internal/domain/ is empty"
            })
        
        # Check for required files in domain layer
        if layer_name == "domain":
            required_files = ["entity.go", "service.go", "errors.go"]
            existing = {f.name for f in go_files}
            
            for req in required_files:
                if req not in existing:
                    self.violations.append({
                        "severity": "HIGH",
                        "file": str(layer_dir),
                        "layer": layer_name,
                        "issue": f"Missing {req}",
                        "message": f"Domain layer should have {req} for clear boundaries"
                    })
        
        # Check for logic misplacement
        for go_file in go_files:
            with open(go_file) as f:
                content = f.read()
            
            self._check_logic_placement(content, go_file, layer_name)
    
    def _check_logic_placement(self, content, file_path, layer_name):
        """Check if logic is correctly placed in layer"""
        
        # Transport layer should not have business logic
        if layer_name == "transport":
            # Check for complex decision logic
            if re.search(r'if.*{.*if.*{', content):  # Nested if suggests logic
                if not re.search(r'(validation|parsing|serialization)', content):
                    self.violations.append({
                        "severity": "MEDIUM",
                        "file": str(file_path),
                        "layer": layer_name,
                        "issue": "Complex logic in transport",
                        "message": "Transport layer has complex decision logic (move to domain/application)"
                    })
        
        # Domain layer should not reference SQL, HTTP, etc
        if layer_name == "domain":
            forbidden = ["sql.Row", "http.Request", "redis.Client", "*sql.DB", "net.Conn"]
            for pattern in forbidden:
                if pattern in content:
                    self.violations.append({
                        "severity": "CRITICAL",
                        "file": str(file_path),
                        "layer": layer_name,
                        "issue": "Infrastructure in domain",
                        "message": f"Domain layer references {pattern} (infrastructure concern)"
                    })
    
    def validate_all(self):
        """Validate all services"""
        services = [d for d in self.services_dir.iterdir() if d.is_dir() and (d / "internal").exists()]
        
        for service in services:
            self.validate_service(service)
        
        return self.violations

def main():
    validator = LayeringValidator()
    violations = validator.validate_all()
    
    print("╔═══════════════════════════════════════════════════════════════════════════╗")
    print("║ HEXAGONAL ARCHITECTURE VALIDATOR                                          ║")
    print("╚═══════════════════════════════════════════════════════════════════════════╝")
    
    if not violations:
        print("✅ All services follow hexagonal architecture layering")
        return 0
    
    critical = [v for v in violations if v["severity"] == "CRITICAL"]
    high = [v for v in violations if v["severity"] == "HIGH"]
    medium = [v for v in violations if v["severity"] == "MEDIUM"]
    
    if critical:
        print(f"\n❌ CRITICAL ({len(critical)}):")
        for v in critical:
            print(f"  {v['issue']}: {v['message']}")
    
    if high:
        print(f"\n⚠️  HIGH ({len(high)}):")
        for v in high:
            print(f"  {v['issue']}: {v['message']}")
    
    if medium:
        print(f"\nℹ️  MEDIUM ({len(medium)}):")
        for v in medium:
            print(f"  {v['issue']}: {v['message']}")
    
    return 1 if critical else 0

if __name__ == "__main__":
    sys.exit(main())
