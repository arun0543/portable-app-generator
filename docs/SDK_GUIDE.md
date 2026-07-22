# SDK Guide

The SDK is a unified facade meant for scripts and external utilities to securely integrate with PAG internals without directly sourcing low-level modules.

## Initialization
To use the SDK, you must first source the bootstrap script and require the SDK:

```bash
source lib/loader.sh
framework_require sdk

# Example: Validate a project
sdk_validate_project "/path/to/project"
```

## Available Capabilities
- **Validation**: Strict validation of projects and configurations.
- **Plugins**: Enumerate, load, and manage plugins.
- **Templates**: Render and scaffold projects dynamically.
