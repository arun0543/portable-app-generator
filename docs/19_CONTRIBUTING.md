# Contributing Guide

**Project:** Portable App Generator (PAG)

**Document:** 19_CONTRIBUTING.md

**Version:** 1.0.0

**Status:** Draft

---

# Table of Contents

1. Purpose
2. Guiding Principles
3. Ways to Contribute
4. Development Workflow
5. Branching Strategy
6. Commit Message Convention
7. Pull Request Process
8. Code Review Process
9. Issue Reporting
10. Feature Proposals
11. Plugin Contributions
12. Documentation Contributions
13. Release Contributions
14. Community Standards
15. Recognition
16. Future Governance

---

# 1. Purpose

This document defines the official contribution process for the Portable App Generator project.

Objectives:

- Encourage high-quality contributions
- Maintain code quality
- Standardize development workflow
- Simplify onboarding
- Ensure long-term maintainability

---

# 2. Guiding Principles

Contributors should strive for:

- Simplicity
- Readability
- Maintainability
- Backward compatibility
- Security
- Testability
- Respectful collaboration

Quality is preferred over quantity.

---

# 3. Ways to Contribute

Contributions include:

- Bug fixes
- New features
- Plugin development
- Documentation improvements
- Test improvements
- Performance optimizations
- Security enhancements
- Build and tooling improvements

Non-code contributions are equally valuable.

---

# 4. Development Workflow

Standard workflow:

```
Fork Repository

↓

Create Branch

↓

Develop

↓

Run Tests

↓

Update Documentation

↓

Submit Pull Request

↓

Review

↓

Merge
```

All contributions should follow this workflow.

---

# 5. Branching Strategy

Branch naming:

```
main

develop

feature/<feature-name>

fix/<issue-name>

docs/<topic>

release/<version>

hotfix/<version>
```

Examples:

```
feature/template-cache

fix/plugin-validation

docs/runtime-isolation
```

Direct commits to `main` are discouraged.

---

# 6. Commit Message Convention

Format:

```
type(scope): summary
```

Types:

```
feat

fix

docs

test

refactor

build

ci

perf

style

chore
```

Examples:

```
feat(plugin): add Cursor plugin

fix(runtime): resolve launcher permissions

docs(cli): update command examples

test(instance): add rollback tests
```

Commits should be focused and atomic.

---

# 7. Pull Request Process

Every pull request should include:

- Clear description
- Related issue (if applicable)
- Testing summary
- Documentation updates
- Breaking change notes (if any)

Checklist:

✓ Tests pass

✓ Documentation updated

✓ Static analysis clean

✓ Coding standards followed

---

# 8. Code Review Process

Reviewers should verify:

- Correctness
- Security
- Performance impact
- Readability
- Test coverage
- Documentation
- Backward compatibility

Feedback should be constructive and actionable.

---

# 9. Issue Reporting

Bug reports should include:

- Framework version
- Operating system
- Bash version
- Plugin (if applicable)
- Steps to reproduce
- Expected behavior
- Actual behavior
- Relevant logs

A minimal reproducible example is encouraged.

---

# 10. Feature Proposals

Feature requests should describe:

- Problem statement
- Proposed solution
- Alternatives considered
- Expected impact
- Compatibility considerations

Large changes may require an Architecture Decision Record (ADR).

---

# 11. Plugin Contributions

Plugin submissions should include:

- Source code
- Manifest
- Documentation
- Automated tests
- Example configuration

Plugins must comply with:

- Plugin API Reference
- Security Specification
- Coding Standard
- Testing Strategy

---

# 12. Documentation Contributions

Documentation changes should:

- Use consistent terminology
- Reference relevant specifications
- Include examples where appropriate
- Update cross-references when needed

Normative requirements should use clear language such as:

- SHALL
- SHOULD
- MAY

---

# 13. Release Contributions

Before a release:

✓ CHANGELOG updated

✓ Version incremented

✓ Tests passed

✓ Documentation complete

✓ Release notes prepared

Release changes should follow the Build and Release Specification.

---

# 14. Community Standards

Contributors are expected to:

- Be respectful
- Welcome constructive feedback
- Focus on technical discussion
- Respect differing viewpoints
- Avoid personal attacks

Project discussions should remain professional and collaborative.

---

# 15. Recognition

Contributors may be acknowledged through:

- Release notes
- Contributor listings
- Documentation credits

Recognition is based on meaningful contributions rather than volume.

---

# 16. Future Governance

Potential future additions:

- Maintainer roles
- Voting process
- Plugin review committee
- Long-term support maintainers
- Security response team
- Community working groups

Governance processes should evolve with project growth.

---

# Contribution Checklist

Before submitting a contribution:

✓ Branch created

✓ Code follows coding standards

✓ Tests added or updated

✓ Documentation updated

✓ Static analysis passed

✓ CI successful

✓ Pull request completed

---

# Contribution Workflow Summary

```
Issue

↓

Branch

↓

Implementation

↓

Tests

↓

Documentation

↓

Pull Request

↓

Review

↓

Merge

↓

Release
```

---

# Summary

The Contributing Guide defines the standard workflow for contributing to the Portable App Generator project. By establishing consistent development practices, review expectations, and collaboration guidelines, it helps maintain a high-quality, sustainable open-source project while making it easier for new contributors to participate.