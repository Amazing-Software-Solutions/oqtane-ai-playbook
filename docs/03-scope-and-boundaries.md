# 03 — Scope and Boundaries

This chapter defines **what this playbook governs**, **what it explicitly does not**, and **where responsibility begins and ends**.

These boundaries are intentional.  
They exist to prevent misapplication, overreach, and the accidental rewriting of Oqtane itself.

---

## Purpose of This Chapter

Without clear boundaries:

- Rules get applied where they don’t belong
- Guidance turns into dogma
- AI tools extrapolate beyond intent
- Teams waste time debating scope instead of building software

This chapter exists to make the limits explicit.

---

## What This Playbook Governs

This playbook governs **custom Oqtane module development**, specifically:

- Module architecture and structure
- Client / Server / Shared boundaries
- Authorization and permission usage
- Database migrations
- Scheduled jobs
- Validation, error handling, and logging *within modules*
- Safe use of AI tools when generating module code

It applies to:
- Custom modules
- Internal line-of-business modules
- Community modules
- Greenfield and existing projects

---

## What This Playbook Does *Not* Govern

This playbook does **not** govern:

- The Oqtane framework itself
- Core Oqtane platform code
- Oqtane internal services or repositories
- Third-party libraries
- UI/UX design or styling
- Business rules or domain modeling
- Testing frameworks or test strategies (unless explicitly stated)

Framework behavior always overrides guidance in this repository.

---

## Boundary: Framework vs Module

A fundamental rule:

> **Modules adapt to the framework.  
> The framework does not adapt to modules.**

This means:

- Framework lifecycle is not negotiable
- Framework-owned services must not be replaced
- Framework patterns must not be bypassed
- Framework execution models must not be reimplemented

If a rule in this guide conflicts with actual Oqtane behavior, the guide is wrong.

---

## Boundary: Architecture vs Style

This playbook focuses on **architecture**, not style.

It defines:
- Required base classes
- Required execution models
- Required separation of concerns
- Required enforcement points

It does *not* define:
- Naming conventions beyond structural necessity
- Formatting rules
- UI composition patterns
- Code aesthetics

Style is a team concern.  
Architecture is a framework concern.

---

## Boundary: Enforcement vs Guidance

Not all content in this repository has equal weight.

### Hard Rules
- Located primarily in `10–25`
- Describe framework invariants
- Must be followed exactly
- Violations should be rejected

### Guidance
- Located primarily in `26–99`
- Describe safe practices
- Allow contextual judgment
- May evolve over time

Treating guidance as law is as harmful as ignoring hard rules.

---

## Boundary: New Code vs Existing Code

This playbook is **forward-looking by design**.

It does not require:
- Immediate refactoring
- Retrofitting legacy code
- Perfect historical alignment

The intent is:

- Prevent new violations
- Reduce future risk
- Allow convergence over time

Existing code is tolerated.  
New code is governed.

---

## Boundary: AI Responsibility

AI tools are **assistants**, not authorities.

This playbook exists to:

- Constrain AI output
- Prevent invented structure
- Anchor generation to real framework behavior

AI must:
- Follow explicit rules
- Copy known-good patterns
- Reject invalid structures

AI must not:
- Infer alternative architectures
- Generalize from non-Oqtane frameworks
- Optimize away required constraints

Responsibility always remains with the developer.

---

## Boundary: This Guide vs Official Documentation

This guide complements official Oqtane documentation.

It does not replace it.

Use:
- Official documentation for API reference and features
- This playbook for architectural correctness and safety

If in doubt, consult the framework source.

---

## Explicit Non-Goals

This playbook does not attempt to:

- Simplify Oqtane
- Hide its complexity
- Make it “feel like” another framework
- Optimize for minimal code
- Provide shortcuts around framework rules

Correctness is prioritized over convenience.

---

## Why These Boundaries Matter

Clear boundaries:

- Reduce debate
- Improve consistency
- Prevent misuse
- Make AI tooling viable
- Protect framework integrity

Most architectural failures occur not from bad rules, but from **unclear scope**.

---

## Summary

This playbook:

- Governs module architecture
- Respects framework authority
- Separates rules from guidance
- Prioritizes correctness over convenience
- Enables safe AI-assisted development

Everything that follows operates **within these boundaries**.

Any content that violates them should be challenged or corrected.
