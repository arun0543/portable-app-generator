# Developer Guide

**Project:** Portable App Generator (PAG)

**Document:** 04_DEVELOPER_GUIDE.md

**Version:** 1.0.0

**Status:** Draft

---

# Table of Contents

1. Introduction
2. Development Philosophy
3. Getting Started
4. Repository Setup
5. Project Workflow
6. Coding Standards
7. Module Development
8. Plugin Development
9. Testing
10. Debugging
11. Logging
12. Error Handling
13. Git Workflow
14. Pull Request Guidelines
15. Code Review Checklist
16. Documentation Requirements
17. Release Process
18. Best Practices
19. Common Mistakes
20. Appendix

---

# 1. Introduction

This guide defines how developers contribute to Portable App Generator.

Every contributor must follow this guide to ensure consistency, maintainability, and code quality.

---

# 2. Development Philosophy

The project follows these principles:

- Documentation First
- Architecture Before Code
- Small, Focused Modules
- Plugin-Based Design
- Test Before Merge
- No Breaking Changes Without ADR

---

# 3. Getting Started

## Clone Repository

```bash
git clone <repository-url>
cd portable-app-generator
```

## Verify Bash Version

```bash
bash --version
```

Minimum supported version:

```
Bash 5.x
```

## Directory Overview

```
generator.sh
lib/
plugins/
templates/
tests/
docs/
```

---

# 4. Repository Setup

Required tools:

- Bash 5.x
- Git
- ShellCheck
- shfmt
- make (optional)
- tree (optional)
- jq (optional)

Verify installation:

```bash
shellcheck --version
shfmt --version
```

---

# 5. Project Workflow

Development cycle:

Requirement
↓

Architecture
↓

ADR (if needed)
↓

Implementation
↓

Unit Test
↓

Integration Test
↓

Documentation
↓

Code Review
↓

Merge

---

# 6. Coding Standards

## Functions

- Single responsibility
- Descriptive names
- Small and focused
- Return meaningful exit codes

Example:

```bash
create_instance() {
    ...
}
```

---

## Variables

Global:

```bash
INSTANCE_NAME
```

Local:

```bash
local source_dir
```

Constants:

```bash
readonly DEFAULT_ICON
```

---

## Quoting

Always quote variables:

```bash
cp "$source" "$destination"
```

Never:

```bash
cp $source $destination
```

---

## Strict Mode

Every executable script should begin with:

```bash
#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'
```

---

# 7. Module Development

Each module:

- Owns one responsibility
- Has documented public functions
- Avoids global state
- Returns status codes
- Uses logger instead of echo

Example:

```
lib/logger.sh
```

Public API:

```bash
log_info()
log_warn()
log_error()
```

---

# 8. Plugin Development

Plugins live in:

```
plugins/
```

Every plugin must implement:

```bash
plugin_name()
detect()
validate()
clone()
configure()
launch()
verify()
update()
remove()
```

Plugins must not:

- Modify framework code
- Write outside assigned directories
- Call private framework functions

---

# 9. Testing

Before every commit:

Run:

```bash
shellcheck .
```

Run:

```bash
shfmt -w .
```

Run:

```bash
tests/run_all.sh
```

All tests must pass.

---

# 10. Debugging

Enable debug logging:

```bash
DEBUG=1 ./generator.sh
```

Useful tools:

- bash -x
- shellcheck
- shfmt
- tree

---

# 11. Logging

Never use:

```bash
echo "Error"
```

Instead:

```bash
log_error "Failed to create instance."
```

Supported levels:

- TRACE
- DEBUG
- INFO
- SUCCESS
- WARNING
- ERROR
- FATAL

---

# 12. Error Handling

Functions return:

0 = Success

1 = Recoverable Error

2 = Validation Error

3 = Fatal Error

Errors should include:

- What failed
- Why it failed
- Suggested resolution

---

# 13. Git Workflow

Feature branches:

```
feature/<name>
```

Bug fixes:

```
fix/<name>
```

Documentation:

```
docs/<name>
```

Releases:

```
release/<version>
```

---

# 14. Pull Request Guidelines

Every PR must include:

- Description
- Related issue
- Test results
- Updated documentation
- Screenshots (if UI changes)

---

# 15. Code Review Checklist

Verify:

- Single responsibility
- No duplicated code
- ShellCheck clean
- shfmt applied
- Tests passing
- Documentation updated
- No hardcoded paths
- No unsafe shell usage

---

# 16. Documentation Requirements

Every new module requires:

- Purpose
- Inputs
- Outputs
- Public API
- Dependencies
- Example usage

Update relevant ADRs if architecture changes.

---

# 17. Release Process

Release checklist:

1. Run all tests
2. Update CHANGELOG.md
3. Update VERSION
4. Tag release
5. Build release package
6. Publish release
7. Verify installation

---

# 18. Best Practices

- Keep modules small
- Prefer readability
- Reuse existing modules
- Write defensive code
- Validate input early
- Fail fast
- Log meaningful messages

---

# 19. Common Mistakes

Avoid:

- Hardcoded paths
- Unquoted variables
- Duplicate logic
- Circular dependencies
- Using `echo` for logging
- Skipping tests
- Editing generated files manually

---

# 20. Appendix

Reference documents:

- 00_MASTER_PROMPT.md
- 01_SOFTWARE_REQUIREMENTS_SPECIFICATION.md
- 02_ARCHITECTURE.md
- 03_PROJECT_STRUCTURE.md
- ADR/

This guide is mandatory for all contributors.