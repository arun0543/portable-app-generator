# Configuration Reference

**Project:** Portable App Generator (PAG)

**Document:** 06_CONFIGURATION_REFERENCE.md

**Version:** 1.0.0

**Status:** Draft

---

# Table of Contents

1. Purpose
2. Configuration Philosophy
3. Configuration Hierarchy
4. Configuration Sources
5. Configuration File
6. Environment Variables
7. Variable Reference
8. Runtime Configuration
9. Validation Rules
10. Default Values
11. Sensitive Configuration
12. Configuration API
13. Best Practices
14. Troubleshooting
15. Future Extensions

---

# 1. Purpose

This document defines every configuration option supported by Portable App Generator.

Configuration controls framework behavior without requiring source code changes.

All configuration is validated before execution.

---

# 2. Configuration Philosophy

The framework follows these principles:

- Configuration over hardcoding
- Immutable runtime configuration
- Fail fast on invalid configuration
- Human-readable format
- Environment-independent
- Backward compatible where possible

---

# 3. Configuration Hierarchy

Configuration values are loaded in the following order
(lowest to highest priority):

Framework Defaults
↓

.env.example
↓

.env
↓

Plugin Defaults
↓

Plugin Configuration
↓

Command-Line Arguments

Higher-priority values override lower-priority values.

---

# 4. Configuration Sources

Supported sources:

- Framework defaults
- `.env`
- Plugin manifest
- Command-line arguments

Future support:

- YAML
- JSON
- TOML
- Remote configuration

---

# 5. Configuration File

Example:

```env
#######################################
# General
#######################################

PAG_VERSION=1.0.0
DEBUG=false
VERBOSE=false

#######################################
# Directories
#######################################

WORKSPACE=$HOME/PortableApps
INSTANCE_ROOT=$WORKSPACE/instances
LOG_DIR=$WORKSPACE/logs
CACHE_DIR=$WORKSPACE/cache
BACKUP_DIR=$WORKSPACE/backups

#######################################
# Desktop
#######################################

INSTALL_DESKTOP_ENTRY=true
REFRESH_ICON_CACHE=true

#######################################
# Logging
#######################################

LOG_LEVEL=INFO
LOG_FILE=generator.log

#######################################
# Backup
#######################################

AUTO_BACKUP=true
BACKUP_RETENTION=10

#######################################
# Validation
#######################################

STRICT_MODE=true
```

---

# 6. Environment Variables

Framework variables:

| Variable | Description |
|----------|-------------|
| PAG_VERSION | Framework version |
| DEBUG | Enable debug logging |
| VERBOSE | Enable verbose output |
| LOG_LEVEL | Logging level |
| INSTANCE_NAME | Current instance |
| PLUGIN_ID | Loaded plugin |

Runtime variables are read-only.

---

# 7. Variable Reference

## Workspace

WORKSPACE

Root directory for all generated data.

Default:

```
$HOME/PortableApps
```

---

## INSTANCE_ROOT

Location where generated applications are stored.

Default

```
$WORKSPACE/instances
```

---

## LOG_DIR

Stores framework logs.

Example

```
~/PortableApps/logs
```

---

## CACHE_DIR

Stores temporary framework cache.

Safe to delete.

---

## BACKUP_DIR

Stores automatic backups.

---

## DEBUG

Values

```
true
false
```

Default

```
false
```

---

## VERBOSE

Enables additional console output.

Default

```
false
```

---

## LOG_LEVEL

Supported values

```
TRACE
DEBUG
INFO
SUCCESS
WARNING
ERROR
FATAL
```

Default

```
INFO
```

---

## AUTO_BACKUP

Automatically create backups before modifying an instance.

Default

```
true
```

---

## BACKUP_RETENTION

Number of backups to retain.

Default

```
10
```

---

## STRICT_MODE

When enabled, validation failures stop execution.

Default

```
true
```

---

# 8. Runtime Configuration

During startup the framework builds an immutable runtime configuration.

Flow

Defaults
↓

.env

↓

Plugin Defaults

↓

CLI Overrides

↓

Validation

↓

Read-only Runtime Configuration

No module may modify configuration after initialization.

---

# 9. Validation Rules

Every configuration value must be validated.

Examples:

Directory exists or can be created.

Boolean values are valid.

Numeric values are within range.

Paths are writable.

Plugin exists.

Invalid configuration terminates execution before any changes are made.

---

# 10. Default Values

Every variable has a documented default.

Missing optional variables use defaults.

Missing required variables produce validation errors.

---

# 11. Sensitive Configuration

Sensitive values must never be written to logs.

Examples:

API keys

Access tokens

Passwords

Private certificates

When logged, sensitive values must be masked.

Example:

```
API_KEY=************
```

---

# 12. Configuration API

Framework modules access configuration through a common interface.

Example:

```bash
config_get "LOG_LEVEL"

config_has "DEBUG"

config_bool "STRICT_MODE"
```

Modules must never read `.env` directly.

Only the Configuration module is responsible for parsing configuration files.

---

# 13. Best Practices

- Use descriptive variable names.
- Keep defaults sensible.
- Validate all inputs.
- Avoid duplicate variables.
- Document every option.
- Prefer feature flags over code changes.
- Keep configuration backward compatible.

---

# 14. Troubleshooting

## Invalid Boolean

Incorrect:

```
DEBUG=yes
```

Correct:

```
DEBUG=true
```

---

## Missing Directory

Problem:

```
LOG_DIR=/invalid/path
```

Solution:

Create the directory or update the configuration.

---

## Unknown Variable

Unknown variables should generate warnings but not fail execution unless strict mode is enabled.

---

# 15. Future Extensions

Planned enhancements:

- YAML configuration
- JSON configuration
- TOML configuration
- Per-plugin configuration files
- User profile configuration
- Configuration migration tool
- Configuration schema validation
- Interactive configuration wizard

---

# Configuration Checklist

Before adding a new configuration variable:

- Clear name
- Default value
- Validation rule
- Documentation updated
- Backward compatible
- Referenced in `.env.example`
- Covered by tests

---

# Summary

The configuration system provides a predictable, validated, and extensible mechanism for controlling framework behavior.

All runtime behavior should be configurable where practical, while maintaining sensible defaults and protecting users from invalid configurations.