# Logging Framework Specification

**Project:** Portable App Generator (PAG)

**Document:** 13_LOGGING_FRAMEWORK.md

**Version:** 1.0.0

**Status:** Draft

---

# Table of Contents

1. Purpose
2. Design Goals
3. Logging Architecture
4. Log Levels
5. Log Destinations
6. Log Format
7. Log Categories
8. Framework Logging API
9. Plugin Logging
10. Log Rotation
11. Correlation IDs
12. Audit Logging
13. Performance Logging
14. Debug & Trace Modes
15. Error Logging
16. Security
17. Configuration
18. Future Enhancements

---

# 1. Purpose

The Logging Framework provides a unified mechanism for recording framework activity.

Logging enables:

- Diagnostics
- Troubleshooting
- Auditing
- Monitoring
- Performance analysis
- Supportability

Every framework component and plugin shall use the logging framework.

---

# 2. Design Goals

The logging system shall be:

- Consistent
- Structured
- Lightweight
- Thread-safe (future)
- Human-readable
- Machine-readable
- Configurable

---

# 3. Logging Architecture

```
Framework

↓

Logger API

↓

Formatter

↓

Destination

↓

Console
File
JSON
```

Modules never write directly to log files.

---

# 4. Log Levels

| Level | Purpose |
|---------|----------|
| TRACE | Detailed execution flow |
| DEBUG | Developer diagnostics |
| INFO | Normal operations |
| SUCCESS | Successful completion |
| WARN | Recoverable issue |
| ERROR | Operation failed |
| FATAL | Framework cannot continue |

Filtering shall be configurable.

---

# 5. Log Destinations

Supported outputs:

Console

```
stdout
stderr
```

Files

```
logs/

framework.log

instance.log

plugin.log
```

Future

- Syslog
- journald
- Remote logging
- OpenTelemetry

---

# 6. Log Format

Human-readable format

```
2026-08-12T10:22:15Z

INFO

Instance created

instance=work

plugin=antigravity
```

Optional JSON

```json
{
  "timestamp":"2026-08-12T10:22:15Z",
  "level":"INFO",
  "component":"instance",
  "message":"Instance created",
  "instance":"work",
  "plugin":"antigravity"
}
```

---

# 7. Log Categories

Categories include:

- Framework
- CLI
- Plugin
- Instance
- Filesystem
- Launcher
- Desktop
- Configuration
- Runtime
- Verification
- Backup
- Restore

Categories help filter logs.

---

# 8. Framework Logging API

Available functions:

```bash
log_trace()

log_debug()

log_info()

log_success()

log_warn()

log_error()

log_fatal()
```

All modules shall use these functions.

Direct use of:

```bash
echo
printf
```

for operational logging is prohibited.

---

# 9. Plugin Logging

Plugins use the same logging API.

Example

```bash
log_info "Creating runtime directories"

log_warn "Optional dependency missing"

log_error "Launcher generation failed"
```

Plugins must not create independent logging systems.

---

# 10. Log Rotation

Framework supports rotation based on:

- File size
- Number of archived logs
- Age

Default policy:

```
Maximum Size

10 MB

Retain

10 files
```

Compression may be enabled.

---

# 11. Correlation IDs

Every framework operation receives a unique identifier.

Example

```
REQ-20260812-000124
```

All related log entries include this identifier.

Example

```
[REQ-20260812-000124]

INFO

Creating Instance
```

Correlation IDs simplify troubleshooting.

---

# 12. Audit Logging

Audit logs record significant events.

Examples:

- Instance created
- Instance removed
- Backup restored
- Plugin installed
- Plugin updated
- Configuration changed

Audit logs should be append-only.

---

# 13. Performance Logging

Optional metrics include:

- Startup time
- Template rendering time
- Plugin execution time
- Validation duration
- Backup duration
- Restore duration

Example

```
Operation

Create Instance

Duration

842 ms
```

---

# 14. Debug & Trace Modes

Debug mode includes:

- Additional diagnostics
- Environment information
- Variable values (excluding secrets)

Trace mode includes:

- Function entry/exit
- Execution path
- Timing information

Trace logging should be disabled by default.

---

# 15. Error Logging

Errors shall include:

- Timestamp
- Component
- Error code
- Message
- Context
- Suggested resolution

Example

```
ERROR

Launcher generation failed

Component

Launcher

Cause

Missing template

Resolution

Verify plugin templates.
```

---

# 16. Security

The logging system shall:

- Never log passwords
- Never log API tokens
- Never log encryption keys
- Mask sensitive values
- Sanitize user input before logging

Example

```
TOKEN=********
```

---

# 17. Configuration

Supported settings:

```ini
LOG_LEVEL=INFO

LOG_FORMAT=text

LOG_DIRECTORY=logs

LOG_ROTATION_SIZE=10MB

LOG_RETENTION=10

ENABLE_JSON_LOGS=false

ENABLE_TRACE=false
```

Runtime overrides may be provided through CLI options.

---

# 18. Future Enhancements

Planned features:

- Structured event streams
- OpenTelemetry support
- Distributed tracing
- Centralized log aggregation
- Metrics dashboard
- Real-time log viewer
- Plugin-specific log filtering
- Log export

---

# Logging Rules

- Every operation must produce at least one INFO or higher log entry.
- All errors shall include context and resolution guidance.
- Sensitive information shall always be masked.
- Log timestamps shall use ISO 8601 in UTC.
- Log output shall remain stable across framework versions.

---

# Logging Checklist

✓ Log level applied

✓ Timestamp present

✓ Component identified

✓ Correlation ID included

✓ Sensitive data masked

✓ Output destination available

✓ Rotation policy enforced

✓ Format validated

---

# Summary

The Logging Framework provides a unified, configurable, and secure logging system for the Portable App Generator. By standardizing log levels, formats, APIs, and destinations, it ensures consistent diagnostics, auditing, and operational visibility across the framework and all plugins.