# Project Structure

**Project:** Portable App Generator (PAG)

**Document:** 03_PROJECT_STRUCTURE.md

**Version:** 1.0.0

**Status:** Draft

---

# Table of Contents

1. Purpose
2. Design Philosophy
3. Repository Layout
4. Root Directory
5. Source Code Layout
6. Documentation Layout
7. Plugin Layout
8. Template Layout
9. Asset Layout
10. Runtime Layout
11. Testing Layout
12. Naming Conventions
13. Coding Conventions
14. File Ownership
15. Dependency Rules
16. Growth Strategy

---

# 1. Purpose

This document defines the official repository structure for Portable App Generator.

Every file and directory must have a clearly defined responsibility.

No directory should contain unrelated files.

---

# 2. Design Philosophy

The repository follows the following principles.

• Modular

• Predictable

• Easy Navigation

• Easy Testing

• Easy Documentation

• Easy Extension

Every folder exists for a reason.

---

# 3. Repository Layout

portable-app-generator/

├── generator.sh
├── install.sh
├── uninstall.sh
├── version.sh
├── README.md
├── LICENSE
├── CHANGELOG.md
├── VERSION
├── .env.example
├── .gitignore
│
├── assets/
├── docs/
├── examples/
├── instances/
├── lib/
├── logs/
├── plugins/
├── templates/
├── tests/
├── tools/
└── vendor/

---

# 4. Root Directory

Only entry-point files belong here.

Allowed

generator.sh

install.sh

README.md

LICENSE

VERSION

Configuration examples

Git configuration

Nothing else.

Business logic must never exist here.

---

# 5. lib/

Purpose

Contains reusable framework modules.

Every file must expose a documented public API.

Structure

lib/

backup.sh

cache.sh

clone.sh

colors.sh

config.sh

desktop.sh

electron.sh

environment.sh

filesystem.sh

icons.sh

instance.sh

launcher.sh

logger.sh

permissions.sh

plugin.sh

profile.sh

rollback.sh

spinner.sh

progress.sh

utils.sh

validator.sh

Responsibilities

Each module owns exactly one responsibility.

---

# 6. plugins/

Purpose

Application-specific logic.

Examples

plugins/

antigravity.sh

cursor.sh

claude.sh

electron.sh

vscode.sh

windsurf.sh

chromium.sh

Plugin Contract

Every plugin shall implement

plugin_name()

detect()

validate()

clone()

configure()

launch()

verify()

update()

remove()

Plugins must never modify framework code.

---

# 7. templates/

Purpose

Contains reusable file templates.

Examples

templates/

launcher.sh

desktop.desktop

uninstall.sh

metadata.json

future/

systemd.service

Templates contain placeholders.

Business logic must not exist here.

---

# 8. assets/

Purpose

Icons

Logos

Images

Static Resources

Examples

assets/

default-icon.png

banner.png

logos/

icons/

themes/

No executable files.

---

# 9. docs/

Purpose

Project documentation.

Contains

Architecture

Requirements

ADR

Guides

Roadmap

Examples

Reference documentation

No source code.

---

# 10. examples/

Purpose

Example configurations.

Example .env

Example plugins

Example generated projects

Example desktop files

Examples must always work.

---

# 11. tests/

Purpose

Automated testing.

Structure

tests/

unit/

integration/

plugins/

fixtures/

mock/

scripts/

Future

performance/

security/

---

# 12. instances/

Purpose

Generated applications.

Each generated application receives

instance/

app/

profile/

cache/

config/

logs/

tmp/

desktop/

assets/

metadata/

Example

instances/

antigravity-work/

antigravity-test/

customer-demo/

This directory is runtime data.

Never commit generated instances.

---

# 13. logs/

Purpose

Generator logs.

Example

generator.log

install.log

rollback.log

validation.log

Logs should rotate in future versions.

---

# 14. tools/

Purpose

Developer utilities.

Examples

formatter

release

lint

documentation generator

benchmark

No runtime code.

---

# 15. vendor/

Purpose

Third-party dependencies.

Only when absolutely necessary.

Avoid adding files here.

---

# 16. Naming Conventions

Directories

lowercase

hyphen-case

Examples

portable-app-generator

customer-demo

Functions

snake_case()

Variables

UPPER_CASE

Private Functions

_prefix_name()

Constants

readonly UPPER_CASE

Files

snake_case.sh

---

# 17. Coding Standards

Maximum module size

≈300 lines (guideline)

Maximum function size

≈40 lines (guideline)

One responsibility per function.

No duplicated code.

No circular dependencies.

No global mutable variables.

---

# 18. Dependency Rules

generator.sh

↓

config

↓

logger

↓

validator

↓

plugin

↓

clone

↓

launcher

↓

desktop

↓

verification

Dependencies always flow downward.

Modules must not depend on higher layers.

---

# 19. File Ownership

Each module has one owner.

Example

logger.sh

Owns

Logging

Nothing else.

desktop.sh

Owns

Desktop entries only.

filesystem.sh

Owns

Filesystem only.

This prevents feature overlap.

---

# 20. Repository Growth Strategy

Version 1

< 25 modules

Version 2

< 40 modules

Version 3

Plugin Marketplace

GUI

REST API

Future

Cloud Sync

Remote Repository

Cross Platform

---

# Repository Rules

Business logic belongs only inside

lib/

Application logic belongs only inside

plugins/

Documentation belongs only inside

docs/

Generated applications belong only inside

instances/

Tests belong only inside

tests/

The repository should remain organized regardless of project size.

---

# Architecture Compliance Checklist

✔ Single Responsibility

✔ Separation of Concerns

✔ Modular Design

✔ Plugin Friendly

✔ Git Friendly

✔ Test Friendly

✔ Documentation First

✔ Framework First

✔ Application Agnostic

✔ Future Ready

---

# Summary

The repository layout is intentionally conservative.

Every directory has one responsibility.

Every module has one responsibility.

Every plugin has one responsibility.

This structure minimizes maintenance cost while maximizing scalability and contributor friendliness.