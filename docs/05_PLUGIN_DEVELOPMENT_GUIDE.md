# Plugin Development Guide

**Project:** Portable App Generator (PAG)

**Document:** 05_PLUGIN_DEVELOPMENT_GUIDE.md

**Version:** 1.0.0

**Status:** Draft

---

# Table of Contents

1. Purpose
2. Plugin Architecture
3. Plugin Lifecycle
4. Plugin Directory Structure
5. Plugin Manifest
6. Required Interface
7. Optional Interface
8. Plugin Context
9. Environment Variables
10. Validation Rules
11. Error Handling
12. Logging
13. Best Practices
14. Security Requirements
15. Plugin Testing
16. Version Compatibility
17. Example Plugin
18. Plugin Checklist

---

# 1. Purpose

Plugins extend Portable App Generator to support different portable applications.

The framework itself remains application-agnostic.

Each plugin encapsulates all application-specific knowledge.

Examples:

- Antigravity
- Cursor
- Claude Desktop
- VS Code
- Chromium
- Electron Applications

---

# 2. Plugin Architecture

Framework

↓

Plugin Loader

↓

Plugin

↓

Target Application

The framework never directly interacts with application internals.

---

# 3. Plugin Lifecycle

Plugin Discovery

↓

Load Plugin

↓

Validate Plugin

↓

Detect Application

↓

Clone Application

↓

Configure Runtime

↓

Generate Launcher

↓

Generate Desktop Entry

↓

Verify Installation

↓

Complete

---

# 4. Plugin Directory Structure

plugins/

```
antigravity/
│
├── plugin.sh
├── manifest.json
├── launcher.template
├── desktop.template
├── icon.png
├── README.md
└── tests/
```

Every plugin follows the same structure.

---

# 5. Plugin Manifest

Example:

```json
{
    "name": "Antigravity",
    "id": "antigravity",
    "version": "1.0.0",
    "author": "Portable App Generator",
    "minimumFramework": "1.0.0",
    "description": "Support for Google Antigravity."
}
```

The manifest provides metadata only.

---

# 6. Required Interface

Every plugin **must** implement the following public functions:

```bash
plugin_name()

plugin_version()

plugin_description()

detect()

validate()

clone()

configure()

generate_launcher()

generate_desktop()

verify()

update()

remove()
```

Missing required functions result in plugin rejection.

---

# 7. Optional Interface

Plugins may implement:

```bash
backup()

restore()

pre_install()

post_install()

pre_remove()

post_remove()

health_check()

upgrade()

downgrade()
```

The framework detects and calls these hooks if available.

---

# 8. Plugin Context

The framework provides a read-only execution context.

Example:

```bash
PLUGIN_ID
INSTANCE_NAME
SOURCE_PATH
INSTANCE_PATH
PROFILE_PATH
CACHE_PATH
CONFIG_PATH
DATA_PATH
LOG_PATH
TMP_PATH
```

Plugins must not modify these variables.

---

# 9. Environment Variables

Available during execution:

```bash
PAG_VERSION
PLUGIN_VERSION
DEBUG
VERBOSE
LOG_LEVEL
```

Additional variables may be added in future framework versions.

---

# 10. Validation Rules

Before execution, the plugin must validate:

- Source application exists
- Required files are present
- Executable permissions are correct
- Configuration is valid
- Destination is writable

Validation must fail early with meaningful error messages.

---

# 11. Error Handling

Plugins must never terminate the framework directly.

Instead, return standard exit codes:

0 = Success

1 = Validation Error

2 = Runtime Error

3 = Fatal Error

The framework handles recovery and reporting.

---

# 12. Logging

Plugins must use framework logging functions.

Allowed:

```bash
log_info
log_warn
log_error
log_debug
```

Not allowed:

```bash
echo
printf
```

Direct console output is prohibited except during debugging.

---

# 13. Best Practices

- Keep plugin logic self-contained.
- Avoid duplicating framework functionality.
- Validate input before processing.
- Use helper modules from `lib/`.
- Keep functions small and focused.
- Do not hardcode user-specific paths.
- Prefer templates over generated strings.

---

# 14. Security Requirements

Plugins must:

- Quote all paths.
- Validate user input.
- Avoid `eval`.
- Avoid executing downloaded code.
- Restrict file operations to assigned directories.
- Never modify system files.

Security violations are considered critical defects.

---

# 15. Plugin Testing

Every plugin must provide tests.

Structure:

```
plugins/
└── antigravity/
    └── tests/
        ├── detect_test.sh
        ├── clone_test.sh
        ├── verify_test.sh
        └── cleanup_test.sh
```

Tests should cover:

- Detection
- Validation
- Generation
- Launch
- Removal

---

# 16. Version Compatibility

Each plugin declares:

Minimum Framework Version

Maximum Supported Version (optional)

Unsupported plugins are rejected during loading.

---

# 17. Example Plugin

```
plugins/
└── sample/
    ├── plugin.sh
    ├── manifest.json
    ├── README.md
    ├── launcher.template
    ├── desktop.template
    ├── icon.png
    └── tests/
```

`plugin.sh`

```bash
plugin_name() {
    echo "Sample Plugin"
}

plugin_version() {
    echo "1.0.0"
}

detect() {
    return 0
}

validate() {
    return 0
}

clone() {
    return 0
}

configure() {
    return 0
}

generate_launcher() {
    return 0
}

generate_desktop() {
    return 0
}

verify() {
    return 0
}

update() {
    return 0
}

remove() {
    return 0
}
```

This example serves as the reference implementation for all future plugins.

---

# 18. Plugin Checklist

Before releasing a plugin:

- Manifest complete
- Required functions implemented
- Validation passes
- Tests pass
- Documentation included
- Security review completed
- ShellCheck clean
- shfmt applied
- Compatible with current framework version

Only plugins meeting this checklist should be accepted into the official repository.

---

# Summary

The plugin system is the primary extension mechanism for Portable App Generator.

The framework remains generic, while plugins encapsulate all application-specific behavior. This separation ensures maintainability, scalability, and the ability to support new portable applications without modifying the core framework.