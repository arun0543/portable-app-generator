# System Architecture

**Project:** Portable App Generator (PAG)

**Document:** 02_ARCHITECTURE.md

**Version:** 1.0.0

**Status:** Draft

---

# Table of Contents

1. Overview
2. Architecture Goals
3. Design Principles
4. High-Level Architecture
5. Component Architecture
6. Layered Architecture
7. Core Engine
8. Module Responsibilities
9. Plugin System
10. Execution Flow
11. Runtime Isolation
12. Desktop Integration
13. Configuration System
14. Logging Architecture
15. Error Handling
16. Security Architecture
17. Data Flow
18. Directory Structure
19. Extension Points
20. Future Architecture

---

# 1. Overview

Portable App Generator (PAG) is designed as a modular automation framework.

It generates isolated portable application instances while remaining independent from any single application type.

The architecture emphasizes:

• Modularity

• Maintainability

• Testability

• Extensibility

• Plugin-based application support

• Zero shared runtime state

---

# 2. Architecture Goals

The architecture shall provide:

✔ Single Responsibility

✔ Loose Coupling

✔ High Cohesion

✔ Plugin Support

✔ XDG Compliance

✔ ShellCheck Compliance

✔ Zero Hardcoded Applications

✔ Git Friendly

✔ Test Friendly

✔ Future GUI Support

---

# 3. Design Principles

## Principle 1

Every module owns exactly one responsibility.

---

## Principle 2

No module may directly manipulate another module's internal state.

---

## Principle 3

All communication occurs through documented functions.

---

## Principle 4

Plugins extend the generator.

Plugins never modify the generator.

---

## Principle 5

Configuration is data.

Business logic never contains configuration values.

---

# 4. High-Level Architecture

                    +-----------------------+
                    |      CLI ENTRY        |
                    |    generator.sh       |
                    +-----------+-----------+
                                |
                                v
                  +----------------------------+
                  |     Configuration Loader   |
                  +-------------+--------------+
                                |
                                v
                  +----------------------------+
                  |      Validation Engine     |
                  +-------------+--------------+
                                |
                                v
                  +----------------------------+
                  |      Plugin Manager        |
                  +-------------+--------------+
                                |
                                v
                 +------------------------------+
                 |      Generation Engine       |
                 +-------------+----------------+
                               |
       +-----------+-----------+-----------+------------+
       |           |           |           |            |
       v           v           v           v            v

 Filesystem   Launcher   Desktop    Isolation     Logging

                               |
                               v

                       Verification Engine

                               |
                               v

                           Success Report

---

# 5. Component Architecture

The project consists of independent components.

CLI

↓

Configuration

↓

Validation

↓

Plugin

↓

Generation

↓

Verification

↓

Reporting

Each component shall expose a stable public interface.

---

# 6. Layered Architecture

Application Layer

generator.sh

↓

Service Layer

Generation Engine

↓

Domain Layer

Plugins

↓

Infrastructure Layer

Filesystem

Desktop

Icons

Logging

Launcher

Environment

---

# 7. Core Engine

The Core Engine coordinates every subsystem.

Responsibilities

• load configuration

• initialize logging

• validate environment

• detect application

• load plugin

• execute generation

• verify result

• generate report

The Core Engine never contains application-specific logic.

---

# 8. Module Responsibilities

Configuration

Loads .env

Validates variables

Provides read-only configuration.

---

Logger

Colored console output

File logging

Timestamping

Log rotation (future)

---

Validator

Environment validation

Dependency validation

Permission validation

Configuration validation

---

Filesystem

Create directories

Copy files

Delete files

Backup

Restore

Rollback

---

Launcher

Generate launch.sh

Generate wrapper executable

Set permissions

---

Desktop

Generate .desktop

Install launcher

Refresh desktop database

Refresh icon cache

---

Isolation

Prepare

HOME

TMPDIR

XDG_CONFIG_HOME

XDG_CACHE_HOME

XDG_DATA_HOME

XDG_STATE_HOME

Runtime directories

---

Plugin Manager

Locate plugin

Load plugin

Validate interface

Execute lifecycle

---

Verification

Verify installation

Verify permissions

Verify executable

Verify launcher

Verify desktop entry

Generate report

---

# 9. Plugin Architecture

Each supported application implements a plugin.

plugins/

antigravity.sh

cursor.sh

claude.sh

chromium.sh

electron.sh

Plugin Interface

detect()

verify()

clone()

configure()

launch()

update()

remove()

validate()

Every plugin shall follow the same contract.

---

# 10. Execution Flow

User

↓

generator.sh

↓

Configuration Loader

↓

Logger

↓

Validator

↓

Plugin Detection

↓

Plugin Initialization

↓

Filesystem

↓

Clone

↓

Launcher

↓

Desktop

↓

Verification

↓

Summary

↓

Exit

---

# 11. Runtime Isolation

Every generated instance owns

Application Directory

↓

Profile

↓

Cache

↓

Config

↓

Data

↓

Logs

↓

Temp

↓

Desktop Entry

↓

Launcher

↓

Icon

↓

Environment Variables

Nothing shall be shared unless explicitly configured.

---

# 12. Desktop Integration

Generated applications shall appear as native Linux applications.

Features

Custom Name

Custom Icon

Custom Executable

Custom Desktop Entry

Custom Categories

Independent Menu Entry

Independent Favorites

Desktop Integration shall follow the XDG Desktop Entry Specification.

---

# 13. Configuration System

Configuration source

.env

↓

Parser

↓

Validator

↓

Immutable Runtime Configuration

Configuration values become read-only after initialization.

---

# 14. Logging Architecture

Console Logger

↓

File Logger

↓

Structured Messages

↓

Future JSON Logger

Supported Levels

TRACE

DEBUG

INFO

SUCCESS

WARNING

ERROR

FATAL

---

# 15. Error Handling

Every module returns

Success

Warning

Recoverable Error

Fatal Error

The Core Engine decides recovery strategy.

Modules never terminate the application directly.

---

# 16. Security Architecture

Never execute arbitrary user input.

Never use eval.

Quote every variable.

Validate every path.

Protect against

Command Injection

Directory Traversal

Permission Escalation

Unsafe Symlinks

---

# 17. Data Flow

Configuration

↓

Validation

↓

Plugin

↓

Generation

↓

Verification

↓

Logging

↓

Summary

All stages shall be deterministic.

---

# 18. Repository Layout

portable-app-generator/

generator.sh

.env

lib/

plugins/

templates/

assets/

instances/

logs/

tests/

docs/

No runtime data shall be stored inside source directories.

---

# 19. Extension Points

Future extensions

GUI

REST API

Remote Plugins

Package Manager

Cloud Sync

Marketplace

AppImage

Flatpak

Snap

---

# 20. Future Architecture

Version 2

GUI

Version 3

Plugin Marketplace

Version 4

Remote Deployment

Version 5

Cross Platform

Windows

macOS

Linux

---

# Architecture Summary

The Portable App Generator architecture is built around four key principles.

1.

Core remains generic.

2.

Applications are implemented as plugins.

3.

Everything is configurable.

4.

Generated applications remain completely isolated.