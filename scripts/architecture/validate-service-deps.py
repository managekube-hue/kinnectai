#!/usr/bin/env python3
# validate-service-deps.py
# ========================
# Validates service dependencies match SERVICE_STATUS.yaml
# Detects undeclared, missing, or cyclic dependencies

import yaml
from pathlib import Path
import sys
from collections import defaultdict, deque

class ServiceDependencyValidator:
    def __init__(self, services_dir="services", status_file="services/SERVICE_STATUS.yaml"):
        self.services_dir = Path(services_dir)
        self.status_file = Path(status_file)
        self.service_status = self._load_service_status()
        self.violations = []
        self.detected_deps = defaultdict(set)
    
    def _load_service_status(self):
        """Load SERVICE_STATUS.yaml"""
        if not self.status_file.exists():
            return {}
        
        with open(self.status_file) as f:
            return yaml.safe_load(f)
    
    def detect_dependencies(self, service_dir):
        """Detect actual dependencies from code"""
        go_files = list(Path(service_dir).rglob("*.go"))
        py_files = list(Path(service_dir).rglob("*.py"))
        
        service_name = Path(service_dir).name
        
        for file in go_files + py_files:
            with open(file) as f:
                content = f.read()
            
            # Detect imports from other services
            import_patterns = [
                r'github\.com/kinnectai/services/(\w+)',
                r'from\s+services\.(\w+)',
                r'import.*".*services/(\w+)',
            ]
            
            for pattern in import_patterns:
                import re
                for match in re.finditer(pattern, content):
                    dep = match.group(1)
                    if dep != service_name:
                        self.detected_deps[service_name].add(dep)
    
    def validate_declared_vs_actual(self):
        """Ensure declared dependencies match actual dependencies"""
        services = self.service_status.get("services", {})
        
        for service_name, config in services.items():
            service_path = self.services_dir / service_name
            
            if not service_path.exists():
                continue
            
            self.detect_dependencies(service_path)
            
            declared = set(config.get("dependencies", []))
            detected = self.detected_deps.get(service_name, set())
            
            # Filter out infrastructure services (postgres, neo4j, etc)
            detected = {d for d in detected if d in services}
            
            # Undeclared dependencies
            undeclared = detected - declared
            for dep in undeclared:
                self.violations.append({
                    "severity": "HIGH",
                    "service": service_name,
                    "issue": "Undeclared dependency",
                    "dependency": dep,
                    "message": f"{service_name} uses {dep} but not declared in SERVICE_STATUS.yaml"
                })
            
            # Unused declarations
            unused = declared - detected
            for dep in unused:
                if dep not in ["postgres", "redis", "kafka", "neo4j", "cassandra", "s3", "kms", "fcm", "stripe"]:
                    self.violations.append({
                        "severity": "LOW",
                        "service": service_name,
                        "issue": "Unused dependency",
                        "dependency": dep,
                        "message": f"{service_name} declares {dep} but doesn't appear to use it"
                    })
    
    def detect_cyclic_dependencies(self):
        """Detect cyclic service dependencies"""
        services = self.service_status.get("services", {})
        graph = {}
        
        for service_name, config in services.items():
            graph[service_name] = set(config.get("dependencies", []))
        
        # DFS-based cycle detection
        visited = set()
        rec_stack = set()
        cycles = []
        
        def dfs(node, path):
            visited.add(node)
            rec_stack.add(node)
            path.append(node)
            
            for neighbor in graph.get(node, []):
                if neighbor not in services:  # Skip infrastructure
                    continue
                
                if neighbor not in visited:
                    dfs(neighbor, path[:])
                elif neighbor in rec_stack:
                    cycle = path + [neighbor]
                    cycles.append(cycle)
            
            rec_stack.remove(node)
        
        for service in graph:
            if service not in visited:
                dfs(service, [])
        
        for cycle in cycles:
            self.violations.append({
                "severity": "CRITICAL",
                "issue": "Cyclic dependency",
                "cycle": " -> ".join(cycle),
                "message": f"Cyclic dependency detected: {' -> '.join(cycle)}"
            })
    
    def validate_tier_dependencies(self):
        """Validate tier respects dependency hierarchy"""
        services = self.service_status.get("services", {})
        tier_levels = {"critical": 3, "high": 2, "medium": 1, "low": 0}
        
        for service_name, config in services.items():
            service_tier = tier_levels.get(config.get("tier", "low"), 0)
            
            for dep in config.get("dependencies", []):
                if dep not in services:
                    continue
                
                dep_tier = tier_levels.get(services[dep].get("tier", "low"), 0)
                
                # Lower tier services shouldn't depend on higher tier
                if service_tier < dep_tier:
                    self.violations.append({
                        "severity": "MEDIUM",
                        "service": service_name,
                        "tier": config.get("tier"),
                        "dependency": dep,
                        "dep_tier": services[dep].get("tier"),
                        "message": f"{service_name} ({config.get('tier')}) depends on {dep} ({services[dep].get('tier')})"
                    })
    
    def validate_all(self):
        """Run all validations"""
        self.validate_declared_vs_actual()
        self.detect_cyclic_dependencies()
        self.validate_tier_dependencies()
        return self.violations

def main():
    validator = ServiceDependencyValidator()
    violations = validator.validate_all()
    
    print("╔═══════════════════════════════════════════════════════════════════════════╗")
    print("║ SERVICE DEPENDENCY VALIDATOR                                              ║")
    print("╚═══════════════════════════════════════════════════════════════════════════╝")
    
    if not violations:
        print("✅ All service dependencies are valid and consistent")
        return 0
    
    critical = [v for v in violations if v.get("severity") == "CRITICAL"]
    high = [v for v in violations if v.get("severity") == "HIGH"]
    medium = [v for v in violations if v.get("severity") == "MEDIUM"]
    low = [v for v in violations if v.get("severity") == "LOW"]
    
    if critical:
        print(f"\n❌ CRITICAL ({len(critical)}):")
        for v in critical:
            print(f"  {v['issue']}: {v['message']}")
    
    if high:
        print(f"\n⚠️  HIGH ({len(high)}):")
        for v in high:
            print(f"  {v['service']}: {v['message']}")
    
    if medium:
        print(f"\nℹ️  MEDIUM ({len(medium)}):")
        for v in medium:
            print(f"  {v['service']}: {v['message']}")
    
    if low:
        print(f"\n💡 LOW ({len(low)}):")
        for v in low:
            print(f"  {v['service']}: {v['message']}")
    
    return 1 if critical else 0

if __name__ == "__main__":
    sys.exit(main())
