# Contributing to Portable App Generator (PAG)

First off, thank you for considering contributing to PAG!

## Development Setup
1. Clone the repository: `git clone https://github.com/your-org/portable-app-generator.git`
2. Ensure you have Bash 5.x installed.
3. Install `shellcheck` and `shfmt`.

## Coding Standards
- **Bash 5.x only**.
- Always include `set -euo pipefail` and `IFS=$'\n\t'`.
- All variables must be quoted.
- Do not use `exit` inside library modules; return status codes instead.
- Use `framework_require()` instead of `source`.
- Keep functions small and reusable.

## Testing Workflow
- Run tests via the integrated test suite: `./tests/run.sh`
- Ensure all tests pass before submitting a PR.
- Add new tests for any new features or bug fixes.

## Commit Conventions
We follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/):
- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation changes
- `refactor:` for code refactoring

## Pull Request Process
1. Fork the repo and create your branch from `main`.
2. Run `shellcheck` and `shfmt` over your code.
3. Run the test suite.
4. Open a Pull Request using the provided template.

## Issue Reporting
Use the provided issue templates for bugs and feature requests. Please provide as much context as possible.
