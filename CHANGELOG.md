# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-07-22

### Added
- **Architecture**: Complete Bash 5.x framework with strict mode (`set -euo pipefail`), dynamic loading, logging, and error handling.
- **Features**: Core libraries for metadata parsing, template engine, plugin framework, and application engine.
- **SDK**: A facade for developers to easily interface with core framework capabilities.
- **CLI**: A dynamic command registry and dispatch system for running pag commands (init, build, validate, etc.).
- **Testing**: A self-contained, dependency-free test runner and assertion framework for Bash, with CI aggregation support.
- **Distribution**: Native package generation capabilities (AppImage, deb, rpm), including checksums and GPG signing.
- **Marketplace**: Support for discovering, verifying, and fetching plugins from decentralized repository indices, with full dependency resolution.
- **Documentation**: Generation tools for API docs, CLI docs, UNIX man pages, and a static site.

### Known Limitations
- Windows/macOS native packaging is not yet fully implemented (Linux only for now).
- SAT-based advanced conflict resolution heuristics are planned but fall back to strict version matching currently.

### Future Roadmap
- Complete enterprise federation, signed release workflows, and multi-repository dependency visualization.
