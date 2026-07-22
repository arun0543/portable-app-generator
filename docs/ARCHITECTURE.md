# Architecture

Portable App Generator (PAG) is built from the ground up to be a robust, modular Bash framework.

## Core Philosophy
- **Modular**: Every major system is a distinct module.
- **Dependency-free**: PAG relies entirely on Bash builtins and standard GNU Coreutils (awk, sed, grep).
- **Strict Execution**: We enforce `set -euo pipefail` to catch errors immediately.

## Component Flow
```text
CLI (Entry point)
 │
 ▼
Application Engine / Framework API
 │
 ├──────────────┬───────────────┬──────────────┐
 ▼              ▼               ▼              ▼
Testing       Marketplace    Distribution     Docs
```

## Module Loading
PAG loads dependencies dynamically via `lib/loader.sh` using `framework_require <module>`. This enforces strict boundaries and eliminates circular dependencies.
