# 005 — Oqtane Development Environment Setup

## Purpose

This document defines the **canonical local development layout** for working with
AI-governed Oqtane modules.

It explicitly distinguishes between:

- **Governance authoring**
- **Reference implementation**
- **Real application development**

Only the **reference implementation** is consumed by real modules.

This separation is intentional and required to preserve trust, clarity, and governance integrity.

---

## Canonical Development Root

All development is performed under a single local root folder:

D:\Oqtane Development\

This root folder:

- Is **not** a Git repository
- Exists purely as a local workspace boundary
- Contains multiple independent repositories as siblings
- Does **not** imply coupling between those repositories

Each child folder manages its own source control independently.

---

## Oqtane Framework Setup

### Step 1 — Obtain the Oqtane Framework

Download the Oqtane Framework source distribution.

### Step 2 — Extract the Framework

Extract the framework to:

D:\Oqtane Development\Oqtane.Framework

### Expected Structure

Oqtane.Framework/
├── Oqtane.Client
├── Oqtane.Server
├── Oqtane.Shared
├── Oqtane.Infrastructure
├── Oqtane.Package
└── solution and build files

The Oqtane Framework:

- Is the **runtime authority**
- Defines canonical platform behavior
- Is **not governed** by the AI Playbook
- Is **not modified** to support AI tooling

---

## Oqtane AI Playbook (Authoring Layer)

### Purpose

The **Oqtane AI Playbook** is the **governance authoring repository**.

It is used by:

- Playbook authors
- Governance maintainers
- Pattern designers

It defines:

- Governance rules
- Architectural constraints
- AI behavior expectations
- Reference implementations

It is **not** consumed directly by real modules.

### Placement

D:\Oqtane Development\oqtane-ai-playbook

### Important

- Real modules must **not** reference the Oqtane AI Playbook directly
- Copilot does **not** rely on this repository at runtime
- This repository exists to **design and evolve governance**, not to apply it

---

## Module-Playbook-Example (Reference Layer)

### Purpose

The **Module-Playbook-Example** is the **only canonical reference**
that real Oqtane modules should consume.

It lives **inside** the Oqtane AI Playbook repository and provides a
concrete, working, governed implementation.

It contains:

- Enforced governance rules
- Canonical Copilot instructions
- Prompt templates
- UI, service, and architecture examples

### Placement

D:\Oqtane Development\oqtane-ai-playbook\module-playbook-example

### Role

- Stable
- Referenceable
- Designed to be *copied from conceptually*, not modified
- The bridge between governance theory and real-world application

---

## Real Module Development (Application Layer)

### Real-World Governed Example

A real-world governed example module lives **alongside the framework**:

D:\Oqtane Development\Playbook.Module.GovernedExample

This module behaves exactly like a production module:

- It references the **Module-Playbook-Example**
- It does **not** reference the Oqtane AI Playbook
- It owns its own decisions and deviations
- It validates that governance works outside the authoring environment

This separation is intentional and required.

---

### Real Modules Must

Real modules (e.g. `YourCompany.Module.X`) must:

- Reference **Module-Playbook-Example**
- Physically own:
  - `docs/ai-decision-timeline.md`
  - `docs/deviations.md`
- Optionally extend AI behavior via:
  - `.github/module-instructions.md`

They must **not**:

- Reference the Oqtane AI Playbook directly
- Copy governance rules into the module
- Replace canonical Copilot instructions

---

## Verification Checklist

Before starting module development, verify:

- [ ] `Oqtane.Framework` builds successfully
- [ ] `oqtane-ai-playbook` is available for governance reference
- [ ] `module-playbook-example` exists and is readable
- [ ] The module references the reference layer, not the authoring layer
- [ ] Decision and deviation logs are physically owned by the module

If any item fails, **stop and correct the setup**.

---

## Summary

Oqtane.Framework → Runtime authority
oqtane-ai-playbook → Governance authoring
module-playbook-example → Reference implementation
Playbook.Module.GovernedExample → Real application

Only the **reference implementation** is consumed by real modules.

This structure preserves trust, prevents drift, and ensures AI behavior
remains deterministic, auditable, and cost-efficient.