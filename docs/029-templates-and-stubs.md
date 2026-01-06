# Templates and Stubs

## Purpose

This document defines how **templates, stubs, and scaffolding** are used in this ecosystem.

Templates exist to **accelerate compliance**, not to reduce rigor.

---

## Definition

- **Template**: A reusable starting structure
- **Stub**: Minimal placeholder code
- **Scaffold**: Generated code produced by tools or AI

All three are treated the same under these rules.

---

## Canonical Derivation Rule

All templates and stubs:

- Must be derived from the canonical reference module
- Must preserve canonical structure
- Must not omit required patterns
- Must not introduce alternative designs

If a template differs from the canonical reference, the template is wrong.

---

## What Templates May Contain

Templates MAY include:

- Folder and project structure
- Required base classes
- Empty service implementations
- Placeholder UI components
- Minimal migrations
- Required wiring code

Templates MUST remain intentionally incomplete.

---

## What Templates Must Not Do

Templates MUST NOT:

- Add optional features
- Add convenience abstractions
- Hide validation or authorization
- Remove logging
- Simplify service boundaries
- Invent defaults

Templates should force developers to **make decisions**, not avoid them.

---

## AI-Generated Scaffolds

AI-generated scaffolds:

- Are treated as templates
- Must pass the canonical verification checklist
- Must be reviewed line by line
- Have no special status

If AI scaffolding fails compliance, it is discarded.

---

## Updating Templates

When the canonical reference changes:

1. Canonical module is updated first
2. Templates are updated second
3. Existing projects are not auto-modified

Templates follow the reference — never the reverse.

---

## Templates Are Not Documentation

Templates do not explain *why*.
They only demonstrate *how*.

Documentation lives in `/docs`.
Authority lives in `/docs/reference`.

---

## Enforcement Statement

Templates are accelerators, not shortcuts.

Any template that violates canonical rules undermines the entire system and must be fixed or removed.

---
