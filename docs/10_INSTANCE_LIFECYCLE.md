# Instance Lifecycle Specification

**Project:** Portable App Generator (PAG)

**Document:** 10_INSTANCE_LIFECYCLE.md

**Version:** 1.0.0

**Status:** Draft

---

# Table of Contents

1. Purpose
2. Lifecycle Overview
3. Instance States
4. Lifecycle Phases
5. State Transitions
6. Creation Workflow
7. Validation Workflow
8. Launch Workflow
9. Update Workflow
10. Backup Workflow
11. Restore Workflow
12. Removal Workflow
13. Failure Recovery
14. Rollback
15. Lifecycle Events
16. Metadata
17. Verification
18. Future Enhancements

---

# 1. Purpose

This document defines the complete lifecycle of every application instance managed by Portable App Generator.

Every instance follows the same lifecycle regardless of plugin type.

The framework guarantees that transitions between states are predictable, validated, and recoverable.

---

# 2. Lifecycle Overview

```

Not Created

↓

Create Request

↓

Validation

↓

Clone

↓

Configure

↓

Generate Launcher

↓

Desktop Integration

↓

Verification

↓

Installed

↓

Launch

↓

Running

↓

Stopped

↓

Update

↓

Backup

↓

Restore

↓

Remove

↓

Deleted

```

---

# 3. Instance States

Each instance exists in one of the following states.

| State | Description |
|--------|-------------|
| NEW | Not yet created |
| VALIDATING | Checking prerequisites |
| CLONING | Copying application |
| CONFIGURING | Creating runtime environment |
| INSTALLING | Creating launchers and desktop entries |
| VERIFYING | Validating installation |
| INSTALLED | Ready to use |
| RUNNING | Application currently running |
| STOPPED | Installed but not running |
| UPDATING | Applying updates |
| BACKING_UP | Creating backup |
| RESTORING | Restoring backup |
| REMOVING | Removing instance |
| FAILED | Operation failed |
| ROLLBACK | Recovering previous state |
| DELETED | Instance removed |

---

# 4. Lifecycle Phases

The lifecycle is divided into six major phases.

### Phase 1

Preparation

- Load configuration
- Detect plugin
- Validate environment

---

### Phase 2

Installation

- Clone application
- Create runtime directories
- Configure isolation

---

### Phase 3

Integration

- Generate launcher
- Generate desktop entry
- Install icon

---

### Phase 4

Operation

- Launch
- Stop
- Verify
- Monitor (future)

---

### Phase 5

Maintenance

- Update
- Backup
- Restore

---

### Phase 6

Removal

- Uninstall
- Cleanup
- Delete metadata

---

# 5. State Transitions

```

NEW

↓

VALIDATING

↓

CLONING

↓

CONFIGURING

↓

INSTALLING

↓

VERIFYING

↓

INSTALLED

↓

RUNNING

↓

STOPPED

↓

UPDATING

↓

INSTALLED

↓

REMOVING

↓

DELETED

```

Any failure transitions to

```

FAILED

↓

ROLLBACK

↓

Previous Stable State

```

---

# 6. Creation Workflow

Steps

1. Read configuration
2. Validate input
3. Load plugin
4. Verify source application
5. Create instance directory
6. Clone application
7. Create runtime directories
8. Configure runtime
9. Generate launcher
10. Generate desktop entry
11. Register metadata
12. Verify installation
13. Mark instance as INSTALLED

---

# 7. Validation Workflow

Validation includes:

✓ Configuration

✓ Plugin

✓ Source path

✓ Destination path

✓ Permissions

✓ Required dependencies

✓ Available disk space

✓ Existing instance conflicts

Validation failures terminate the operation before changes are made.

---

# 8. Launch Workflow

Steps

1. Verify installation
2. Validate runtime directories
3. Export environment variables
4. Start application
5. Capture process ID
6. Record launch time
7. Return process status

Future versions may support process monitoring.

---

# 9. Update Workflow

Steps

1. Verify current installation
2. Create backup
3. Apply update
4. Validate updated installation
5. Rollback on failure
6. Mark update complete

Updates must never leave the instance in a partially updated state.

---

# 10. Backup Workflow

Backup includes:

Application files

Configuration

Profile

Metadata

Desktop files

Launchers

Backup metadata

Each backup receives:

- Timestamp
- Version
- Plugin version
- Framework version

---

# 11. Restore Workflow

Restore process

1. Validate backup
2. Stop running instance
3. Replace files
4. Restore configuration
5. Restore metadata
6. Verify installation
7. Mark instance as INSTALLED

---

# 12. Removal Workflow

Removal steps

1. Verify instance exists
2. Stop application (if running)
3. Remove desktop entry
4. Remove launcher
5. Remove runtime directories
6. Remove metadata
7. Remove backups (optional)
8. Mark instance as DELETED

No other instance shall be affected.

---

# 13. Failure Recovery

Failures may occur during:

Validation

Clone

Configuration

Desktop Integration

Verification

Launch

Update

Recovery strategy:

- Detect failure
- Record error
- Rollback changes
- Restore previous stable state
- Generate diagnostic report

---

# 14. Rollback

Rollback shall restore:

Application

Configuration

Launcher

Desktop entry

Metadata

Runtime directories

Rollback shall never leave partial state.

---

# 15. Lifecycle Events

Framework events

```

before_create

after_create

before_launch

after_launch

before_update

after_update

before_backup

after_backup

before_restore

after_restore

before_remove

after_remove

```

Plugins may implement corresponding hooks.

---

# 16. Metadata

Every instance contains metadata.

Example

```

metadata/

instance.json

```

Fields

- Instance ID
- Name
- Plugin
- Framework Version
- Plugin Version
- Creation Date
- Last Launch
- Last Update
- Status
- Backup Count

Metadata is used for lifecycle management and diagnostics.

---

# 17. Verification

After every lifecycle operation the framework verifies:

✓ Instance exists

✓ Metadata updated

✓ Launcher valid

✓ Desktop entry valid

✓ Runtime directories exist

✓ Plugin integrity

✓ Configuration consistency

Operations are considered successful only after verification passes.

---

# 18. Future Enhancements

Planned lifecycle features:

- Instance snapshots
- Scheduled backups
- Automatic health checks
- Process monitoring
- Automatic repair
- Update channels
- Rollback history
- Lifecycle event subscriptions
- Remote lifecycle management

---

# Lifecycle Rules

- Every operation is transactional where practical.
- Validation always precedes modification.
- Backups precede destructive actions.
- Rollback is automatic after recoverable failures.
- Metadata reflects the current state.
- Verification concludes every lifecycle phase.

---

# Summary

The Instance Lifecycle Specification defines the authoritative workflow for managing application instances within Portable App Generator.

By standardizing states, transitions, verification, and recovery, the framework ensures reliable, predictable, and recoverable operations across all supported plugins.