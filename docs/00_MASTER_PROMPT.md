# Portable App Generator (PAG)

Version: 1.0.0

Status: Planning

Author: Henry

---

# 1. Executive Summary

Portable App Generator (PAG) is an enterprise-grade Linux automation framework that creates fully isolated portable application instances from an existing portable application.

The primary target is Google Antigravity.

The framework must later support any Electron application without changing the core architecture.

Examples

- Google Antigravity
- Cursor
- Claude Desktop
- VS Code
- Windsurf
- Postman
- Chromium
- Custom Electron Applications

This project is NOT an Antigravity clone.

This project is a reusable framework.

---

# 2. Vision

Linux users often duplicate portable applications manually.

Doing so creates problems.

- shared profile
- shared cache
- shared login
- shared settings
- icon conflicts
- launcher conflicts
- desktop conflicts
- maintenance difficulty

Portable App Generator solves these problems.

It creates fully independent application instances with professional desktop integration.

---

# 3. Philosophy

This project follows five engineering principles.

## 1.

Modularity

Every feature belongs in its own module.

Never write one giant Bash script.

---

## 2.

Isolation

Every generated application behaves as an independent installation.

No shared runtime state.

---

## 3.

Portability

The generator itself should require only standard Linux utilities whenever possible.

---

## 4.

Maintainability

Readable code is preferred over clever code.

---

## 5.

Extensibility

New application types should be added through plugins.

The core generator must never become application-specific.

---

# 4. Goals

Primary Goals

✔ Create isolated portable applications

✔ Professional desktop integration

✔ GitHub quality

✔ ShellCheck clean

✔ Modular architecture

✔ Plugin system

✔ Rollback support

✔ Logging

✔ Backup

✔ Restore

✔ Multiple instances

✔ Easy updates

Secondary Goals

✔ Flatpak support

✔ AppImage support

✔ Snap support

✔ Zip support

✔ Tar.gz support

✔ Binary applications

---

# 5. Non Goals

This project does NOT

- install packages using apt

- modify system files outside user scope

- require sudo for normal usage

- modify original application

- require recompiling Electron applications

---

# 6. Target Platforms

Supported

Ubuntu

Zorin OS

Linux Mint

Debian

Fedora

Future

Arch

OpenSUSE

---

# 7. Primary Use Case

Input

Google Antigravity

↓

Generator

↓

Creates

Antigravity Work

↓

Creates

Antigravity Test

↓

Creates

Customer Demo

↓

Creates

QA Build

All applications remain isolated.

---

# 8. Success Criteria

The project is successful when:

- Multiple application instances can run simultaneously.

- No instance shares user data.

- Desktop launchers are independent.

- Icons are independent.

- Profiles are independent.

- Cache is independent.

- Config is independent.

- Logs are independent.

- Updates do not break previous instances.

- Removing one instance does not affect another.