# Coding Standard Specification

**Project:** Portable App Generator (PAG)

**Document:** 18_CODING_STANDARD.md

**Version:** 1.0.0

**Status:** Draft

---

# Table of Contents

1. Purpose
2. Design Principles
3. Shell Compatibility
4. Repository Organization
5. Naming Conventions
6. File Standards
7. Function Standards
8. Variable Standards
9. Error Handling
10. Logging Standards
11. Documentation Standards
12. Formatting Rules
13. Static Analysis
14. Code Review
15. Definition of Done
16. Future Improvements

---

# 1. Purpose

This document defines the official coding standards for the Portable App Generator framework.

Its goals are to:

- Improve readability
- Maintain consistency
- Reduce defects
- Simplify reviews
- Support long-term maintenance

These standards apply to:

- Framework core
- Plugins
- Build tools
- Test scripts
- Utility scripts

---

# 2. Design Principles

Code shall be:

- Simple
- Modular
- Deterministic
- Testable
- Documented
- Reusable

Prefer readability over clever implementations.

---

# 3. Shell Compatibility

Framework target:

```
Bash 5.x
```

Required shebang:

```bash
#!/usr/bin/env bash
```

Required strict mode:

```bash
set -euo pipefail
IFS=$'\n\t'
```

Scripts shall avoid shell-specific behavior outside the supported Bash version.

---

# 4. Repository Organization

Framework code:

```
lib/
```

Plugins:

```
plugins/
```

Templates:

```
templates/
```

Tests:

```
tests/
```

Utilities:

```
tools/
```

One responsibility per module.

---

# 5. Naming Conventions

## Files

Use lowercase snake_case.

Examples:

```
filesystem.sh

launcher.sh

template_engine.sh
```

---

## Directories

Use lowercase.

```
plugins

templates

tests

assets
```

---

## Functions

Use lowercase snake_case.

```bash
create_instance()

validate_plugin()

generate_launcher()
```

Avoid abbreviations unless widely understood.

---

## Constants

Uppercase.

```bash
PAG_VERSION

DEFAULT_TIMEOUT

MAX_RETRIES
```

---

# 6. File Standards

Each file shall begin with:

```bash
#!/usr/bin/env bash

set -euo pipefail

IFS=$'\n\t'
```

Recommended order:

1. Header
2. Imports
3. Constants
4. Global variables
5. Public functions
6. Private functions
7. Main entry point

---

# 7. Function Standards

Functions should:

- Perform one responsibility
- Be deterministic where practical
- Return status codes
- Avoid global side effects

Example:

```bash
create_directory() {
    local path="$1"

    mkdir -p "$path"
}
```

Prefer `local` variables inside functions.

---

# 8. Variable Standards

Always quote variable expansions unless word splitting is explicitly required.

Correct:

```bash
cp "$source" "$destination"
```

Avoid:

```bash
cp $source $destination
```

Use descriptive names:

```
instance_path

plugin_directory

template_file
```

Avoid single-letter names except for simple loop counters.

---

# 9. Error Handling

Functions shall return status codes.

Example:

```bash
if ! validate_plugin; then
    log_error "Plugin validation failed"
    return 1
fi
```

Do not terminate the framework from library functions using `exit`.

---

# 10. Logging Standards

All operational messages shall use the logging API.

Allowed:

```bash
log_info

log_warn

log_error

log_debug
```

Avoid direct output for logging:

```bash
echo

printf
```

These may be used only for intentional user-facing CLI output.

---

# 11. Documentation Standards

Every public function should include a documentation block.

Example:

```bash
##
# Create a new application instance.
#
# Arguments:
#   $1 Instance name
#   $2 Plugin identifier
#
# Returns:
#   0 Success
#   1 Validation failure
##
```

Complex algorithms should include explanatory comments describing intent rather than implementation details.

---

# 12. Formatting Rules

Indentation:

```
4 spaces
```

Do not use tabs.

Maximum recommended line length:

```
100 characters
```

One blank line between functions.

Consistent spacing around operators.

---

# 13. Static Analysis

Required tools:

```
ShellCheck

shfmt
```

Example:

```bash
shellcheck lib/*.sh

shfmt -w .
```

CI shall fail on unresolved static analysis errors.

---

# 14. Code Review

Every change should verify:

✓ Naming conventions

✓ Error handling

✓ Logging

✓ Documentation

✓ Tests

✓ Formatting

✓ Security

✓ ShellCheck

✓ Backward compatibility

Reviewers should focus on correctness, maintainability, and adherence to documented contracts.

---

# 15. Definition of Done

A feature is complete only when:

✓ Requirements implemented

✓ Tests added

✓ Documentation updated

✓ Logging added

✓ Error handling verified

✓ Static analysis passed

✓ Code reviewed

✓ CI pipeline successful

---

# 16. Future Improvements

Planned enhancements:

- Automated style enforcement
- Documentation linting
- Complexity analysis
- API compatibility checks
- Coding metrics dashboard
- Automated review assistance

---

# Coding Rules

- One module, one responsibility.
- Prefer composition over duplication.
- Validate inputs before processing.
- Quote variable expansions.
- Keep functions focused.
- Return status codes instead of exiting.
- Use the framework logging API.
- Write tests alongside new functionality.

---

# Coding Checklist

✓ Bash 5.x compatible

✓ Strict mode enabled

✓ Naming conventions followed

✓ Variables quoted

✓ Functions documented

✓ Logging implemented

✓ Error handling complete

✓ Tests included

✓ ShellCheck clean

✓ shfmt applied

---

# Summary

The Coding Standard Specification establishes the required conventions for developing the Portable App Generator framework. Consistent coding practices improve readability, simplify maintenance, reduce defects, and provide a predictable development experience for all contributors.