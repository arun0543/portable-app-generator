# Runtime Isolation

**Project:** Portable App Generator (PAG)

**Document:** 08_RUNTIME_ISOLATION.md

**Version:** 1.0.0

**Status:** Draft

---

# Table of Contents

1. Purpose
2. Isolation Philosophy
3. Isolation Levels
4. Runtime Environment
5. Filesystem Isolation
6. XDG Isolation
7. Process Isolation
8. Launcher Isolation
9. Desktop Isolation
10. Network Considerations
11. Plugin Responsibilities
12. Verification
13. Security
14. Future Enhancements

---

# 1. Purpose

Runtime Isolation ensures that every generated application instance behaves as an independent installation.

Each instance must have its own:

- Configuration
- Cache
- User Data
- Logs
- Temporary Files
- Desktop Launcher
- Runtime Environment

The framework prevents unintended sharing of runtime state between instances.

---

# 2. Isolation Philosophy

The framework follows these principles:

- No shared writable state
- XDG compliant
- Predictable directory layout
- Reproducible runtime
- User-space only
- No root privileges required

---

# 3. Isolation Levels

Level 1 — Application

Each instance has its own application directory.

Example:

instances/

```
work/
testing/
customer-demo/
```

---

Level 2 — User Data

Every instance owns:

```
profile/
config/
cache/
data/
state/
logs/
tmp/
```

---

Level 3 — Desktop

Each instance owns:

- Desktop Entry
- Launcher
- Icon
- Application Name

---

Level 4 — Runtime

Every process receives an isolated environment.

---

# 4. Runtime Environment

Before launching an application, the framework prepares a dedicated environment.

Example:

```bash
HOME="$INSTANCE/profile"

XDG_CONFIG_HOME="$INSTANCE/config"

XDG_CACHE_HOME="$INSTANCE/cache"

XDG_DATA_HOME="$INSTANCE/data"

XDG_STATE_HOME="$INSTANCE/state"

TMPDIR="$INSTANCE/tmp"
```

No global user directories should be modified during execution.

---

# 5. Filesystem Isolation

Each instance uses the following structure:

```
instance/

app/

profile/

config/

cache/

data/

state/

logs/

tmp/

desktop/

assets/

metadata/
```

Purpose:

| Directory | Purpose |
|-----------|----------|
| app | Application binaries |
| profile | User profile |
| config | Configuration |
| cache | Cache files |
| data | User data |
| state | Runtime state |
| logs | Logs |
| tmp | Temporary files |
| desktop | Launcher files |
| metadata | Instance metadata |

---

# 6. XDG Isolation

The framework overrides standard XDG variables.

| Variable | Location |
|----------|----------|
| HOME | instance/profile |
| XDG_CONFIG_HOME | instance/config |
| XDG_CACHE_HOME | instance/cache |
| XDG_DATA_HOME | instance/data |
| XDG_STATE_HOME | instance/state |

Benefits:

- Independent settings
- Independent cache
- Independent sessions
- Independent extensions

---

# 7. Process Isolation

Each instance launches as an independent process.

The launcher shall:

- Set environment variables
- Initialize runtime paths
- Start the application
- Capture exit status

No process should inherit framework-specific variables unless required.

---

# 8. Launcher Isolation

Each instance receives its own launcher.

Example:

```
launch.sh
```

Responsibilities:

- Export runtime variables
- Validate directories
- Create missing runtime folders
- Start the application
- Forward exit codes

The launcher should not contain application-specific logic.

---

# 9. Desktop Isolation

Each instance owns:

```
.desktop

icon

application name

launcher
```

Example:

```
Antigravity - Work

Antigravity - Testing

Cursor - Development

Cursor - Demo
```

Desktop entries must not conflict.

---

# 10. Network Considerations

By default:

- Network access is unchanged.
- No firewall rules are modified.
- No proxy settings are altered.

Future plugin versions may provide application-specific network isolation.

---

# 11. Plugin Responsibilities

Plugins are responsible for:

- Detecting application-specific profile locations
- Configuring runtime arguments
- Applying application-specific isolation options

Examples:

Electron:

```
--user-data-dir
```

Chromium:

```
--user-data-dir

--disk-cache-dir
```

Other applications may expose equivalent options.

---

# 12. Verification

The framework verifies:

✓ Runtime directories exist

✓ XDG variables are set

✓ Launcher is executable

✓ Desktop entry is valid

✓ Required files are present

✓ Application starts successfully

Failures should produce detailed diagnostics.

---

# 13. Security

The isolation layer must:

- Prevent accidental modification of the user's home directory
- Restrict writes to the instance directory
- Avoid following unsafe symbolic links
- Validate directory ownership
- Reject unsafe paths

The framework should never require elevated privileges.

---

# 14. Future Enhancements

Potential future features:

- Linux namespaces
- Bubblewrap integration
- Firejail integration
- Flatpak runtime support
- AppImage runtime isolation
- Container-based execution
- Read-only application layer
- Per-instance network policies

These enhancements should remain optional and preserve compatibility with the core runtime isolation model.

---

# Runtime Verification Checklist

For every generated instance, verify:

- Dedicated application directory
- Dedicated profile
- Dedicated config
- Dedicated cache
- Dedicated data
- Dedicated state
- Dedicated logs
- Dedicated temporary directory
- Dedicated launcher
- Dedicated desktop entry
- Dedicated icon
- Correct XDG variables
- Successful application launch

Only when all checks pass should an instance be considered fully isolated.

---

# Summary

Runtime Isolation is the defining capability of Portable App Generator.

By providing isolated runtime environments, the framework enables multiple independent instances of the same portable application to coexist safely on a single system without sharing user data, configuration, or runtime state.