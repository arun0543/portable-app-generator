# Portable App Generator (PAG)

[![Build Status](https://img.shields.io/github/actions/workflow/status/example/portable-app-generator/ci.yml?branch=main&label=Build&style=flat-square)](https://github.com/example/portable-app-generator/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/Version-1.0.0-blue.svg?style=flat-square)](https://github.com/example/portable-app-generator/releases)
[![Bash](https://img.shields.io/badge/Bash-5.x-4EAA25.svg?style=flat-square)](https://www.gnu.org/software/bash/)

**Portable App Generator (PAG)** is a powerful, documentation-first framework designed for the robust orchestration and generation of portable applications. It provides a structured CLI, SDK, and extensible architecture to easily bootstrap, validate, and build Node.js, Electron, Python, or shell-based applications.

## Key Features

- **Extensible Architecture**: Built with a modular core, allowing custom templates and plugins.
- **Robust CLI**: A comprehensive command-line interface (`pag`) with colored logging, command suggestions, and subcommands.
- **Ecosystem Tooling**: Built-in testing, code formatting (shfmt), static analysis (ShellCheck), and documentation generation.
- **Dependency Management**: A complete distribution pipeline including checksum generation, locking, and marketplace resolution.
- **Developer Experience**: "Strict mode" by default (`set -euo pipefail`), type-safe patterns, and structured logs.

## Requirements

- **Bash 5.x** or higher
- Standard Unix utilities (awk, sed, grep)
- [ShellCheck](https://www.shellcheck.net/) & [shfmt](https://github.com/mvdan/sh) (For CI and development)

## Installation

You can use the project immediately by cloning the repository:

```bash
git clone https://github.com/example/portable-app-generator.git
cd portable-app-generator
```

Add the repository directory to your `$PATH` or use the `pag` executable directly:

```bash
./pag --version
./pag --help
```

## Quick Start

Initialize a new application:

```bash
# Create a new application skeleton
./pag init my-app

# Validate the created project
./pag validate my-app

# Build and export the project
./pag build my-app
./pag export my-app release.tar.gz
```

For runnable examples, check out the `examples/` directory.

## Documentation

Full documentation is available in the [`docs/`](docs/) directory:

- [Architecture Overview](docs/ARCHITECTURE.md)
- [CLI Reference](docs/CLI_REFERENCE.md)
- [Plugin Development](docs/PLUGIN_DEVELOPMENT.md)
- [Template Development](docs/TEMPLATE_DEVELOPMENT.md)
- [SDK Guide](docs/SDK_GUIDE.md)

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) and [Code of Conduct](CODE_OF_CONDUCT.md).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.