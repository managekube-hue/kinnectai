#!/usr/bin/env python3
# validate-imports.py
# ===================
# Prevents package import violations and enforces clean dependency trees

import os
import re
import sys
from pathlib import Path
from collections import defaultdict

class ImportValidator:
    CRITICAL_VIOLATIONS = [
        r"services/\w+/.*imports.*services/(?!\w+/internal)",  # Cross-service imports
        r"internal/domain/.*imports.*internal/infrastructure",   # Domain imports infra
        r"internal/transport/.*imports.*internal/domain/.*service\.go",  # Transport logic
    ]
    
    PROHIBITED_IMPORTS = {
        "domain": ["transport", "http", "grpc", "database", "sql"],
        "application": ["transport", "http", "grpc"],
        "infrastructure": [],
        "transport": ["domain"],
    }
    
    def __init__(self, root_path="services"):
        self.root_path = root_path
        self.violations = []
        self.import_graph = defaultdict(set)
        
    def validate_service(self, service_path):
        """Validate a single service for import violations"""
        go_files = Path(service_path).rglob("*.go")
        
        for go_file in go_files:
            with open(go_file, 'r') as f:
                content = f.read()
                imports = self._extract_imports(content)
                layer = self._get_layer(go_file)
                
                for imp in imports:
                    self._check_import(go_file, imp, layer)
                    self.import_graph[str(go_file)].add(imp)
    
    def _extract_imports(self, content):
        """Extract all import statements from Go file"""
        pattern = r'import\s*\(\s*(.*?)\s*\)|import\s*"([^"]+)"'
        imports = []
        
        for match in re.finditer(pattern, content, re.DOTALL):
            if match.group(1):  # Multi-line import
                for line in match.group(1).split('\n'):
                    line = line.strip().strip('"').strip()
                    if line and not line.startswith("//"):
                        imports.append(line)
            elif match.group(2):  # Single import
                imports.append(match.group(2))
        
        return imports
    
    def _get_layer(self, file_path):
        """Determine which architectural layer a file belongs to"""
        path_str = str(file_path)
        if "/domain/" in path_str:
            return "domain"
        elif "/application/" in path_str:
            return "application"
        elif "/infrastructure/" in path_str:
            return "infrastructure"
        elif "/transport/" in path_str:
            return "transport"
        return "unknown"
    
    def _check_import(self, file_path, imp, layer):
        """Check if import violates policies"""
        if layer not in self.PROHIBITED_IMPORTS:
            return
        
        prohibited = self.PROHIBITED_IMPORTS[layer]
        for p in prohibited:
            if p in imp:
                self.violations.append({
                    "file": str(file_path),
                    "layer": layer,
                    "import": imp,
                    "reason": f"{layer} layer cannot import {p}",
                    "severity": "HIGH" if layer == "domain" else "MEDIUM"
                })
    
    def validate_all(self):
        """Validate all services"""
        services = [d for d in Path(self.root_path).iterdir() if d.is_dir()]
        
        for service in services:
            self.validate_service(service)
        
        return self.violations
    
    def detect_cycles(self):
        """Detect cyclic dependencies"""
        visited = set()
        rec_stack = set()
        cycles = []
        
        def dfs(node, path):
            visited.add(node)
            rec_stack.add(node)
            path.append(node)
            
            for neighbor in self.import_graph.get(node, []):
                if neighbor not in visited:
                    dfs(neighbor, path[:])
                elif neighbor in rec_stack:
                    cycles.append(path + [neighbor])
            
            rec_stack.remove(node)
        
        for node in self.import_graph:
            if node not in visited:
                dfs(node, [])
        
        return cycles

def main():
    validator = ImportValidator("services")
    violations = validator.validate_all()
    cycles = validator.detect_cycles()
    
    print("╔═══════════════════════════════════════════════════════════════════════════╗")
    print("║ IMPORT VALIDATOR                                                          ║")
    print("╚═══════════════════════════════════════════════════════════════════════════╝")
    
    if not violations and not cycles:
        print("✅ All imports are valid")
        return 0
    
    if violations:
        print(f"\n❌ Found {len(violations)} import violations:\n")
        for v in violations:
            print(f"  {v['severity']:8} | {v['file']}")
            print(f"           {v['reason']}")
            print()
    
    if cycles:
        print(f"\n🔄 Found {len(cycles)} cyclic dependencies:\n")
        for cycle in cycles:
            print(f"  Cycle: {' -> '.join(cycle)}")
    
    return 1 if violations or cycles else 0

if __name__ == "__main__":
    sys.exit(main())
