#!/bin/bash
# Dependency Vulnerability Scanner
# Detects package manager and runs appropriate audit tool
# Usage: ./check-dependencies.sh

set -euo pipefail

echo "=== Dependency Vulnerability Scanner ==="
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

VULNS_FOUND=0

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Node.js / npm
if [ -f "package.json" ]; then
    echo "--- Node.js project detected ---"
    if command_exists npm; then
        echo "Running npm audit..."
        if npm audit --json > npm-audit.json 2>&1; then
            echo -e "${GREEN}No vulnerabilities found in npm dependencies${NC}"
        else
            VULNS_FOUND=1
            echo -e "${RED}Vulnerabilities found in npm dependencies!${NC}"
            npm audit
            echo ""
            echo "Run 'npm audit fix' to attempt automatic fixes"
        fi
    else
        echo -e "${YELLOW}npm not found, skipping audit${NC}"
    fi
    echo ""
fi

# Python / pip
if [ -f "requirements.txt" ] || [ -f "Pipfile" ] || [ -f "pyproject.toml" ]; then
    echo "--- Python project detected ---"

    if command_exists pip-audit; then
        echo "Running pip-audit..."
        if pip-audit 2>&1; then
            echo -e "${GREEN}No vulnerabilities found in pip dependencies${NC}"
        else
            VULNS_FOUND=1
            echo -e "${RED}Vulnerabilities found in pip dependencies!${NC}"
        fi
    elif command_exists safety; then
        echo "Running safety check..."
        if safety check 2>&1; then
            echo -e "${GREEN}No vulnerabilities found in pip dependencies${NC}"
        else
            VULNS_FOUND=1
            echo -e "${RED}Vulnerabilities found in pip dependencies!${NC}"
        fi
    else
        echo -e "${YELLOW}pip-audit or safety not found${NC}"
        echo "Install with: pip install pip-audit"
    fi
    echo ""
fi

# Ruby / bundler
if [ -f "Gemfile" ]; then
    echo "--- Ruby project detected ---"
    if command_exists bundle; then
        echo "Running bundle audit..."
        if bundle audit check --update 2>&1; then
            echo -e "${GREEN}No vulnerabilities found in Ruby gems${NC}"
        else
            VULNS_FOUND=1
            echo -e "${RED}Vulnerabilities found in Ruby gems!${NC}"
        fi
    else
        echo -e "${YELLOW}bundler not found, skipping audit${NC}"
    fi
    echo ""
fi

# Go
if [ -f "go.mod" ]; then
    echo "--- Go project detected ---"
    if command_exists go; then
        echo "Checking Go dependencies..."
        go list -m all
        echo ""
        echo -e "${YELLOW}Manual CVE checking required for Go${NC}"
        echo "Consider using: govulncheck or nancy"
    else
        echo -e "${YELLOW}go not found, skipping check${NC}"
    fi
    echo ""
fi

# PHP / Composer
if [ -f "composer.json" ]; then
    echo "--- PHP project detected ---"
    if command_exists composer; then
        echo "Running composer audit..."
        if composer audit 2>&1; then
            echo -e "${GREEN}No vulnerabilities found in PHP packages${NC}"
        else
            VULNS_FOUND=1
            echo -e "${RED}Vulnerabilities found in PHP packages!${NC}"
        fi
    else
        echo -e "${YELLOW}composer not found, skipping audit${NC}"
    fi
    echo ""
fi

# Rust / Cargo
if [ -f "Cargo.toml" ]; then
    echo "--- Rust project detected ---"
    if command_exists cargo; then
        if command_exists cargo-audit; then
            echo "Running cargo audit..."
            if cargo audit 2>&1; then
                echo -e "${GREEN}No vulnerabilities found in Rust crates${NC}"
            else
                VULNS_FOUND=1
                echo -e "${RED}Vulnerabilities found in Rust crates!${NC}"
            fi
        else
            echo -e "${YELLOW}cargo-audit not found${NC}"
            echo "Install with: cargo install cargo-audit"
        fi
    else
        echo -e "${YELLOW}cargo not found, skipping check${NC}"
    fi
    echo ""
fi

# .NET
if [ -f "*.csproj" ] || [ -f "*.sln" ]; then
    echo "--- .NET project detected ---"
    if command_exists dotnet; then
        echo "Running dotnet list package --vulnerable..."
        if dotnet list package --vulnerable 2>&1 | grep -q "has the following vulnerable packages"; then
            VULNS_FOUND=1
            echo -e "${RED}Vulnerabilities found in .NET packages!${NC}"
            dotnet list package --vulnerable
        else
            echo -e "${GREEN}No vulnerabilities found in .NET packages${NC}"
        fi
    else
        echo -e "${YELLOW}dotnet not found, skipping check${NC}"
    fi
    echo ""
fi

# Summary
echo "======================================"
echo "Scan complete!"
echo ""

if [ $VULNS_FOUND -gt 0 ]; then
    echo -e "${RED}VULNERABILITIES DETECTED!${NC}"
    echo "Please review and update vulnerable dependencies."
    echo ""
    echo "General recommendations:"
    echo "1. Update to patched versions"
    echo "2. Review CVE details and assess impact"
    echo "3. Consider alternative packages if no fix available"
    echo "4. Add vulnerability scanning to CI/CD pipeline"
    exit 1
else
    echo -e "${GREEN}No vulnerabilities detected${NC}"
    echo "However, always keep dependencies up to date!"
    exit 0
fi
