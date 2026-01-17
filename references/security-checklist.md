# Security Analysis Checklist

Use this checklist to ensure comprehensive coverage during security stance analysis.

## Authentication & Access Control

- [ ] Strong password policy enforced
- [ ] Multi-factor authentication available
- [ ] Session timeout configured
- [ ] Session tokens properly randomized
- [ ] Secure session storage
- [ ] Account lockout after failed attempts
- [ ] Password reset mechanism secure
- [ ] No default credentials in use
- [ ] Authorization checks on all endpoints
- [ ] Privilege escalation prevented
- [ ] Role-based access control implemented
- [ ] Horizontal authorization checked
- [ ] Vertical authorization checked

## Input Validation & Injection

- [ ] All user input validated
- [ ] Parameterized queries used (SQL)
- [ ] ORM used correctly
- [ ] No command injection possible
- [ ] No template injection possible
- [ ] No XSS vulnerabilities
- [ ] File upload validation present
- [ ] Path traversal prevented
- [ ] XML external entity (XXE) disabled
- [ ] LDAP injection prevented
- [ ] No eval() or exec() with user input

## Cryptography & Data Protection

- [ ] Sensitive data encrypted at rest
- [ ] TLS/SSL enforced for data in transit
- [ ] Strong cipher suites configured
- [ ] Certificates valid and trusted
- [ ] No weak hashing algorithms (MD5, SHA1)
- [ ] Passwords properly hashed (bcrypt, Argon2)
- [ ] Random salts used
- [ ] Secure random number generation
- [ ] Cryptographic keys rotated
- [ ] No hardcoded encryption keys

## Secrets Management

- [ ] No hardcoded passwords
- [ ] No API keys in source code
- [ ] No secrets in version control
- [ ] Environment variables used properly
- [ ] Secrets manager/vault in use
- [ ] No secrets in logs
- [ ] No secrets in error messages
- [ ] No secrets in URLs
- [ ] Configuration files secured

## Dependencies & Libraries

- [ ] All dependencies up to date
- [ ] No known vulnerabilities (audit)
- [ ] Dependency sources verified
- [ ] Lock files committed
- [ ] License compliance checked
- [ ] Minimal dependencies used
- [ ] Dev dependencies separated

## Error Handling & Logging

- [ ] Generic error messages to users
- [ ] Detailed errors logged securely
- [ ] No stack traces exposed
- [ ] No system info leaked
- [ ] Security events logged
- [ ] Logs protected from tampering
- [ ] No sensitive data in logs
- [ ] Centralized logging in place
- [ ] Log retention policy defined

## Network Security

- [ ] Unnecessary ports closed
- [ ] Firewall rules configured
- [ ] Rate limiting implemented
- [ ] DDoS protection in place
- [ ] CORS properly configured
- [ ] Content Security Policy set
- [ ] Security headers present
- [ ] HTTPS enforced
- [ ] HSTS header set

## Infrastructure & Configuration

- [ ] Debug mode disabled in production
- [ ] Directory listing disabled
- [ ] Admin panels protected
- [ ] Unnecessary services disabled
- [ ] File permissions correct
- [ ] Database access restricted
- [ ] Cloud storage properly secured
- [ ] Backup files not web-accessible
- [ ] Server banners minimized

## Code Security

- [ ] No unsafe deserialization
- [ ] No race conditions
- [ ] Integer overflow handled
- [ ] Buffer overflow prevented
- [ ] Memory safety maintained
- [ ] Secure file operations
- [ ] No insecure redirects
- [ ] CSRF protection implemented
- [ ] Clickjacking prevention

## API Security

- [ ] Authentication required
- [ ] Rate limiting per endpoint
- [ ] Input validation on all params
- [ ] Output encoding applied
- [ ] Versioning strategy in place
- [ ] CORS headers appropriate
- [ ] No excessive data exposure
- [ ] Mass assignment prevented
- [ ] API keys rotatable

## Monitoring & Response

- [ ] Security monitoring active
- [ ] Intrusion detection in place
- [ ] Alerting configured
- [ ] Incident response plan exists
- [ ] Regular security reviews scheduled
- [ ] Vulnerability disclosure policy
- [ ] Backup and recovery tested

## Compliance (if applicable)

- [ ] GDPR compliance (EU users)
- [ ] CCPA compliance (CA users)
- [ ] PCI DSS (payment data)
- [ ] HIPAA (healthcare data)
- [ ] SOC 2 controls
- [ ] Data retention policies
- [ ] Privacy policy current

## Testing

- [ ] Security tests in CI/CD
- [ ] Static analysis tool used
- [ ] Dependency scanning automated
- [ ] Secrets scanning automated
- [ ] Regular penetration tests
- [ ] Bug bounty program considered

## Score

**Total items**: 120
**Items checked**: ___
**Coverage**: ___%

**Risk Level**:
- 90-100%: Low Risk
- 75-89%: Medium Risk
- 50-74%: High Risk
- Below 50%: Critical Risk
