# Template Development Guide

Templates allow developers to rapidly scaffold applications.

## Template Structure
A standard PAG template looks like this:

```
template/
├── pag.yaml        # Metadata
├── src/            # Source files
└── assets/         # Static assets
```

## Using Variables
Templates can use `{{VARIABLE_NAME}}` syntax. These will be interpolated at generation time based on the user's config or interactive prompts.

## Example `pag.yaml`
```yaml
name: my-template
version: 1.0.0
description: A basic starting template
variables:
  - name: PROJECT_NAME
    default: "my-app"
```
