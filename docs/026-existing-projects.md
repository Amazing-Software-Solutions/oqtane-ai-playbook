# 26 — Applying the Playbook to Existing Oqtane Projects

Most Oqtane modules are not greenfield projects.

They already exist.
They already work.
And they already contain decisions — some correct, some accidental, some inherited from AI or past habits.

This chapter explains **how to introduce the playbook into an existing solution without rewriting it**, breaking it, or stopping development.

The goal is **governance, not refactoring paralysis**.

---

## The Core Principle: Freeze Structure, Not Progress

When adopting these rules mid-project:

- You are **not fixing everything**
- You are **preventing new mistakes**
- You are **making the system converge over time**

The playbook is a *forward-looking constraint system*.

---

## Step 1 — Establish a Structural Baseline

Before changing anything:

1. Generate a **fresh stub module** using the Oqtane Module Manager
2. Do **not** modify it
3. Use it only as a **structural reference**

This stub becomes your **ground truth** for:

- Project layout
- Folder structure
- Base classes
- Naming conventions
- Required files

> The stub is not a template — it is a ruler.

---

## Step 2 — Compare, Don’t Rewrite

For each existing module:

- Compare it to the stub
- Identify **structural deviations**
- Categorize them as:

| Type | Action |
|----|----|
| Cosmetic | Ignore |
| Non-blocking | Document |
| Actively harmful | Schedule correction |
| New code risk | Enforce immediately |

Do **not** mass-refactor to match the stub unless required.

---

## Step 3 — Introduce AI Assistant Governance Immediately

Even if the codebase is imperfect, **new code must be correct**.

Add to the solution root:

github/
└── copilot-instructions.md


This file becomes authoritative **from this point forward**.

Key rule:

> Existing violations are tolerated.  
> New violations are rejected.

This single step stops architectural drift.

---

## Step 4 — Lock High-Risk Areas First

Focus enforcement on areas where AI commonly fails:

### Priority Enforcement Zones
1. **Scheduled Jobs**
2. **Authorization (Permissions vs Roles)**
3. **Service Layer (Client / Server / Shared)**
4. **Database Migrations**

These areas:
- Fail silently
- Break tenants
- Create security risk
- Are expensive to fix later

Everything else can evolve gradually.

---

## Step 5 — Add “Reject If Violated” Rules

For each high-risk area, add **hard rejection rules** to AI assistant instructions.

Example:

Reject any Scheduled Job that:
- Does not inherit from HostedServiceBase
- Implements BackgroundService or timers
- Manages its own scheduling

This converts guidance into **enforceable constraints**.

* * *

## Step 6 — Document Known Exceptions

Legacy code exists.

Instead of hiding it, **name it**.

Create:

```
docs/
└── deviations.md
```

Document:

* Why it exists
* Why it wasn’t changed
* Whether it is allowed in new code (usually no)

This prevents future developers — human or AI — from copying it.

* * *

## Step 7 — Gradual Alignment, Not Big Bang Refactors

Refactor only when:

* You are already touching the code
* You are fixing a bug
* You are adding a feature
* The change reduces risk

Never refactor “just to be clean”.

Convergence happens naturally if rules are enforced.

* * *

## Step 8 — Teach Through Diff, Not Doctrine

When updating an existing module:

* Show the **before and after**
* Explain *why* the new code follows the playbook
* Avoid moral language (“wrong”, “bad”)

This builds shared understanding without resistance.

* * *

## What This Avoids

This approach prevents:

* Endless rewrites
* Architecture freeze
* Developer fatigue
* “Perfect is the enemy of shipped”

It replaces hope with **controlled evolution**.

* * *

## The Real Win

After adoption:

* Old code slowly ages out
* New code is predictable
* AI stops hallucinating structure
* Modules become reviewable again
* Onboarding becomes easier

Most importantly:

> 
> 
> You stop crossing your fingers.
> 

* * *

## What Comes Next

With governance in place for existing projects, the final chapter closes the loop:

* Why this matters to the Oqtane ecosystem
* How teams can share and evolve these rules
* How this becomes community infrastructure, not personal preference

> 
> 
> **From personal discipline to shared standards**
> 

```

```