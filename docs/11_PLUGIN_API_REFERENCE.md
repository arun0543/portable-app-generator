# Plugin API Reference

**Project:** Portable App Generator (PAG)

**Document:** 11_PLUGIN_API_REFERENCE.md

**Version:** 1.0.0

**Status:** Draft

---

# Table of Contents

1. Purpose
2. API Philosophy
3. Plugin Loading
4. Plugin Lifecycle
5. Required Functions
6. Optional Functions
7. Framework Services
8. Context Object
9. Return Codes
10. Error Contract
11. Logging API
12. Metadata API
13. Version Compatibility
14. Plugin Manifest
15. Security Contract
16. Testing Requirements
17. Future Extensions

---

# 1. Purpose

This document defines the official Plugin API.

Every plugin must comply with this API to be compatible with Portable App Generator.

The API is stable and versioned.

---

# 2. API Philosophy

The Plugin API follows these principles:

- Stable
- Minimal
- Versioned
- Backward Compatible
- Framework Controlled
- Plugin Isolated

Plugins interact with the framework only through documented APIs.

---

# 3. Plugin Loading

Plugin discovery:

```
plugins/

antigravity/

cursor/

vscode/

sample/
```

Each plugin must contain:

```
plugin.sh
manifest.json
README.md
```

Framework workflow:

```
Locate Plugin

↓

Read Manifest

↓

Validate API Version

↓

Load plugin.sh

↓

Validate Functions

↓

Initialize Plugin
```

---

# 4. Plugin Lifecycle

Framework sequence:

```
load()

↓

initialize()

↓

detect()

↓

validate()

↓

clone()

↓

configure()

↓

generate_launcher()

↓

generate_desktop()

↓

verify()

↓

shutdown()
```

---

# 5. Required Functions

Every plugin **must** implement:

```bash
plugin_name()
```

Returns:

```
Human readable plugin name
```

---

```bash
plugin_id()
```

Returns:

```
Unique plugin identifier
```

---

```bash
plugin_version()
```

Returns:

```
Semantic Version
```

---

```bash
plugin_api_version()
```

Returns:

```
Framework API Version
```

---

```bash
detect()
```

Purpose

Determine whether the plugin supports the selected application.

Return

0 = supported

1 = unsupported

---

```bash
validate()
```

Checks

Source application

Permissions

Dependencies

Configuration

---

```bash
clone()
```

Copies application into instance.

---

```bash
configure()
```

Creates runtime environment.

---

```bash
generate_launcher()
```

Creates launch.sh

---

```bash
generate_desktop()
```

Creates desktop entry.

---

```bash
verify()
```

Confirms successful installation.

---

```bash
remove()
```

Removes plugin-managed resources.

---

# 6. Optional Functions

Plugins may implement:

```bash
initialize()

shutdown()

backup()

restore()

upgrade()

downgrade()

health_check()

pre_create()

post_create()

pre_remove()

post_remove()
```

Framework detects these automatically.

---

# 7. Framework Services

Plugins must use framework services.

Available modules:

```
config

logger

filesystem

launcher

desktop

validator

rollback

backup

metadata

instance
```

Plugins should never duplicate framework functionality.

---

# 8. Context Object

The framework exports the following read-only variables:

```bash
PAG_VERSION

PLUGIN_ID

INSTANCE_NAME

INSTANCE_ID

INSTANCE_PATH

APP_PATH

PROFILE_PATH

CONFIG_PATH

CACHE_PATH

DATA_PATH

STATE_PATH

TMP_PATH

LOG_PATH

METADATA_PATH
```

Plugins must treat these variables as immutable.

---

# 9. Return Codes

Standard return values:

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | Validation Failed |
| 2 | Unsupported |
| 3 | Runtime Error |
| 4 | Verification Failed |
| 10 | Internal Plugin Error |

Framework owns exit handling.

Plugins must never call:

```
exit
```

---

# 10. Error Contract

Plugins report errors using:

```bash
log_error

return <code>
```

Every error should include:

- Error message
- Cause
- Suggested resolution

---

# 11. Logging API

Allowed:

```bash
log_trace

log_debug

log_info

log_success

log_warn

log_error

log_fatal
```

Not allowed:

```bash
echo

printf
```

---

# 12. Metadata API

Framework metadata:

```
instance.json
```

Plugins may request:

```bash
metadata_get

metadata_set

metadata_has
```

Plugins must not edit metadata files directly.

---

# 13. Version Compatibility

Plugin manifest defines:

```
Framework API

Minimum Version

Maximum Version
```

Example

```json
{
    "api":"1.0",
    "framework":"1.0.0"
}
```

Framework rejects incompatible plugins.

---

# 14. Plugin Manifest

Example

```json
{
    "id":"antigravity",

    "name":"Google Antigravity",

    "version":"1.0.0",

    "api":"1.0",

    "author":"Portable App Generator",

    "license":"MIT",

    "minimumFramework":"1.0.0"
}
```

Manifest contains metadata only.

No executable logic.

---

# 15. Security Contract

Plugins shall:

- Quote all paths
- Avoid eval
- Avoid arbitrary command execution
- Restrict writes to assigned directories
- Validate user input
- Use framework APIs

Plugins shall not:

- Modify framework files
- Modify other plugins
- Modify unrelated instances

---

# 16. Testing Requirements

Each plugin must include:

```
tests/

detect_test.sh

clone_test.sh

configure_test.sh

verify_test.sh

remove_test.sh
```

Framework CI executes all tests before release.

---

# 17. Future Extensions

Reserved API functions:

```bash
snapshot()

repair()

migrate()

diagnostics()

telemetry()

remote_sync()
```

Reserved for API v2.

---

# API Stability Policy

- Major version changes may introduce breaking changes.
- Minor versions add optional capabilities.
- Patch versions fix defects without changing behavior.

Plugins should declare supported API versions.

---

# Plugin Validation Checklist

Before a plugin is accepted:

✓ Manifest valid

✓ Required API implemented

✓ Optional hooks validated

✓ Tests passing

✓ Documentation complete

✓ ShellCheck clean

✓ Framework compatibility verified

✓ Security review complete

---

# Summary

The Plugin API defines the formal contract between the Portable App Generator core and all plugins.

By enforcing a stable, versioned interface, the framework can evolve independently while maintaining compatibility with existing plugins.