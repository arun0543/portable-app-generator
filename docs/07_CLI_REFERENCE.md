# CLI Reference

**Project:** Portable App Generator (PAG)

**Document:** 07_CLI_REFERENCE.md

**Version:** 1.0.0

**Status:** Draft

---

# Table of Contents

1. Purpose
2. CLI Philosophy
3. Command Syntax
4. Global Options
5. Commands
6. Output Formats
7. Exit Codes
8. Interactive Mode
9. Non-Interactive Mode
10. Examples
11. Error Messages
12. Future Commands

---

# 1. Purpose

The Portable App Generator Command Line Interface (CLI) is the primary user interface to the framework.

The CLI shall be:

- Stable
- Scriptable
- Human-friendly
- Automation-friendly
- Backward compatible

---

# 2. CLI Philosophy

The CLI follows these principles:

- One command = one responsibility
- Consistent option names
- Predictable behavior
- Safe by default
- Machine-readable output
- Clear error messages

---

# 3. Command Syntax

General syntax:

```bash
generator.sh <command> [options]
```

Examples:

```bash
generator.sh create
generator.sh list
generator.sh verify
generator.sh remove
```

---

# 4. Global Options

These options are available for all commands.

| Option | Description |
|----------|-------------|
| `--help` | Show help |
| `--version` | Show framework version |
| `--verbose` | Enable verbose logging |
| `--debug` | Enable debug mode |
| `--quiet` | Suppress normal output |
| `--yes` | Automatically answer yes |
| `--dry-run` | Simulate without changes |
| `--json` | Output JSON |
| `--config <file>` | Use custom configuration |
| `--log-level <level>` | Override log level |

---

# 5. Commands

## create

Creates a new isolated application instance.

Syntax:

```bash
generator.sh create \
    --plugin antigravity \
    --name work
```

Options:

| Option | Required | Description |
|---------|----------|-------------|
| --plugin | Yes | Plugin identifier |
| --name | Yes | Instance name |
| --source | Optional | Source directory |
| --icon | Optional | Custom icon |
| --force | Optional | Overwrite existing |

---

## list

Lists all generated instances.

```bash
generator.sh list
```

Example Output

```
NAME              PLUGIN          STATUS

work              antigravity    Running
testing           cursor         Installed
demo              vscode         Installed
```

---

## info

Displays detailed instance information.

```bash
generator.sh info work
```

Returns

- Plugin
- Version
- Installation Path
- Profile Path
- Launcher
- Desktop Entry
- Status

---

## verify

Validates an installation.

```bash
generator.sh verify work
```

Checks

- Files
- Launcher
- Desktop Entry
- Permissions
- Runtime Directories

---

## update

Updates an existing instance.

```bash
generator.sh update work
```

---

## remove

Removes an instance.

```bash
generator.sh remove work
```

Safety Features

Confirmation required.

Automatic backup (if enabled).

---

## backup

Creates a backup.

```bash
generator.sh backup work
```

---

## restore

Restores a backup.

```bash
generator.sh restore work
```

---

## plugins

Lists installed plugins.

```bash
generator.sh plugins
```

Example

```
ID            VERSION

antigravity   1.0.0
cursor        1.0.0
vscode        1.0.0
```

---

## doctor

Runs a complete framework health check.

```bash
generator.sh doctor
```

Checks

- Dependencies
- Permissions
- Configuration
- Plugins
- Desktop Support
- Workspace

---

## config

Displays runtime configuration.

```bash
generator.sh config
```

Supports

```bash
generator.sh config --json
```

---

# 6. Output Formats

Human-readable

(Default)

Example

```
Instance created successfully.

Location:
/home/user/PortableApps/work
```

---

JSON

```bash
generator.sh create --json
```

Example

```json
{
    "status":"success",
    "instance":"work",
    "plugin":"antigravity",
    "path":"/home/user/PortableApps/work"
}
```

Future formats

- YAML
- XML

---

# 7. Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | Validation Error |
| 2 | Configuration Error |
| 3 | Plugin Error |
| 4 | Filesystem Error |
| 5 | Verification Error |
| 10 | Internal Framework Error |

These exit codes are stable and suitable for automation.

---

# 8. Interactive Mode

Default mode.

Example:

```
Create instance?

Name:
Plugin:
Icon:

Proceed?

[Y/n]
```

---

# 9. Non-Interactive Mode

Suitable for automation.

Example

```bash
generator.sh create \
    --plugin antigravity \
    --name work \
    --yes
```

No user prompts are displayed.

---

# 10. Examples

Create

```bash
generator.sh create \
    --plugin antigravity \
    --name work
```

Verify

```bash
generator.sh verify work
```

List

```bash
generator.sh list
```

Remove

```bash
generator.sh remove work --yes
```

Backup

```bash
generator.sh backup work
```

Doctor

```bash
generator.sh doctor
```

---

# 11. Error Messages

Example

```
ERROR

Plugin "cursor" not found.

Resolution

Install the plugin or verify the plugin ID.
```

Every error should include:

- Cause
- Resolution
- Exit Code

---

# 12. Future Commands

Reserved commands:

```
search

marketplace

upgrade-framework

plugin-install

plugin-remove

plugin-update

gui

serve

api
```

These commands are reserved for future framework versions.

---

# Help Output

Running

```bash
generator.sh --help
```

Displays

```
Portable App Generator

Usage

generator.sh <command> [options]

Commands

create
list
info
verify
update
remove
backup
restore
plugins
doctor
config

Global Options

--help
--version
--verbose
--debug
--yes
--dry-run
--json
```

---

# CLI Design Rules

- Commands are nouns or verbs with clear intent.
- Long options use kebab-case.
- Exit codes remain stable.
- JSON output must be deterministic.
- Commands should be composable in shell scripts.
- Interactive prompts must never appear when `--yes` or non-interactive mode is selected.

---

# Summary

The CLI is the public interface of Portable App Generator. It is designed to support interactive users, automation scripts, and CI/CD pipelines while maintaining a stable, backward-compatible command set.