# Security Policy

## Supported Versions

Currently, we provide security updates for the following versions of PAG:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

If you discover a security vulnerability within PAG, please do not disclose it publicly.

Instead, please report it via email to security@example.com or use GitHub's private vulnerability reporting feature. 
You can expect a response within 48 hours.

## Disclosure Policy

We will investigate the issue and determine if a patch is required. Once the patch is available, we will notify you and credit you for the discovery (if desired). A public disclosure will only happen after the patch has been released.

## Security Best Practices
- Always verify GPG signatures when downloading external plugins.
- Ensure repositories are configured to use HTTPS.
- Use lockfiles (`pag.lock`) to prevent dependency substitution attacks.
