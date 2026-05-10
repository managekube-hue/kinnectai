#!/usr/bin/env python3
# validate-events.py
# ==================
# Validates Kafka events against governance registry
# Prevents undeclared events, schema drift, and breaking changes

import yaml
import json
from pathlib import Path
import sys

class EventValidator:
    def __init__(self, registry_path="packages/shared-contracts/registry"):
        self.registry_path = Path(registry_path)
        self.event_registry = self._load_registry("event_registry.yaml")
        self.ownership_registry = self._load_registry("ownership.yaml")
        self.schema_versions = self._load_registry("schema_versions.yaml")
        self.violations = []
    
    def _load_registry(self, filename):
        """Load YAML registry file"""
        path = self.registry_path / filename
        if not path.exists():
            return {}
        
        with open(path) as f:
            return yaml.safe_load(f)
    
    def validate_event_usage(self, service_dir):
        """Validate that events are registered and properly used"""
        python_files = Path(service_dir).rglob("*.py")
        go_files = Path(service_dir).rglob("*.go")
        
        for file in list(python_files) + list(go_files):
            with open(file) as f:
                content = f.read()
                self._check_event_declarations(content, file)
    
    def _check_event_declarations(self, content, file):
        """Check for unregistered event declarations"""
        # Pattern: event_name = "something-events" or Topic: "something-events"
        pattern = r'["\']([\w-]+-events)["\']'
        
        for match in re.finditer(pattern, content):
            event_name = match.group(1)
            if event_name not in self.event_registry.get("events", {}):
                self.violations.append({
                    "severity": "HIGH",
                    "file": str(file),
                    "issue": "Unregistered event",
                    "event": event_name,
                    "message": f"Event '{event_name}' is not in event_registry.yaml"
                })
    
    def validate_schema_versions(self):
        """Validate Avro schemas match registered versions"""
        schemas_dir = Path("packages/shared-contracts/avro")
        if not schemas_dir.exists():
            return
        
        for schema_file in schemas_dir.glob("*.avsc"):
            with open(schema_file) as f:
                schema = json.load(f)
            
            event_name = schema_file.stem
            registered = self.schema_versions.get("schema_versions", {}).get(event_name)
            
            if not registered:
                self.violations.append({
                    "severity": "MEDIUM",
                    "file": str(schema_file),
                    "issue": "Unregistered schema",
                    "message": f"Schema for '{event_name}' not in schema_versions.yaml"
                })
            else:
                # Check schema version field
                schema_version = schema.get("version")
                registered_version = registered.get("current")
                if schema_version != registered_version:
                    self.violations.append({
                        "severity": "CRITICAL",
                        "file": str(schema_file),
                        "issue": "Version mismatch",
                        "message": f"Schema version {schema_version} != registered {registered_version}"
                    })
    
    def validate_ownership(self):
        """Validate events have declared ownership"""
        events = self.event_registry.get("events", {})
        ownership = self.ownership_registry.get("ownership", {})
        
        for event_name in events:
            if event_name not in ownership:
                self.violations.append({
                    "severity": "HIGH",
                    "issue": "Missing ownership",
                    "event": event_name,
                    "message": f"Event '{event_name}' has no owner in ownership.yaml"
                })
    
    def validate_consumers(self):
        """Validate all event consumers are registered"""
        events = self.event_registry.get("events", {})
        consumers = self.ownership_registry.get("consumers", {})
        
        for event_name, event_config in events.items():
            declared_consumers = set(event_config.get("consumers", []))
            
            # Check each consumer is registered
            for consumer in declared_consumers:
                if consumer not in consumers:
                    self.violations.append({
                        "severity": "MEDIUM",
                        "event": event_name,
                        "consumer": consumer,
                        "message": f"Consumer '{consumer}' not registered in ownership.yaml"
                    })
    
    def validate_all(self):
        """Run all validations"""
        services_dir = Path("services")
        for service in services_dir.iterdir():
            if service.is_dir():
                self.validate_event_usage(service)
        
        self.validate_schema_versions()
        self.validate_ownership()
        self.validate_consumers()
        
        return self.violations

def main():
    validator = EventValidator()
    violations = validator.validate_all()
    
    print("╔═══════════════════════════════════════════════════════════════════════════╗")
    print("║ EVENT GOVERNANCE VALIDATOR                                                ║")
    print("╚═══════════════════════════════════════════════════════════════════════════╝")
    
    if not violations:
        print("✅ All events are properly registered and governed")
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
    
    return 1 if critical or high else 0

if __name__ == "__main__":
    import re
    sys.exit(main())
