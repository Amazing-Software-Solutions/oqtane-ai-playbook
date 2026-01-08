# 006 – Module Adoption (Existing Modules)

## Purpose

This document defines how an **existing Oqtane module*- is brought under the governance of the **Oqtane AI Playbook*- safely and incrementally.

The goal is **predictability and control**, not immediate conformity.

This process is intentionally designed to:
- Avoid breaking working code
- Prevent uncontrolled AI refactors
- Make architectural intent explicit
- Establish long-term governance without churn

---

## Core Principle

> **Structure is frozen. Rules are enforced forward.**

Existing modules are not rewritten to “match” the playbook.
They are **brought under governance**, not rebuilt.

---

## When to Use This Document

Use this document when:

- A module already exists
- The module is stable or in production
- AI tools (Copilot, ChatGPT, etc.) will be introduced or expanded
- Architectural drift must be controlled going forward

If you are creating a **brand-new module**, use `005-setup.md` first, then follow canonical patterns directly.

---

## Step 1 — Confirm Environment Setup

Before adopting governance at the module level:

- `005-setup.md` **must already be complete**
- The playbook repository must exist outside the module
- No AI rules should be inferred or improvised

If environment setup is incomplete, **stop*- and fix that first.

---

## Step 2 — Freeze the Existing Module Structure

The existing module’s structure is treated as **historical fact**.

### Explicitly Do Not:
- Rename folders
- Reorganize projects
- “Normalize” architecture
- Introduce abstractions
- Apply canonical patterns retroactively

The only allowed structural changes are those required for:
- New features
- Bug fixes
- Security corrections

Everything else is deferred.

---

## Step 3 — Add Local Governance Hooks

Inside the module repository, add a minimal governance footprint.

### Required Files
```
.github/
└── copilot-instructions.md

docs/
├── deviations.md
└── ai-decision-timeline.md
```
These files **do not replace*- the playbook.
They **reference and anchor it**.

---

### Making Governance Files Visible to AI (Required)

AI governance only works if the governing files are **visible to the AI tool**.

Merely having files on disk is not sufficient.

#### Required Files

Every module adopting this playbook MUST contain or reference:

```
.github/
└── copilot-instructions.md

docs/
├── deviations.md
└── ai-decision-timeline.md
```

#### Visual Studio Requirement

When using Visual Studio:

- The `docs/` folder **must appear in the solution**
- `ai-decision-timeline.md` **must be visible and readable**
- `.github/copilot-instructions.md` **must be visible**

If these files do not appear in Solution Explorer, Copilot **cannot read them**.

> 
> 
> A file existing on disk but missing from the solution is invisible to AI.
> 

---

### Verification Step (Mandatory)

Before using AI in the module, perform this check:

1. Open the module solution in Visual Studio
2. Confirm the following are visible:

    - `.github/copilot-instructions.md`
    - `docs/ai-decision-timeline.md`
3. Ask Copilot:

> 
> 
> “Summarize the non-negotiable rules you must follow in this repository.”
>

If Copilot cannot answer accurately, **stop**.

Governance is not active.

---

### AI Decision Timeline Enforcement

Once visible:

- Copilot is **authorized and expected*- to append entries to

`docs/ai-decision-timeline.md`
- Timeline entries are:

    - Append-only
    - Canonical
    - Binding governance memory

Failure to write timeline entries indicates **broken adoption**, not an AI issue.

---

### Common Failure Mode (Documented)

**Symptom**

Copilot refuses to write timeline entries or claims the file is missing.

**Cause**

The `docs/` folder is not visible in the solution.

**Resolution**

Add the folder to the solution and re-issue the request.

This failure mode is now **known, documented, and preventable**.

---
## Step 4 — Copilot Instructions (Module-Level)

The module-level `.github/copilot-instructions.md` must:

- Reference the external Oqtane AI Playbook
- Declare that playbook rules override AI output
- State that existing structure is frozen
- Require deviations to be documented
- Require timeline entries for significant AI-assisted changes

This file contains **constraints**, not patterns.

---

## Step 5 — Deviations Documentation

Create `docs/deviations.md`.

This file records **known and accepted deviations*- from canonical rules.

### What Belongs Here

- Legacy patterns that cannot be changed safely
- Framework-era constraints
- Transitional compromises
- Explicit “we know this is not canonical” decisions

### What Does NOT Belong Here

- New violations
- AI-suggested shortcuts
- Convenience refactors
- Unreviewed changes

If something is not documented here, it is assumed to be **unintentional**.

---

## Step 6 — AI Decision Timeline

Create `docs/ai-decision-timeline.md`.

This file records **AI-assisted decisions that affect behavior, structure, or policy**.

### Timeline Entries Should Include

- Date and time
- What was changed
- Why the change was necessary
- Which rule or document governed the decision

This file exists to:
- Prevent repeated mistakes
- Anchor institutional memory
- Reduce future AI back-and-forth
- Make reasoning reviewable

AI must be instructed to **check the timeline before responding**.

---

## Step 7 — Enforcement Going Forward

From this point forward:

- New code **must follow*- playbook rules
- AI output is **untrusted by default**
- Violations are rejected, not debated
- Deviations require documentation
- Timeline entries are encouraged for non-trivial fixes

Old code remains untouched **until modified**.

---

## What Adoption Does NOT Require

Adoption does **not*- require:

- Immediate refactoring
- Canonical rewrites
- Migration changes
- Service re-registration
- Permission redesign
- UI rework

Governance is applied **over time**, not retroactively.

---

## Mental Model

- The playbook defines **how things should be**
- The module shows **how things are**
- Deviations explain **why they differ**
- The timeline explains **how decisions were made**

This creates clarity without disruption.

---

## Summary

- Existing modules are adopted, not rebuilt
- Structure is frozen; rules apply forward
- AI is constrained before it is trusted
- Deviations are explicit, not hidden
- Decisions are recorded, not forgotten

This is how AI becomes a **force multiplier**, not a liability.