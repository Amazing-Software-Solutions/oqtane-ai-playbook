# Governance Rule Proposals (GRP)

## Purpose

This document defines the **only allowed process** for introducing new governance rules into the Oqtane AI Playbook.

Rules are **not invented**, **not improvised**, and **not added by opinion**.

All governance changes must be:
- Traceable
- Justified by failure or invariant
- Explicitly accepted or rejected

This process prevents governance drift.

---

## What Is a Governance Rule Proposal?

A Governance Rule Proposal (GRP) is a **formal evaluation record** that determines whether a discovered invariant should become a **binding rule**.

A GRP does **not** introduce code.
A GRP does **not** modify behavior.
A GRP only decides whether a rule should exist.

---

## When a GRP Is Required

A proposal MUST be created when:

- An AI Decision Timeline entry reveals a repeated failure pattern
- An Oqtane framework invariant was rediscovered
- AI consistently makes the same incorrect assumption
- A rule is being added to 027-ai-governance.md

If no GRP exists, the rule MUST NOT be added.

---

## Canonical Proposal Format

```md
### GRP-XXX — Short Rule Name

**Origin**  
Reference to AI Decision Timeline entry (date + title).

**Problem Statement**  
What behavior keeps occurring that should not.

**Invariant Discovered**  
The architectural or framework truth that was violated.

**Proposed Rule**  
The exact rule to be enforced (precise, testable, non-interpretive).

**Scope**  
Which modules or contexts this rule applies to.

**Risk of Adoption**  
Low / Medium / High — and why.

**Decision**  
Accepted → Integrated into 027-ai-governance.md  
Rejected → Remains historical only
```