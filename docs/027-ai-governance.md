# AI Governance

## Purpose

This document defines **how AI is governed** within Oqtane module development.

It does **not** define subsystem rules.
It defines **authority, enforcement, and rejection mechanics**.

AI is treated as a **code generation assistant**, not an architect,
designer, or decision-maker.

---

## Core Principle

> **AI may generate code, but it may not define rules.**

All architectural decisions, constraints, and patterns are defined
outside AI systems and enforced *against* their output.

---

## Authority Hierarchy

When evaluating AI output, authority is resolved in this order:

1. Canonical reference implementations  
2. Rule reference documents (`027-*`)
3. Repository governance documents
4. Oqtane framework constraints
5. AI-generated output

**AI always ranks last.**

---

## Rule-Based Governance Model

This repository uses a **rule reference model**.

- `027-rules-index.md` defines *what rules exist*
- `027x-*` documents define *enforceable rules*

AI must **discover and apply relevant rule documents**
before generating or modifying code.

---

## Mandatory Rule Discovery

Before responding to any request, AI must:

1. Identify which technical domains the request touches
2. Locate applicable rule documents via `027-rules-index.md`
3. Validate output against those rules

Failure to perform rule discovery invalidates the output.

---

## AI Rejection Mandate

AI-generated output **must be rejected immediately** if it:

- Violates a rule reference document
- Introduces non-canonical patterns
- Assumes architectural authority
- Bypasses enforcement logic
- Introduces ambiguity or convenience abstractions

Correction is optional.  
**Rejection is mandatory.**

---

## Review Expectations

AI output is reviewed as if written by:

- A junior developer
- With no domain context
- With no authority to make architectural decisions

The burden of proof lies with the output, not the reviewer.

---

## AI Is Stateless

AI has:
- No memory
- No responsibility
- No awareness of consequences

Therefore:
- All rules must be explicit
- All constraints must be visible
- All enforcement must be codified

---

## Enforcement Statement

- Governance is not advisory
- Correctness does not override compliance
- Discipline outranks convenience
- AI exists to reduce effort, **not standards**

Any violation invalidates the output.
