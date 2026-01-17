# OWASP Top 10 Web Application Security Risks

Reference guide for the most critical web application security risks.

## A01:2021 – Broken Access Control

**Description**: Restrictions on what authenticated users are allowed to do are often not properly enforced.

**Common Vulnerabilities**:
- Bypassing access control checks by modifying URL, internal state, or HTML
- Elevation of privilege (acting as admin without being logged in)
- Metadata manipulation (JWT token tampering)
- CORS misconfiguration allowing unauthorized access
- Insecure direct object references (IDOR)

**How to Test**:
```bash
# Try accessing resources of other users
GET /api/users/123/profile  # Try different user IDs
GET /admin  # Try accessing admin pages

# Test parameter manipulation
GET /api/account?id=456  # Change account IDs
```

**Prevention**:
- Implement access control checks on every request
- Deny by default
- Use RBAC or ABAC models
- Disable directory listing
- Log and alert on access control failures

## A02:2021 – Cryptographic Failures

**Description**: Failures related to cryptography that often lead to sensitive data exposure.

**Common Vulnerabilities**:
- Transmitting data in clear text (HTTP, FTP, SMTP)
- Using weak or outdated cryptographic algorithms
- Not enforcing encryption
- Default crypto keys in use
- Missing certificate validation

**How to Test**:
```bash
# Check SSL/TLS configuration
nmap --script ssl-enum-ciphers -p 443 target.com
testssl.sh target.com

# Look for weak algorithms in code
grep -r "DES\|MD5\|SHA1" .
```

**Prevention**:
- Encrypt all sensitive data at rest and in transit
- Use strong algorithms (AES-256, RSA 2048+)
- Use TLS 1.2+ with strong ciphers
- Proper key management
- Disable caching for sensitive data

## A03:2021 – Injection

**Description**: User-supplied data is not validated, filtered, or sanitized.

**Types**:
- SQL Injection
- NoSQL Injection
- OS Command Injection
- LDAP Injection
- XPath Injection

**How to Test**:
```bash
# SQL Injection
' OR '1'='1
'; DROP TABLE users--
1' UNION SELECT NULL--

# Command Injection
; ls -la
| cat /etc/passwd
`whoami`

# NoSQL Injection (MongoDB)
{"$gt":""}
{"$ne":null}
```

**Prevention**:
- Use parameterized queries (prepared statements)
- Use ORM frameworks properly
- Validate and sanitize all input
- Use allowlists for input validation
- Escape special characters
- Use least privilege for database accounts

## A04:2021 – Insecure Design

**Description**: Missing or ineffective control design.

**Common Issues**:
- Lack of threat modeling
- Insecure design patterns
- Missing security controls
- Business logic flaws

**Prevention**:
- Threat modeling during design phase
- Secure design patterns and reference architectures
- Security requirements in user stories
- Validate all assumptions
- Separation of concerns

## A05:2021 – Security Misconfiguration

**Description**: Missing appropriate security hardening or improperly configured permissions.

**Common Vulnerabilities**:
- Default accounts enabled
- Unnecessary features enabled
- Directory listing enabled
- Detailed error messages
- Security headers missing
- Software out of date

**How to Test**:
```bash
# Check for default credentials
admin:admin
root:password
admin:password

# Check security headers
curl -I https://target.com
# Look for: X-Frame-Options, X-Content-Type-Options,
# Content-Security-Policy, Strict-Transport-Security

# Check for exposed files
/.git
/.env
/backup
/admin
```

**Prevention**:
- Minimal platform installation
- Review and update configurations
- Automated security configuration scanning
- Proper segmentation between environments
- Security directives sent to clients

## A06:2021 – Vulnerable and Outdated Components

**Description**: Using components with known vulnerabilities.

**Common Issues**:
- Unknown component versions in use
- Outdated or unsupported software
- Not scanning for vulnerabilities
- Not patching or upgrading in time

**How to Test**:
```bash
# Node.js
npm audit
npm outdated

# Python
pip list --outdated
pip-audit

# Ruby
bundle audit

# Check CVE databases
https://cve.mitre.org
https://nvd.nist.gov
```

**Prevention**:
- Maintain inventory of components
- Continuously monitor for vulnerabilities
- Only obtain components from official sources
- Remove unused dependencies
- Automated patching process

## A07:2021 – Identification and Authentication Failures

**Description**: Incorrectly implemented authentication and session management.

**Common Vulnerabilities**:
- Permits brute force attacks
- Permits default or weak passwords
- Weak credential recovery
- Passwords stored in plain text or weakly hashed
- Missing or ineffective MFA
- Session IDs exposed in URL
- Session IDs not invalidated after logout

**How to Test**:
```bash
# Test for weak passwords
password
123456
admin

# Check session management
# Look for session tokens in URLs
# Test session fixation
# Test session timeout
```

**Prevention**:
- Implement MFA
- Do not ship with default credentials
- Weak password checks
- Aligned with NIST 800-63b guidelines
- Limit or delay failed login attempts
- Generate new session ID after login
- Secure session ID generation

## A08:2021 – Software and Data Integrity Failures

**Description**: Code and infrastructure that do not protect against integrity violations.

**Common Vulnerabilities**:
- Unsigned or unverified updates
- Insecure CI/CD pipelines
- Untrusted deserialization
- Dependency confusion attacks

**How to Test**:
```bash
# Check for unsigned packages
npm config get ignore-scripts

# Look for deserialization
grep -r "pickle.loads\|unserialize\|yaml.load" .

# Check integrity of dependencies
npm audit signatures
```

**Prevention**:
- Digital signatures for updates
- Verify components from trusted repos
- CI/CD pipeline security
- Do not deserialize untrusted data
- Integrity checks on data

## A09:2021 – Security Logging and Monitoring Failures

**Description**: Insufficient logging, detection, monitoring, and active response.

**Common Issues**:
- Login failures not logged
- Warnings and errors generate unclear logs
- Logs only stored locally
- No alerting on suspicious activity
- No incident response plan

**How to Test**:
- Review logging configuration
- Check log retention policies
- Test alerting mechanisms
- Review incident response procedures

**Prevention**:
- Log all authentication and access control failures
- Ensure logs can be centrally consumed
- Establish effective monitoring and alerting
- Adopt incident response and recovery plan
- Penetration testing and DAST scans

## A10:2021 – Server-Side Request Forgery (SSRF)

**Description**: Occurs when a web application fetches a remote resource without validating the user-supplied URL.

**Common Vulnerabilities**:
- Fetching URLs provided by users
- No validation of destination
- Internal network scanning via SSRF
- Accessing cloud metadata endpoints

**How to Test**:
```bash
# Try accessing internal resources
http://localhost
http://127.0.0.1
http://169.254.169.254/latest/meta-data/  # AWS metadata

# Try file:// protocol
file:///etc/passwd

# DNS rebinding attacks
```

**Prevention**:
- Sanitize and validate all client-supplied input
- Enforce URL schema, port, and destination with allowlist
- Disable HTTP redirections
- Do not send raw responses to clients
- Network layer: segment remote resource access

## Additional Resources

- Full OWASP Top 10 documentation: https://owasp.org/Top10/
- OWASP Testing Guide: https://owasp.org/www-project-web-security-testing-guide/
- OWASP Cheat Sheet Series: https://cheatsheetseries.owasp.org/
