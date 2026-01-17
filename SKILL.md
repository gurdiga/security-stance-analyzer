---
name: security-stance-analyzer
description: Analyzes the security posture of systems, codebases, and infrastructure. Examines authentication, authorization, data protection, network security, dependency vulnerabilities, secrets management, and compliance. Use when assessing security risks, performing security audits, or evaluating defensive measures.
license: Apache-2.0
compatibility: May require git, grep, find, network tools (curl, nmap), and dependency scanners (npm audit, pip-audit, etc.)
metadata:
  author: security-tools
  version: "1.0"
  category: security
---

# Security Stance Analyzer

This skill performs comprehensive security posture analysis of systems, applications, and infrastructure.

## When to Use

Activate this skill when:

- User requests a security audit or security assessment
- Evaluating security risks in a codebase or system
- Checking for common vulnerabilities and misconfigurations
- Assessing compliance with security best practices
- Investigating potential security weaknesses
- Performing pre-deployment security review

## Analysis Categories

### 1. Authentication & Authorization

**What to check:**

- Authentication mechanisms (passwords, tokens, OAuth, SSO)
- Session management implementation
- Password storage (hashing algorithms, salts)
- Multi-factor authentication availability
- Authorization logic and access controls
- Role-based access control (RBAC) implementation
- JWT token validation and expiration

**Questions to answer:**

- Are credentials stored securely?
- Is session hijacking possible?
- Are there broken access controls?
- Is authentication bypass possible?

### 2. Secrets & Credentials Management

**What to check:**

- Hardcoded secrets, API keys, passwords in code
- Environment variable usage
- Secrets in version control history
- Configuration files with sensitive data
- Database connection strings
- Third-party service credentials

**Common patterns to search for:**

```
password.*=.*['"]\w+['"]
api[_-]?key.*=.*['"]\w+['"]
secret.*=.*['"]\w+['"]
token.*=.*['"]\w+['"]
AWS_ACCESS_KEY
PRIVATE_KEY
```

### 3. Input Validation & Injection Vulnerabilities

**What to check:**

- SQL injection vulnerabilities
- Command injection risks
- Cross-site scripting (XSS) vulnerabilities
- Path traversal vulnerabilities
- XML/XXE injection
- LDAP injection
- Template injection

**Key areas:**

- User input handling
- Database query construction
- System command execution
- File path operations
- API parameter processing

### 4. Data Protection

**What to check:**

- Encryption at rest
- Encryption in transit (TLS/SSL configuration)
- Sensitive data exposure
- Data retention policies
- PII handling
- Logging sensitive information
- Error messages revealing system info

**Questions to answer:**

- Is sensitive data encrypted?
- Are cryptographic libraries up to date?
- Is weak encryption being used?
- Are there insecure direct object references?

### 5. Dependency & Supply Chain Security

**What to check:**

- Outdated dependencies with known vulnerabilities
- Dependency confusion risks
- Package integrity verification
- Transitive dependency vulnerabilities
- License compliance issues

**Tools to use:**

- `npm audit` for Node.js
- `pip-audit` or `safety` for Python
- `bundle audit` for Ruby
- `go list -m all` for Go
- GitHub Dependabot alerts
- Snyk, OWASP Dependency-Check

### 6. Network Security

**What to check:**

- Open ports and services
- Firewall rules
- CORS configuration
- Content Security Policy (CSP)
- SSL/TLS configuration
- Certificate validity
- Rate limiting implementation
- DDoS protection

### 7. Code Security Patterns

**What to check:**

- Use of unsafe functions (eval, exec, system)
- Deserialization of untrusted data
- Insecure randomness
- Race conditions
- Memory safety issues
- Error handling and information disclosure
- Security headers

**Unsafe patterns:**

```python
# Python
eval(), exec(), pickle.loads()

# JavaScript
eval(), Function(), innerHTML

# PHP
eval(), system(), exec()

# Ruby
eval(), system()
```

### 8. Infrastructure & Configuration

**What to check:**

- Default credentials
- Unnecessary services running
- Debug mode in production
- Directory listing enabled
- Backup files accessible
- Admin panels exposed
- Cloud storage permissions
- Container security

### 9. Logging & Monitoring

**What to check:**

- Security event logging
- Audit trails
- Log injection vulnerabilities
- Sensitive data in logs
- Monitoring and alerting systems
- Incident response capabilities

### 10. Compliance & Standards

**Frameworks to reference:**

- OWASP Top 10
- CWE Top 25
- NIST Cybersecurity Framework
- SOC 2 requirements
- GDPR/CCPA (for PII)
- PCI DSS (for payment data)
- HIPAA (for healthcare data)

## Analysis Workflow

### Step 1: Reconnaissance

1. Identify the technology stack
2. Map the attack surface
3. List all entry points (APIs, forms, file uploads)
4. Identify authentication boundaries
5. Document data flows

### Step 2: Static Analysis

1. Scan code for hardcoded secrets
2. Check for vulnerable dependencies
3. Search for unsafe code patterns
4. Review authentication/authorization logic
5. Examine input validation
6. Check cryptographic implementation

### Step 3: Configuration Review

1. Review server/application configuration
2. Check environment variables
3. Examine access controls
4. Review logging configuration
5. Check security headers

### Step 4: Risk Assessment

For each finding:

1. **Severity**: Critical, High, Medium, Low, Informational
2. **Impact**: What could an attacker do?
3. **Likelihood**: How easy is it to exploit?
4. **Affected Assets**: What systems/data are at risk?
5. **Remediation**: How to fix it?

### Step 5: Report Generation

Structure the report:

1. **Executive Summary**: High-level overview of security posture
2. **Methodology**: What was analyzed and how
3. **Findings**: Detailed list of vulnerabilities
4. **Risk Matrix**: Prioritized list by severity
5. **Recommendations**: Actionable remediation steps
6. **Conclusion**: Overall security stance rating

## Output Format

```markdown
# Security Stance Analysis Report

## Executive Summary
[Overall security posture: Strong/Adequate/Weak/Critical]
[Summary of key findings]

## Scope
- **Target**: [System/Application name]
- **Technology Stack**: [Languages, frameworks, infrastructure]
- **Analysis Date**: [Date]

## Findings

### Critical Severity
1. **[Finding Title]**
   - **Category**: [e.g., Authentication, Injection]
   - **Location**: [File path or system component]
   - **Description**: [What was found]
   - **Impact**: [What could happen]
   - **Remediation**: [How to fix]

### High Severity
[Same structure]

### Medium Severity
[Same structure]

### Low Severity
[Same structure]

### Informational
[Same structure]

## Security Strengths
- [What's being done well]

## Risk Summary
| Severity | Count |
|----------|-------|
| Critical | X     |
| High     | X     |
| Medium   | X     |
| Low      | X     |

## Recommendations
1. [Prioritized action items]

## Compliance Gaps
[If applicable]

## Conclusion
[Overall assessment and next steps]
```

## Tools and Commands

### Search for secrets

```bash
# Search for potential secrets in code
grep -r -E "(password|passwd|pwd|api[_-]?key|secret|token).*=.*['\"]" .

# Search git history for secrets
git log -p | grep -E "(password|api[_-]?key|secret)"

# Use dedicated tools
trufflehog git file://. --only-verified
gitleaks detect --source .
```

### Check dependencies

```bash
# Node.js
npm audit
npm audit --production

# Python
pip-audit
safety check

# Ruby
bundle audit

# Go
go list -m all | nancy sleuth
```

### Check for common misconfigurations

```bash
# Find world-writable files
find . -type f -perm -002

# Find files with sensitive extensions
find . -name "*.env" -o -name "*.pem" -o -name "*.key"

# Check for debug mode
grep -r "DEBUG.*=.*true" .
grep -r "development" config/
```

### Network scanning (use with authorization)

```bash
# Port scanning
nmap -sV -A target-host

# SSL/TLS testing
nmap --script ssl-enum-ciphers -p 443 target-host
testssl.sh target-host
```

## Best Practices

1. **Always get authorization** before scanning systems you don't own
2. **Document everything**: Track what was checked and when
3. **Prioritize by risk**: Focus on critical/high severity first
4. **Provide actionable remediation**: Don't just identify problems
5. **Retest after fixes**: Verify remediation was effective
6. **Consider false positives**: Validate findings before reporting
7. **Maintain confidentiality**: Handle security findings responsibly

## Common False Positives

- Test files with mock credentials
- Example/documentation code
- Base64 encoded data mistaken for secrets
- Comments containing the word "password"
- Dependency vulnerabilities in dev-only packages

## Limitations

This skill provides security analysis guidance but:

- Cannot replace professional penetration testing
- May not catch all vulnerabilities
- Requires proper authorization for thorough testing
- Should be combined with automated security tools
- Results depend on the depth of access provided

## Related Resources

- [OWASP Testing Guide](references/owasp-testing.md)
- [CWE Top 25](references/cwe-top25.md)
- [Security Checklist](references/security-checklist.md)

## Example Usage

**User**: "Analyze the security stance of this web application"

**Agent response**:
1. Identify technology stack (Node.js, Express, PostgreSQL)
2. Scan for hardcoded secrets in the codebase
3. Run npm audit to check dependencies
4. Review authentication implementation
5. Check for SQL injection vulnerabilities
6. Examine session management
7. Review CORS and CSP configuration
8. Generate comprehensive security report with findings
