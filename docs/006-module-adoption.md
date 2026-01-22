# 006 – Module Adoption (Existing Modules)

## Purpose

This document defines how an **existing Oqtane module** is brought under the governance of the **Oqtane AI Playbook** safely and incrementally.

The goal is **predictability and control**, not immediate conformity.

---

## Core Principle

> 
> **Structure is frozen. Rules are enforced forward.**
> 

Existing modules are not rewritten to “match” the playbook.

They are **brought under governance**, not rebuilt.

---

## When to Use This Document

Use this document when:

- A module already exists
- The module is stable or in production
- AI tools (Copilot, ChatGPT, etc.) will be introduced or expanded
- Architectural drift must be controlled

If you are creating a **brand-new module**, follow `005-setup.md` first.

---

## Step 1 — Confirm Global Environment Setup

Before adopting governance at the module level:

- `005-setup.md` **must already be complete**
- `Oqtane.Framework` exists locally
- `Oqtane-AI-Playbook` exists outside the module repository

If this is not true, **stop** and fix that first.

---

## Step 2 — Freeze the Existing Module Structure

The current module structure is treated as **historical fact**.

### Explicitly Do Not

- Rename folders
- Reorganize projects
- Normalize architecture
- Retroactively “fix” patterns
- Introduce abstractions

Only changes required for:

- New features
- Bug fixes
- Security issues

are allowed.

Everything else is deferred.

---

## Step 2.5 — Reference the Oqtane Framework (Mandatory)

> 
> **This step is required for AI governance to work correctly.**
> 

The module **must reference** the Oqtane framework projects so that:

- Canonical patterns are visible
- AI can validate against real framework behavior
- No duplicate “canonical module” is required

### Required Project References

Add **project references** to the following:

- `Oqtane.Client`
- `Oqtane.Server`
- `Oqtane.Shared`

These references are **read-only** and exist purely as a **canonical source of truth**.

### Build Configuration Requirement (Critical)

These framework projects:

- **Must NOT be built**
- **Must be disabled** in Configuration Manager
- **Must remain disabled** for Debug *and- Release

#### Why This Matters

- The module does not own the framework
- The framework is already built elsewhere
- These references exist for **inspection, validation, and AI grounding only**
- Building them introduces conflicts and slows adoption

> 
> **Think of these projects as “live documentation”, not dependencies.**
> 

This approach replaces the need to copy or embed a `canonical-module` inside every repo.

---

## Step 3 — Add Required Governance Structure (Mandatory)

Inside the **module repository**, create:

```
.github/
├── copilot-instructions.md		<- Referenced
└── module-instructions.md		

docs/
├── deviations.md
├── ai-decision-timeline.md
└── governance/					<- Referenced
    ├── 027-rules-index.md
    └── 027x-*.md
```

### Why This Structure Exists

| Path | Purpose |
| --- | --- |
| `.github/copilot-instructions.md` | Constrains AI behavior |
| `.github/module-instructions.md` | AI behavior Extended|
| `docs/deviations.md` | Declared rule exceptions |
| `docs/ai-decision-timeline.md` | Binding governance memory |
| `docs/governance/` | Enforceable rule set |

These files **anchor** the external playbook locally.

They do **not duplicate** it.

### Physical Location (Flexible)

The files may:

* Live inside the module repository **or**
* Be linked from a shared location (recommended)

**Do not copy unless you intend to fork governance.**

### How to Add (Visual Studio)

1. Right-click the solution
2. Add → Existing Item
3. Select the `.md` file
4. Place it under a `docs/` solution folder

⚠️ Creating empty folders alone **does not work**

⚠️ Files must exist and be solution-visible


---

## Step 4 — Visibility Requirement (Non-Negotiable)

> 
> A file that is not visible in the solution **does not exist to AI**.
> 

When using Visual Studio:

- `docs/` **must appear** in Solution Explorer
- All `.md` files must be visible
- `.github/copilot-instructions.md` must be visible

If they are not:

- Governance does not activate
- Timeline logging fails
- Copilot will refuse valid requests

This is a **confirmed invariant**, not a theory.

---

## Step 5 — Verify Governance Is Active

Before generating **any code**, ask Copilot:

> 
> **“Summarize the non-negotiable rules you must follow in this repository.”**
> 

If the answer does not reference:

- Governance files
- Rule enforcement
- Timeline behavior

**STOP.**

Governance is not active.

---

## Step 6 — Deviations File

Create `docs/deviations.md`.

This file must exist in the Module Solution

This records **intentional, known exceptions**.

If it’s not documented here, it’s assumed to be accidental.

---

## Step 7 — AI Decision Timeline (Mandatory)

Create `docs/ai-decision-timeline.md`.

This file must exist in the Module Solution

This file is:

- Append-only
- Binding
- Governance memory

AI must read this **before responding** and must propose entries when:

- A request is refused
- A framework invariant is discovered
- Multiple iterations were required

Failure to log is a **governance failure**, not an AI error.

---

## Step 8 — Enforcement Going Forward

From this point on:

- New code follows rules
- AI output is untrusted by default
- Violations are rejected
- Deviations are explicit
- Decisions are written down

Old code remains untouched **until modified**.

---

## Governance Instantiation (Required)

The playbook does not contain active governance files.

Each module MUST create its own governance instance.

At minimum, the module must contain:

```
docs/
├── governance/
│   ├── 027-rules-index.md
│   └── 027x-*.md
├── ai-decision-timeline.md
└── deviations.md
```

Only files present in the module repository and visible in the IDE
are considered valid governance context by AI tools.
---

## Mental Model

- **Oqtane Framework** = canonical truth
- **Playbook** = governance system
- **Rules** = enforceable constraints
- **Timeline** = institutional memory

This combination is what finally makes AI **predictable**.

---

## Governance Connectivity Check (Mandatory)

Once setup is complete, **before writing any code**, perform this check.

Ask Copilot **exactly this**:

> 
> **“Summarize the non-negotiable rules you must follow in this repository, and list the governance files you used to derive them.”**
> 

---

### Expected Response Characteristics

A **valid** response must:

1. Explicitly reference **file-backed governance**, such as:

    - `.github/copilot-instructions.md`
    - `docs/governance/027-rules-index.md`
    - One or more `027x-*` rule files
    - `docs/ai-decision-timeline.md`
2. State **enforcement behavior**, including:

    - Rejection of invalid requests
    - Preference for refusal over invention
    - Timeline consultation before non-trivial answers
3. Acknowledge **canonical validation**, via:

    - Oqtane Framework projects
    - Explicit reference to client/server/shared patterns

---

### Failure Conditions (Hard Stop)

Governance is **not active** if Copilot:

- Gives generic best practices
- Mentions rules without citing files
- Fails to reference the timeline
- Invents rules not present in governance docs
- Does not acknowledge refusal behavior

If any of the above occur:

> 
> **STOP. Do not generate code. Fix visibility first.**
> 

---

## Optional: Fast “Heartbeat” Check

For day-to-day work, a faster probe:

> 
> **“Before answering, confirm which governance documents and rule files you are using.”**
> 

This is useful after:

- Adding new rules
- Editing governance files
- Restarting VS
- Switching branches

---
## Summary

- Existing modules adopt governance safely
- No mass refactors required
- Framework acts as the canonical reference
- AI is constrained before it is trusted
- Discipline increases without slowing delivery

This is how AI becomes a **reliable collaborator**, not a liability.