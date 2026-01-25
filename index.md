# Oqtane AI Playbook

![Oqtane](https://img.shields.io/badge/Oqtane-Framework-blue)
![AI Governance](https://img.shields.io/badge/AI-Governed-027%20Based--green)
![Canonical Source](https://img.shields.io/badge/Canonical-Oqtane%20Framework-black)

> **This playbook aligns with the core principles of Oqtane as articulated in the Oqtane Philosophy — performance, flexibility, low ceremony, tool agnosticism, consistency, and practical engineering. See https://www.oqtane.org/blog/!/20/oqtane-philosophy for foundational context.**

---

## Overview

The **Oqtane AI Playbook** is a framework-aware governance repository for building robust, upgrade-safe Oqtane modules - with or without AI assistance. This repository makes Oqtane's implicit rules explicit, enforceable, and visible to both humans and AI tools.

**TL;DR for maintainers**: This repository defines **non-negotiable architectural and AI governance rules** for Oqtane module development. If AI-generated output conflicts with this playbook or the canonical module reference, **the output is invalid** regardless of correctness.

---

## 📋 Auto-Generated Contents

### 🎯 Core Documentation

- **[00 — Preface: How to Read and Use This Guide](docs/000-preface.md)**
- **[ # 01 — The Problem: Why AI Struggles With Oqtane Module Development](docs/001-problem.md)**
- **[02 — The Insight: AI Needs Governance, Not Better Prompts](docs/002-insight.md)**
- **[03 — Scope and Boundaries](docs/003-scope-and-boundaries.md)**

### 🚀 Getting Started

- **[005 — Oqtane Development Environment Setup](docs/005-setup.md)**
- **[006 – Module Adoption (Existing Modules)](docs/006-module-adoption.md)**
- **[ ## Oqtane Philosophy](docs/00x-playbook-foundations.md)**

### 🏗️ Architecture Guidelines

- **[10 — Services: Contracts, Boundaries, and Responsibility](docs/010-services.md)**
- **[11 — Authorization: Roles, Permissions, and Enforcement](docs/011-authorization.md)**
- **[12 — Database Migrations: Startup Execution, Versioning, and Multi-Database Safety](docs/012-migrations.md)**
- **[13 — Scheduled Jobs: Framework-Managed Background Work](docs/013-scheduled-jobs.md)**
- **[014 — UI Validation](docs/014-ui-validation.md)**
- **[015 - Error Handling](docs/015-Error-Handling.md)**
- **[ # 016 — Logging](docs/016-logging.md)**
- **[017 - Client / Server Responsibility Boundaries](docs/017-Clien-Server-Responsibility- Boundaries.md)**
- **[018 – Service Registration and Module Startup](docs/018-service-registration.md)**
- **[Localization in Oqtane Modules](docs/019-Localization.md)**
- **[Packaging and External Dependencies in Oqtane Modules](docs/020-packaging-and-dependencies.md)**

### 🔄 Migration and Updates

- **[26 — Applying the Playbook to Existing Oqtane Projects](docs/026-existing-projects.md)**

### 🤖 AI Governance

- **[AI Governance](docs/027-ai-governance.md)**
- **[Repository Structure](docs/028-repository-structure.md)**
- **[Templates and Stubs](docs/029-templates-and-stubs.md)**
- **[Canonical Reference Implementation](docs/030-canonical-reference.md)**
- **[Canonical Module Overview](docs/031-canonical-module-overview.md)**
- **[Canonical Diff Policy](docs/032-canonical-diff-policy.md)**
- **[Canonical Verification Checklist](docs/034-canonical-verification-checklist.md)**

### ✅ Conclusion

- **[100 — From Personal Discipline to Community Standard](docs/100-conclusion.md)**

### 📚 Additional Resources

- **[ ## Oqtane Philosophy](docs/00x-playbook-foundations.md)**
- **[10 — Services: Contracts, Boundaries, and Responsibility](docs/010-services.md)**
- **[11 — Authorization: Roles, Permissions, and Enforcement](docs/011-authorization.md)**
- **[12 — Database Migrations: Startup Execution, Versioning, and Multi-Database Safety](docs/012-migrations.md)**
- **[13 — Scheduled Jobs: Framework-Managed Background Work](docs/013-scheduled-jobs.md)**
- **[014 — UI Validation](docs/014-ui-validation.md)**
- **[015 - Error Handling](docs/015-Error-Handling.md)**
- **[ # 016 — Logging](docs/016-logging.md)**
- **[017 - Client / Server Responsibility Boundaries](docs/017-Clien-Server-Responsibility- Boundaries.md)**
- **[018 – Service Registration and Module Startup](docs/018-service-registration.md)**
- **[Localization in Oqtane Modules](docs/019-Localization.md)**
- **[Packaging and External Dependencies in Oqtane Modules](docs/020-packaging-and-dependencies.md)**
- **[26 — Applying the Playbook to Existing Oqtane Projects](docs/026-existing-projects.md)**
- **[AI Governance](docs/027-ai-governance.md)**
- **[Repository Structure](docs/028-repository-structure.md)**
- **[Templates and Stubs](docs/029-templates-and-stubs.md)**
- **[Canonical Reference Implementation](docs/030-canonical-reference.md)**
- **[Canonical Module Overview](docs/031-canonical-module-overview.md)**
- **[Canonical Diff Policy](docs/032-canonical-diff-policy.md)**
- **[Canonical Verification Checklist](docs/034-canonical-verification-checklist.md)**
- **[100 — From Personal Discipline to Community Standard](docs/100-conclusion.md)**
- **[Governance Rule Proposals (GRP)](docs/governance-rule-proposals.md)**

---

## 🔑 Key Concepts

### Governance Model
This repository follows a three-layer governance hierarchy:

1. **Authoring Layer** - The Oqtane AI Playbook defines governance rules, patterns, and constraints
2. **Reference Layer** - Playbook.Module.GovernedExample demonstrates implementation in practice  
3. **Application Layer** - Real modules build features by following the example module

### Authority Order
When conflicts arise, authority is resolved in this order:
1. Canonical reference module
2. Playbook documentation (`/docs`)
3. Oqtane framework constraints
4. AI-generated output (always last)

### Required Files for AI Governance
When adopting this playbook, the following files must exist and be visible to AI tools:
```
.github/
├── copilot-instructions.md

docs/
├── governance/
│   ├── 027-rules-index.md
│   └── 027x-*.md (rule files)
├── ai-decision-timeline.md
└── deviations.md
```

---

## 🤖 Auto-Generation Info

This `index.md` file is **automatically generated** by GitHub Actions whenever:
- Files in the `docs/` directory change
- Root markdown files change  
- Workflow is manually triggered

**⚠️ Do not manually edit this file** - your changes will be overwritten.

To update the index, modify the source files or edit the workflow in `.github/workflows/auto-index.yml`.

---

## 🚦 Quick Start

1. **Read the documentation** - Start with the numbered narrative in `/docs`
2. **Use as governance** - Reference in reviews and anchor AI tools to these rules
3. **Adopt incrementally** - Apply to new code first, align old code when touched

---

## 🛡️ Critical Rules

- **Never reference this playbook directly in module code**
- **Treat violations as hard failures, not suggestions**
- **AI must follow documented Oqtane patterns exactly**
- **Never introduce generic ASP.NET Core patterns without explicit reason**
- **Always validate against the canonical reference module**

---

## ℹ️ About

This repository exists because most Oqtane module failures are caused by:
- Generic .NET Core assumptions
- Hidden framework invariants  
- Multi-tenant misunderstandings
- AI-generated code that looks right but violates Oqtane rules
- Tribal knowledge that isn't written down

By making these rules explicit and enforceable, AI becomes a productivity multiplier rather than a risk amplifier.

---

## 🤝 Community

Contributions are welcome in the form of:
- Clarifications
- Corrections  
- Edge cases
- Additional chapters
- Real-world failures and lessons learned

The goal is **shared understanding**, not personal ownership.

---

*Frameworks don't fail. Tools don't fail. Developers don't fail. **Unspoken rules fail.***

This repository exists to speak them out loud.
