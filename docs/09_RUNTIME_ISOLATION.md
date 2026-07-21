# Desktop Integration Specification

**Project:** Portable App Generator (PAG)

**Document:** 09_DESKTOP_INTEGRATION.md

**Version:** 1.0.0

**Status:** Draft

---

# Table of Contents

1. Purpose
2. Design Goals
3. Linux Desktop Standards
4. Desktop Entry Specification
5. Launcher Specification
6. Icon Management
7. Menu Integration
8. MIME Integration
9. Startup Integration
10. File Associations
11. Desktop Validation
12. Removal
13. Security
14. Future Enhancements

---

# 1. Purpose

This document defines how Portable App Generator integrates generated applications with Linux desktop environments.

Every generated instance shall appear as an independent desktop application.

The implementation shall follow the XDG Desktop Entry Specification.

---

# 2. Design Goals

The desktop integration layer shall provide:

- Independent launchers
- Independent icons
- Independent menu entries
- Independent startup behavior
- Safe installation
- Safe removal
- Desktop environment compatibility

Supported desktop environments include:

- GNOME
- KDE Plasma
- XFCE
- Cinnamon
- MATE
- Budgie
- LXQt
- Cosmic (future)

---

# 3. Linux Desktop Standards

The framework follows:

- XDG Base Directory Specification
- XDG Desktop Entry Specification
- Freedesktop Icon Theme Specification
- MIME Applications Specification

No desktop-specific behavior should be hardcoded.

---

# 4. Desktop Entry Specification

Every instance shall generate a unique desktop file.

Example:

```
antigravity-work.desktop
```

Required fields:

```
[Desktop Entry]

Type=Application

Version=1.0

Name=Antigravity - Work

Exec=/home/user/PortableApps/work/launch.sh

Icon=antigravity-work

Terminal=false

Categories=Development;

StartupNotify=true
```

Every desktop entry shall have a unique filename.

---

# 5. Launcher Specification

Each instance receives one launcher.

Example

```
launch.sh
```

Responsibilities

- Load environment
- Configure runtime
- Verify directories
- Launch application
- Return exit code

The launcher shall be executable.

Permissions:

```
755
```

---

# 6. Icon Management

Each instance owns an independent icon.

Sources:

- Plugin default
- User supplied
- Generated variant (future)

Icons should be installed under:

```
~/.local/share/icons/
```

Recommended formats:

PNG

SVG

Future:

ICO

---

# 7. Menu Integration

Generated applications shall appear inside the application menu.

Requirements

Unique Name

Unique Icon

Unique Launcher

Unique Desktop Entry

Categories should be configurable.

---

# 8. MIME Integration

Future feature.

Plugins may register:

File extensions

URI handlers

MIME types

Only with explicit user approval.

---

# 9. Startup Integration

Optional feature.

Users may enable:

Launch on Login

Implementation:

```
~/.config/autostart/
```

Each generated instance receives its own startup file.

---

# 10. File Associations

Future plugins may support:

Open With

Default Application

Custom URI schemes

Framework shall never override existing associations without confirmation.

---

# 11. Desktop Validation

Validation checks include:

✓ Desktop file exists

✓ Exec path valid

✓ Icon exists

✓ Desktop entry syntax valid

✓ Launcher executable

✓ Application starts

Framework shall report all validation failures.

---

# 12. Removal

Removing an instance shall remove:

Desktop entry

Launcher

Icon

Autostart entry

Associated metadata

Removal shall not affect other instances.

---

# 13. Security

Desktop integration must:

- Avoid overwriting existing entries
- Sanitize file names
- Validate icon paths
- Quote executable paths
- Restrict installation to user-owned locations

System-wide installation is outside the scope of version 1.0.

---

# 14. Future Enhancements

Planned support:

- Wayland-specific metadata
- Desktop Actions
- Jump Lists
- Dock integration
- Notification integration
- Progress indicators
- Dynamic icons
- Multi-language desktop entries

---

# Desktop Integration Checklist

Every generated instance shall provide:

✓ Launcher

✓ Desktop Entry

✓ Icon

✓ Menu Entry

✓ Correct Categories

✓ Startup Notification

✓ Validation Passed

✓ Independent Removal

---

# Summary

The Desktop Integration layer ensures every generated application behaves like a native Linux application while remaining completely isolated from other instances and the underlying system.