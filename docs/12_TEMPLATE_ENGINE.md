# Template Engine Specification

**Project:** Portable App Generator (PAG)

**Document:** 12_TEMPLATE_ENGINE.md

**Version:** 1.0.0

**Status:** Draft

---

# Table of Contents

1. Purpose
2. Design Goals
3. Architecture
4. Template Types
5. Template Discovery
6. Template Variables
7. Variable Resolution
8. Rendering Engine
9. Conditional Blocks
10. Validation
11. Escaping Rules
12. Plugin Templates
13. Built-in Templates
14. Custom Templates
15. Template API
16. Error Handling
17. Performance
18. Security
19. Future Enhancements

---

# 1. Purpose

The Template Engine provides a standard mechanism for generating text-based artifacts.

Examples include:

- launch.sh
- .desktop
- metadata.json
- README.md
- configuration files
- plugin manifests

The engine separates presentation from logic.

---

# 2. Design Goals

The engine shall be:

- Simple
- Fast
- Deterministic
- Plugin-friendly
- Extensible
- Testable

Templates shall never contain business logic.

---

# 3. Architecture

```

Framework

↓

Template Loader

↓

Variable Resolver

↓

Renderer

↓

Validator

↓

Output Writer

```

Only the framework renders templates.

Plugins provide template files.

---

# 4. Template Types

Supported template types

```
Shell Script

Desktop Entry

JSON

YAML

INI

Markdown

Text
```

Future

```
XML

TOML

systemd

Docker

Kubernetes
```

---

# 5. Template Discovery

Framework search order

```
Plugin Template

↓

Framework Template

↓

Built-in Default
```

Example

```
plugins/

antigravity/

templates/

launch.sh.tpl

desktop.desktop.tpl

metadata.json.tpl
```

---

# 6. Template Variables

Variables use double braces.

Example

```text
{{INSTANCE_NAME}}

{{PLUGIN_NAME}}

{{APP_PATH}}

{{LAUNCHER_PATH}}

{{ICON_PATH}}
```

Variable names are uppercase with underscores.

---

# 7. Variable Resolution

Resolution order

```
Framework

↓

Plugin

↓

Instance

↓

Runtime
```

Framework variables cannot be overridden.

---

# 8. Rendering Engine

Rendering steps

1.

Load template

↓

2.

Parse variables

↓

3.

Resolve values

↓

4.

Escape values

↓

5.

Validate output

↓

6.

Write file

---

# 9. Conditional Blocks

Optional syntax

```
{{#if DEBUG}}

...

{{/if}}
```

Future support

```
else

elseif

loops
```

Version 1 should keep conditionals minimal.

---

# 10. Validation

Before writing output

Framework verifies

✓ Variable exists

✓ Variable type

✓ Syntax

✓ Encoding

✓ Required placeholders resolved

Unresolved placeholders cause validation failure.

---

# 11. Escaping Rules

All inserted values must be escaped according to output type.

Examples

Shell

```bash
"$VALUE"
```

JSON

```
\"value\"
```

Desktop Entry

```
Exec="/path"
```

Renderer chooses the appropriate escaping strategy.

---

# 12. Plugin Templates

Plugins may provide custom templates.

Example

```
plugins/

cursor/

templates/

launcher.tpl

desktop.tpl

metadata.tpl
```

Plugins should reuse framework templates whenever possible.

---

# 13. Built-in Templates

Framework provides default templates.

Examples

```
launcher.tpl

desktop.tpl

metadata.tpl

README.tpl

instance.json.tpl
```

These serve as fallbacks.

---

# 14. Custom Templates

Users may override templates.

Search order

```
User

↓

Plugin

↓

Framework

```

User templates are optional.

---

# 15. Template API

Framework functions

```bash
template_exists()

template_load()

template_render()

template_validate()

template_write()
```

Plugins never manipulate template internals.

---

# 16. Error Handling

Possible errors

Missing template

Unknown variable

Invalid syntax

Permission denied

Write failure

Every error includes

Cause

Template

Line Number (if applicable)

Suggested Resolution

---

# 17. Performance

The renderer should:

- Load templates once per operation
- Avoid repeated parsing
- Cache compiled templates (future)

Target:

Render a standard template in under 50 ms.

---

# 18. Security

The engine shall:

- Reject path traversal
- Reject executable template code
- Escape all variables
- Validate output paths
- Restrict writes to instance directories

Templates are treated as data, not executable code.

---

# 19. Future Enhancements

Planned features

- Template inheritance
- Includes
- Macros
- Loops
- Filters
- Localization
- Template caching
- Theme support

---

# Built-in Variables

The following variables are available in every template:

```
PAG_VERSION

INSTANCE_ID

INSTANCE_NAME

PLUGIN_ID

PLUGIN_NAME

INSTANCE_PATH

APP_PATH

PROFILE_PATH

CONFIG_PATH

CACHE_PATH

DATA_PATH

STATE_PATH

TMP_PATH

LOG_PATH

DESKTOP_PATH

LAUNCHER_PATH

ICON_PATH

CREATED_AT

UPDATED_AT
```

Plugins may define additional variables using a documented namespace (for example, `PLUGIN_*`) to avoid collisions.

---

# Template Directory Layout

```
templates/

launcher.sh.tpl

desktop.desktop.tpl

metadata.json.tpl

README.md.tpl

instance.json.tpl
```

Plugin-specific templates:

```
plugins/

antigravity/

templates/

launch.sh.tpl

desktop.desktop.tpl

icon.png
```

---

# Template Validation Checklist

Every template must satisfy:

✓ UTF-8 encoding

✓ Valid syntax

✓ No unresolved placeholders

✓ Correct file permissions (if executable)

✓ Output validation passed

✓ Escaping applied

✓ Framework compatibility verified

---

# Summary

The Template Engine is responsible for producing all generated artifacts in a consistent, secure, and deterministic manner.

By separating templates from implementation logic, the framework enables plugins, users, and future extensions to customize generated files without modifying the core engine.