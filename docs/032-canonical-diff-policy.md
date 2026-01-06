# Canonical Diff Policy

## Purpose of This Document

This document defines **how changes to the canonical module are evaluated, accepted, or rejected**.

The goal is not velocity.
The goal is **stability, authority, and trust**.

The canonical module must evolve **slowly and deliberately**.

---

## Core Principle

> **The canonical module is a reference, not a roadmap.**

Any change must preserve its role as a **stable baseline**, not a showcase of new ideas.

---

## Change Categories

All proposed changes fall into one of the following categories.

### 1. Clarifying Changes (Allowed)

Changes that improve clarity **without altering behavior** are allowed.

Examples:
- Renaming variables for clarity
- Adding comments
- Improving formatting
- Removing ambiguity
- Aligning naming with Oqtane conventions

**Rule**: If behavior is identical, the change is eligible.

---

### 2. Corrective Changes (Allowed)

Changes that fix **demonstrable correctness issues** are allowed.

Examples:
- Fixing broken authorization checks
- Correcting logging misuse
- Fixing invalid lifecycle usage
- Addressing real bugs

**Rule**: The issue must be observable, reproducible, and defensible.

---

### 3. Alignment Changes (Conditionally Allowed)

Changes required to stay aligned with **upstream Oqtane evolution** may be accepted.

Examples:
- API deprecations
- Required framework updates
- Security-related changes

**Rule**: The change must be **necessary**, not optional.

---

### 4. Convenience Changes (Rejected)

Changes that make development easier **but reduce rigor** are rejected.

Examples:
- Removing boilerplate
- Collapsing layers
- Short-circuiting validation
- Introducing helper abstractions that hide rules

Convenience is not a justification.

---

### 5. Feature Additions (Rejected)

New features are **never** added to the canonical module.

Examples:
- New UI components
- New workflows
- New configuration options
- Optional behaviors

The canonical module demonstrates *how*, not *what*.

---

### 6. Optimization Changes (Rejected)

Performance improvements are rejected unless correctness is impacted.

Examples:
- Caching
- Async micro-optimizations
- Reduced allocations
- Query tuning

Optimizations belong in real modules, not the reference.

---

### 7. Opinionated Style Changes (Rejected)

Personal preferences are not a basis for change.

Examples:
- Formatting styles
- Alternative patterns
- Different dependency injection approaches
- Rewriting “because I prefer it”

Preference is not policy.

---

## Decision Criteria Checklist

Every proposed change must answer **YES** to all of the following:

1. Does this preserve architectural boundaries?
2. Does this preserve enforcement strictness?
3. Does this preserve readability for humans?
4. Does this preserve predictability for AI?
5. Can this be defended six months from now?

If any answer is **NO**, the change is rejected.

---

## AI-Specific Guardrail

AI-generated changes must be treated with **higher scrutiny**.

Additional requirements:
- No inferred intent
- No “best practice” substitutions
- No pattern generalization
- No removal of explicit code

If AI suggests a change that removes code, the default answer is **NO**.

---

## Diff Review Expectations

When reviewing a diff against the canonical module:

- Assume the existing code is correct
- Require proof before accepting change
- Prefer explicitness over elegance
- Reject cleverness

Silence is not approval.
Small diffs are not safer by default.

---

## Versioning Policy

The canonical module version changes only when:

- A corrective or alignment change is merged
- The change meaningfully affects interpretation

Version increments are **intentional and rare**.

---

## Enforcement

This policy is not advisory.

Violations invalidate the canonical reference and must be reverted immediately.

---

## Final Authority

If there is disagreement:

- This policy wins
- The canonical module wins
- Consistency wins

The reference exists to **end arguments**, not start them.

---
