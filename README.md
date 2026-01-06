# Oqtane Module Development Playbook

A practical, framework-aware guide for building **robust, upgrade-safe Oqtane modules*- — with or without AI assistance.

This repository exists to make Oqtane’s **implicit architectural rules explicit**, enforceable, and shareable.

---

## Why This Exists

Oqtane is a powerful, flexible framework — but its correctness depends heavily on **structure, conventions, and lifecycle ownership**.

Many failures in Oqtane modules are not caused by bad intent or lack of skill, but by:

- Borrowed patterns from generic ASP.NET Core
- Assumptions that don’t hold in a multi-tenant system
- AI-generated code that *looks right- but violates framework invariants
- Rules that exist only as tribal knowledge

This playbook captures those rules in a form that both **humans and AI tools can follow**.

---

## What This Is (and Is Not)

### This *is*:
- A framework-specific guide grounded in real Oqtane behavior
- A set of **rejectable rules**, not vague best practices
- A way to regain control when using AI tools like GitHub Copilot
- A living document intended to evolve with community input

### This is *not*:
- A beginner tutorial
- A replacement for official Oqtane documentation
- A style guide or opinionated rewrite of Oqtane
- A claim of authority over the framework

---

## Who This Is For

This repository is useful if you:

- Build custom Oqtane modules
- Maintain multiple Oqtane solutions
- Use (or want to use) AI code generation safely
- Have been burned by migrations, permissions, or scheduled jobs
- Want predictable, reviewable module code

You do **not*- need to agree with everything here to benefit from it.

---

## How to Use This Repository

### 1. Read the Chapters
The `/docs` folder contains a structured narrative:

1. The problem
2. The insight
3. Architectural boundaries
4. Services
5. Authorization
6. Migrations
7. Scheduled jobs
8. Applying rules to existing projects
9. Conclusion

Each chapter builds on the previous one.

---

### 2. Use It as Governance

Most teams will get the most value by:

- Copying relevant rules into `.github/copilot-instructions.md`
- Referencing these documents in code reviews
- Anchoring AI tools to the defined constraints

This is where the playbook shines.

---

### 3. Adopt Incrementally

You do **not*- need to rewrite existing modules.

The recommended approach is:

- Freeze structure
- Enforce rules on new code
- Align old code only when touched

Governance over time beats perfection today.

---

## Recommended Repository Structure (Per Solution)

```text
.github/
└── copilot-instructions.md

docs/
├── deviations.md
└── architecture-notes.md
```
Use this playbook as a **central reference**, not something duplicated into every solution verbatim.

---

## About AI and Copilot

AI tools are powerful, but they:

- Optimize for plausibility
- Reuse familiar patterns
- Invent structure when uncertain

This repository exists to remove that uncertainty.

By providing:

- Structural stubs
- Hard rejection rules
- Framework-specific constraints

AI becomes a productivity multiplier instead of a risk amplifier.

---

## Community and Contributions

This repository is intentionally open to evolution.

Contributions are welcome in the form of:

- Clarifications
- Edge cases
- Corrections
- Additional chapters
- Real-world examples

The goal is **shared understanding**, not personal ownership.

---

## Status

This is a living document.

It reflects real-world Oqtane development experience and will continue to evolve as the framework and tooling evolve.

---

## Final Note

Frameworks don’t fail.
Tools don’t fail.
Developers don’t fail.

**Unspoken rules fail.**
This repository exists to speak them out loud.