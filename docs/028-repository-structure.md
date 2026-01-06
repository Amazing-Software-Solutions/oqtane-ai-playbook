# Repository Structure

## Purpose

This document explains the **intentional structure** of this repository and the meaning of its organization.

This repository is not a traditional documentation site.
It is a **governance and reference system**.

---

## High-Level Layout

/docs/
000-preface.md
001-problem.md
002-insight.md
003-scope-and-boundaries.md
010-.md
020-.md
030-*.md
100-conclusion.md

/docs/reference/canonical-module/  
  
Each section has a specific role.

---

## Numbering Is Semantic

File numbering is **intentional and semantic**, not sequential.

Ranges indicate purpose:

### 000–009: Foundation
- Context
- Problem statement
- Scope
- Boundaries

### 010–025: Framework Rules
- Services
- Authorization
- Migrations
- UI validation
- Logging
- Scheduled jobs

These define *how Oqtane modules must be built*.

### 026–029: Application & Governance
- Applying rules to existing projects
- AI governance
- Repository structure
- Templates and stubs

These define *how the rules are used*.

### 030–039: Canonical Reference
- Canonical module
- Diff policy
- Verification checklist

These define *what is authoritative*.

### 100+: Closure
- Conclusions
- Final guidance

---

## Ordering Rules

- Files must **not** be renumbered
- Files must **not** be reordered
- New documents must fit an existing range
- Gaps are intentional and allowed

Renumbering breaks semantic meaning and is prohibited.

---

## `/docs/reference/canonical-module`

This folder contains the **canonical reference implementation**.

Rules:
- It is not a sample
- It is not a demo
- It is not optimized
- It is authoritative

Everything else in the repository defers to this module.

---

## Why This Structure Exists

This structure:

- Prevents accidental drift
- Makes AI grounding deterministic
- Separates rules from examples
- Scales as the repository grows
- Enables mechanical validation

The structure is part of the system, not a convenience.

---
