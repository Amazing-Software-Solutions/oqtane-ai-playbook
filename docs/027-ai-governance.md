# AI Governance

## Purpose

This document defines how AI tools are **allowed, constrained, and evaluated** when used in Oqtane module development.

AI is treated as a **code generation assistant**, not a designer, architect, or decision-maker.

This repository prioritizes **predictability and correctness** over novelty or speed.

---

## Core Principle

> AI may generate code, but it may not define rules.

All architectural decisions, patterns, and constraints are defined **outside** AI systems and enforced **against** their output.

---

## Allowed Uses of AI

AI tools MAY be used to:

- Generate boilerplate that follows canonical patterns
- Fill in repetitive or mechanical code
- Expand existing patterns already defined in this repository
- Assist with refactoring **when behavior is preserved**
- Help explain or summarize existing code

AI output is always treated as **untrusted until verified**.

---

## Prohibited Uses of AI

AI tools MUST NOT be used to:

- Invent new architectural patterns
- Simplify or bypass enforcement logic
- Replace explicit code with abstractions
- Introduce role-based authorization
- Introduce routing via `@page` in modules
- Remove validation, logging, or error handling
- Make “best practice” substitutions without reference

If AI output introduces something not explicitly allowed by this repository, it is rejected.

---

## Canonical Authority Hierarchy

When AI produces output, authority is resolved in this order:

1. Canonical reference implementation
2. Repository rules and guides
3. Oqtane framework constraints
4. AI output

AI always ranks last.

---

## AI Rejection Rules

AI-generated output must be **rejected immediately** if it:

- Violates canonical structure
- Uses non-canonical patterns
- Removes explicit enforcement
- Introduces ambiguity
- Assumes intent
- Adds convenience at the cost of rigor

Correction is optional.
Rejection is mandatory.

---

## Review Expectations

AI-generated code is reviewed as if written by:
- A junior developer
- With no domain context
- And no authority to decide architecture

The burden of proof is on the output, not the reviewer.

---

## AI Is Stateless

AI has:
- No memory
- No long-term context
- No responsibility for consequences

Therefore:
- All rules must be explicit
- All patterns must be visible
- All constraints must be enforceable in code

---

## Enforcement Statement

AI governance is not advisory.

Failure to comply invalidates the output regardless of correctness elsewhere.

AI exists to **reduce effort**, not **reduce discipline**.

---
