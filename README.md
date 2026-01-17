# Security Stance Analyzer Agent Skill

A comprehensive agentic skill for analyzing the security posture of systems, codebases, and infrastructure.

## What It Does

This skill enables AI agents to perform thorough security assessments covering:

- **Authentication & Authorization**: Session management, access controls, RBAC
- **Secrets Management**: Hardcoded credentials, API keys, environment variables
- **Input Validation**: SQL injection, XSS, command injection, path traversal
- **Data Protection**: Encryption at rest/in transit, sensitive data exposure
- **Dependency Security**: Vulnerable packages, outdated libraries
- **Network Security**: CORS, CSP, SSL/TLS, security headers
- **Infrastructure**: Misconfigurations, default credentials, exposed services
- **Logging & Monitoring**: Security event logging, audit trails
- **Compliance**: OWASP Top 10, CWE Top 25, GDPR, PCI DSS

## Installation

### Quick Install (Recommended)

```bash
# Clone the repository
git clone https://github.com/gurdiga/security-stance-analyzer.git
cd security-stance-analyzer

# Install using Make
make install
```

This will copy all necessary files to `~/.config/claude/skills/security-stance-analyzer`.

### Manual Installation

#### For Claude Code (CLI)

```bash
# Copy the skill to your skills directory
cp -r security-stance-analyzer ~/.config/claude/skills/

# Or symlink it for development
ln -s /path/to/security-stance-analyzer ~/.config/claude/skills/
```

#### For VS Code with GitHub Copilot

```bash
# Copy to VS Code skills directory
cp -r security-stance-analyzer ~/.vscode/agent-skills/
```

#### For Cursor

```bash
# Copy to Cursor skills directory
cp -r security-stance-analyzer ~/.cursor/agent-skills/
```

### Uninstall

```bash
make uninstall
```

## Usage

Once installed, the skill is automatically discovered by compatible agents. Activate it by requesting security-related tasks:

### Example Prompts

```
"Analyze the security stance of this application"

"Perform a security audit on the codebase"

"Check for hardcoded secrets and vulnerabilities"

"Review this code for OWASP Top 10 vulnerabilities"

"Assess the authentication implementation"

"Scan for dependency vulnerabilities"
```

## What Gets Analyzed

### Code Analysis
- Hardcoded secrets and credentials
- Unsafe code patterns (eval, exec, deserialization)
- SQL injection vulnerabilities
- XSS vulnerabilities
- Command injection risks
- Path traversal issues

### Configuration Review
- Security headers (CSP, HSTS, X-Frame-Options)
- CORS configuration
- SSL/TLS settings
- Environment variables
- Access controls

### Dependency Scanning
- Known CVEs in packages
- Outdated dependencies
- License compliance

### Infrastructure
- Exposed admin panels
- Default credentials
- Debug mode in production
- File permissions

## Included Tools

### Scripts

#### `scripts/scan-secrets.sh`
Scans for hardcoded secrets in code.

```bash
cd your-project
../security-stance-analyzer/scripts/scan-secrets.sh .
```

Detects:
- API keys
- AWS credentials
- Passwords
- Private keys
- JWT tokens
- Database connection strings
- OAuth tokens
- Slack/GitHub tokens

#### `scripts/check-dependencies.sh`
Scans for vulnerable dependencies.

```bash
cd your-project
../security-stance-analyzer/scripts/check-dependencies.sh
```

Supports:
- Node.js (npm audit)
- Python (pip-audit, safety)
- Ruby (bundle audit)
- Go (manual check)
- PHP (composer audit)
- Rust (cargo audit)
- .NET (dotnet list package --vulnerable)

### Reference Materials

#### `references/security-checklist.md`
120-point comprehensive security checklist covering all major security categories.

#### `references/owasp-top10.md`
Complete reference guide for OWASP Top 10 web application security risks with testing methods and prevention strategies.

## Output Format

The skill generates structured security reports including:

1. **Executive Summary**: High-level security posture assessment
2. **Findings by Severity**: Critical, High, Medium, Low, Informational
3. **Risk Summary**: Quantified risk matrix
4. **Recommendations**: Prioritized remediation steps
5. **Compliance Gaps**: Standards compliance assessment

## Requirements

### Optional Dependencies

For enhanced functionality, consider installing:

```bash
# Secrets scanning
npm install -g trufflehog
go install github.com/gitleaks/gitleaks/v8@latest

# Dependency scanning
pip install pip-audit safety

# Network scanning (requires authorization)
apt install nmap
```

## Best Practices

1. **Always get authorization** before scanning systems you don't own
2. **Run in safe environments**: Test in dev/staging first
3. **Review findings**: Validate before acting on results
4. **Prioritize remediation**: Focus on Critical/High severity first
5. **Automate**: Integrate into CI/CD pipelines
6. **Retest**: Verify fixes are effective

## Limitations

- Not a replacement for professional penetration testing
- Requires proper authorization for thorough testing
- Some checks require specific tools to be installed
- May produce false positives (always validate)
- Results quality depends on access level

## Compliance Coverage

- **OWASP Top 10**: Full coverage with testing guidance
- **CWE Top 25**: Most dangerous software weaknesses
- **NIST Cybersecurity Framework**: Control mapping
- **SOC 2**: Trust service criteria alignment
- **GDPR/CCPA**: PII handling requirements
- **PCI DSS**: Payment data protection
- **HIPAA**: Healthcare data security

## Contributing

To extend this skill:

1. Add new patterns to `scripts/scan-secrets.sh`
2. Expand checklists in `references/security-checklist.md`
3. Update OWASP guidance in `references/owasp-top10.md`
4. Create new scripts for specific security tests

## License

Apache-2.0

## Resources

- [OWASP](https://owasp.org)
- [CWE](https://cwe.mitre.org)
- [NIST](https://www.nist.gov/cyberframework)
- [Agent Skills Specification](https://agentskills.io/specification)
