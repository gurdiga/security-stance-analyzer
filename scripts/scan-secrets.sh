#!/bin/bash
# Secret Scanner - Scans codebase for potential hardcoded secrets
# Usage: ./scan-secrets.sh [directory]

set -euo pipefail

TARGET_DIR="${1:-.}"

echo "=== Scanning for hardcoded secrets in: $TARGET_DIR ==="
echo ""

# Color codes
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counter
FINDINGS=0

# Function to report finding
report_finding() {
    local severity=$1
    local pattern=$2
    local file=$3
    local line=$4

    FINDINGS=$((FINDINGS + 1))

    if [ "$severity" = "HIGH" ]; then
        echo -e "${RED}[HIGH]${NC} $pattern"
    else
        echo -e "${YELLOW}[MEDIUM]${NC} $pattern"
    fi
    echo "  File: $file"
    echo "  Line: $line"
    echo ""
}

# Patterns to search for
echo "Searching for potential secrets..."
echo ""

# API Keys
echo "--- Checking for API keys ---"
grep -rn -E "(api[_-]?key|apikey)\s*[:=]\s*['\"][a-zA-Z0-9]{20,}['\"]" "$TARGET_DIR" 2>/dev/null | while read -r line; do
    file=$(echo "$line" | cut -d: -f1)
    linenum=$(echo "$line" | cut -d: -f2)
    report_finding "HIGH" "Potential API Key" "$file" "$linenum"
done

# AWS Keys
echo "--- Checking for AWS credentials ---"
grep -rn -E "(AKIA[0-9A-Z]{16}|aws_access_key_id|aws_secret_access_key)" "$TARGET_DIR" 2>/dev/null | while read -r line; do
    file=$(echo "$line" | cut -d: -f1)
    linenum=$(echo "$line" | cut -d: -f2)
    report_finding "HIGH" "AWS Credentials" "$file" "$linenum"
done

# Passwords
echo "--- Checking for passwords ---"
grep -rn -E "(password|passwd|pwd)\s*[:=]\s*['\"][^'\"]{3,}['\"]" "$TARGET_DIR" 2>/dev/null | \
    grep -v -E "(password.*:.*\*|password.*=.*env|password.*=.*process|#.*password)" | while read -r line; do
    file=$(echo "$line" | cut -d: -f1)
    linenum=$(echo "$line" | cut -d: -f2)
    report_finding "HIGH" "Hardcoded Password" "$file" "$linenum"
done

# Private Keys
echo "--- Checking for private keys ---"
grep -rn -E "(BEGIN (RSA|DSA|EC|OPENSSH) PRIVATE KEY|BEGIN PRIVATE KEY)" "$TARGET_DIR" 2>/dev/null | while read -r line; do
    file=$(echo "$line" | cut -d: -f1)
    linenum=$(echo "$line" | cut -d: -f2)
    report_finding "HIGH" "Private Key" "$file" "$linenum"
done

# JWT Tokens
echo "--- Checking for JWT tokens ---"
grep -rn -E "eyJ[a-zA-Z0-9_-]{10,}\.[a-zA-Z0-9_-]{10,}\.[a-zA-Z0-9_-]{10,}" "$TARGET_DIR" 2>/dev/null | while read -r line; do
    file=$(echo "$line" | cut -d: -f1)
    linenum=$(echo "$line" | cut -d: -f2)
    report_finding "MEDIUM" "JWT Token" "$file" "$linenum"
done

# Database Connection Strings
echo "--- Checking for database connection strings ---"
grep -rn -E "(mysql://|postgresql://|mongodb://|redis://)[a-zA-Z0-9:@]+" "$TARGET_DIR" 2>/dev/null | while read -r line; do
    file=$(echo "$line" | cut -d: -f1)
    linenum=$(echo "$line" | cut -d: -f2)
    report_finding "HIGH" "Database Connection String" "$file" "$linenum"
done

# OAuth Tokens
echo "--- Checking for OAuth tokens ---"
grep -rn -E "(access_token|oauth_token|refresh_token)\s*[:=]\s*['\"][a-zA-Z0-9]{20,}['\"]" "$TARGET_DIR" 2>/dev/null | while read -r line; do
    file=$(echo "$line" | cut -d: -f1)
    linenum=$(echo "$line" | cut -d: -f2)
    report_finding "HIGH" "OAuth Token" "$file" "$linenum"
done

# Generic Secrets
echo "--- Checking for generic secrets ---"
grep -rn -E "(secret|token)\s*[:=]\s*['\"][a-zA-Z0-9]{16,}['\"]" "$TARGET_DIR" 2>/dev/null | \
    grep -v -E "(secret.*=.*env|secret.*=.*process|#.*secret)" | while read -r line; do
    file=$(echo "$line" | cut -d: -f1)
    linenum=$(echo "$line" | cut -d: -f2)
    report_finding "MEDIUM" "Generic Secret/Token" "$file" "$linenum"
done

# Slack Tokens
echo "--- Checking for Slack tokens ---"
grep -rn -E "xox[baprs]-[0-9a-zA-Z]{10,}" "$TARGET_DIR" 2>/dev/null | while read -r line; do
    file=$(echo "$line" | cut -d: -f1)
    linenum=$(echo "$line" | cut -d: -f2)
    report_finding "HIGH" "Slack Token" "$file" "$linenum"
done

# GitHub Tokens
echo "--- Checking for GitHub tokens ---"
grep -rn -E "gh[pousr]_[0-9a-zA-Z]{36}" "$TARGET_DIR" 2>/dev/null | while read -r line; do
    file=$(echo "$line" | cut -d: -f1)
    linenum=$(echo "$line" | cut -d: -f2)
    report_finding "HIGH" "GitHub Token" "$file" "$linenum"
done

# Summary
echo "======================================"
echo "Scan complete!"
echo "Total potential secrets found: $FINDINGS"
echo ""

if [ $FINDINGS -gt 0 ]; then
    echo -e "${RED}WARNING: Potential secrets detected!${NC}"
    echo "Please review these findings and remove any hardcoded secrets."
    echo ""
    echo "Recommended actions:"
    echo "1. Move secrets to environment variables"
    echo "2. Use a secrets management service (AWS Secrets Manager, HashiCorp Vault, etc.)"
    echo "3. Never commit secrets to version control"
    echo "4. Rotate any exposed credentials"
    exit 1
else
    echo "No obvious secrets found. However, this is not a guarantee."
    echo "Consider using dedicated tools like:"
    echo "  - trufflehog"
    echo "  - gitleaks"
    echo "  - detect-secrets"
    exit 0
fi
