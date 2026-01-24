# Canonical Reference Implementation

## Purpose

This repository establishes a **single canonical reference implementation** for Oqtane module development.

The purpose of this reference is to eliminate ambiguity, drift, and accidental divergence in:
- Architecture
- Service boundaries
- Authorization
- Validation
- Logging
- Error handling
- AI-assisted generation

This document formally defines what “canonical” means in this repository and how it must be treated by humans and AI tooling.

---

## Definition of Canonical

In this repository, **canonical** means:

> The authoritative, normative, and enforced source of truth.

The canonical reference implementation represents:
- The **correct structure**
- The **expected patterns**
- The **approved conventions**
- The **validated integration points**

If multiple approaches exist in the Oqtane ecosystem, the canonical reference selects **one** and makes it definitive for this repository.

---

## Location of the Canonical Reference

The canonical reference implementation lives at:

/docs/reference/canonical-module/


This module is:
- Complete
- Functional
- Intentionally minimal
- Actively maintained

It is **not** a sample, demo, or tutorial.

---

## Scope of the Canonical Reference

The canonical reference **defines**:

- Module folder and project structure
- Client / Server responsibility boundaries
- Service and repository patterns
- Authorization and permission checks
- UI validation and form handling
- Error handling strategy
- Logging (client and server)
- Scheduled job patterns
- Migration and upgrade expectations
- Safe defaults for multi-tenant behavior

The canonical reference **does not attempt to**:
- Cover every possible feature
- Optimize for edge cases
- Demonstrate advanced customization
- Replace Oqtane core documentation

---

## Authority Rules

The following rules apply **without exception**:

1. Any new module, template, scaffold, or example **must align** with the canonical reference.
2. If documentation conflicts with the canonical reference, the canonical reference **wins**.
3. If AI-generated code conflicts with the canonical reference, the output **must be rejected**.
4. If an existing project deviates, the deviation **must be intentional and documented**.

This repository treats the canonical reference as **law**, not guidance.

---

## AI Usage Contract

All AI tools (including GitHub AI assistant, ChatGPT, MCP-based systems, or similar) must adhere to the following contract:

- The canonical reference is the **primary grounding source**
- AI may not invent alternative patterns when a canonical one exists
- AI must reject outputs that violate canonical structure or rules
- AI must treat the reference as **non-negotiable**

Any AI instruction set in this repository implicitly inherits this contract.

---

## Templates, Stubs, and Scaffolding

Templates, stubs, and scaffolding tools:

- **Derive from** the canonical reference
- **Do not redefine** architecture
- **Do not simplify away** required patterns
- **Must stay in sync** with the canonical reference

If a template and the canonical reference diverge, the template is wrong.

---

## Change Control

Changes to the canonical reference are:
- Intentional
- Explicit
- Reviewed
- Rare

The canonical reference evolves **only** when:
- Oqtane itself introduces structural changes
- A pattern is proven incorrect or unsafe
- The community reaches clear consensus

Incremental convenience changes do **not** justify modification.

---

## Intentional Deviations

Projects may deviate from the canonical reference **only if**:

- The deviation is intentional
- The reason is documented
- The trade-offs are understood

Undocumented deviation is treated as an error, not a choice.

---

## Closing Statement

The canonical reference exists to create **confidence**.

Confidence that:
- Modules are built consistently
- AI assistance is predictable
- Architectural decisions are deliberate
- The community speaks a shared language

This document is the anchor point for everything that follows.

---
