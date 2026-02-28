Perfect. We will harden the foundation properly.

Below are the two updates in governance-ready format.

---

# 1. Update 027-rules-index.md

Add New Governance Category: Runtime Awareness

This must be elevated to a first class rule category, not a sub-note.

---

## 027x Runtime Awareness Rules

Runtime Awareness ensures AI validates actual environment state before generating code or architecture.

AI must never assume:

- Framework version
- Database baseline state
- Migration execution history
- Feature availability
- Packaging state

# Runtime Awareness

Why the Playbook Checks Before It Builds

The Oqtane AI Playbook is not just a list of rules.

It is environment-aware.

Before generating migrations, jobs, tasks, or schema changes, AI must first understand the current state of your solution.

Why?

Because the same instruction can mean two very different things depending on the runtime state.

---

## Example 1: Fresh Module vs Live Module

If your database has never executed migration 01.00.00.00:

You are in a clean state.
The baseline schema can be redesigned safely.

If migration 01.00.00.00 already exists in the \_\_EFMigrationsHistory table:

You are no longer in a clean state.
EntityBuilders become immutable.
All changes must be new migrations.

Same request.
Different outcome.
Runtime determines the rule.

---

## Example 2: Scheduled Job vs Site Task

If you are on Oqtane 10.1 or greater:

You have access to ISiteTask.

If you request a Scheduled Job for a user-triggered background task, the Playbook may suggest a SiteTask instead.

Why?

Because SiteTasks are designed for:

- User initiated
- Asynchronous
- Non polling workloads

The Playbook optimizes architecture, not just output.

---

## Example 3: Framework Version Constraints

If a feature requires Oqtane 10.1:

The Playbook must verify the framework version first.

If your system is running 10.0:

The feature cannot be generated safely.

---

## What This Means

The Playbook:

- Checks before it changes
- Detects before it modifies
- Suggests before it generates

It does not assume.

This is what separates:

Tool usage
from
Architectural governance.

---

## In Simple Terms

Runtime Awareness means:

The AI looks at your real system state before it builds anything.

Because rules without context create risk.

---
