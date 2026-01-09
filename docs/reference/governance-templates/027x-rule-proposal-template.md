# 027x — Governance Rule Proposal Template

## Purpose

This document is used to **propose a new enforceable governance rule*- for the Oqtane AI Playbook.

A proposal:

- **Does not become enforceable automatically**
- Exists to be reviewed, refined, and approved
- Helps validate whether a rule is necessary, precise, and enforceable

AI may **review and validate*- proposals

AI may **NOT enforce*- proposals until approved and indexed.

---

## Rule Metadata (Required)

```
Rule ID: 027x-<short-name>
Status: Proposed
Author:
Date:
Related Rules:
Affected Domains:
```

**Affected Domains (select all that apply):**

- UI
- Repositories
- Services
- Migrations
- Jobs
- Authorization
- Error Handling
- Validation
- Infrastructure
- Other: \_\_\_\_\_\_\_

---

## Problem Statement

**What concrete problem does this rule address?**

Describe:

- The failure mode
- The ambiguity
- Or the repeated mistake

Be specific.

Avoid opinions or “best practices”.

> 
> 
> Example:
> 
> AI frequently places business logic inside repositories, violating Oqtane patterns.
> 

---

## Observed Canonical Behavior

**Where is the truth observed?**

Reference:

- Oqtane framework code
- Built-in modules (Admin, HtmlText, etc.)
- Existing enforced rules

```
Observed In:
- Oqtane.Server.Services.*
- HtmlText Edit.razor save workflow
```

🚫 Do **not*- invent patterns

✅ Only document what already exists

---

## Proposed Rule

State the rule **as a testable invariant**.

```
AI MUST:
AI MUST NOT:
```

Example:

```
AI MUST NOT place validation or business logic inside repositories.
AI MUST enforce validation in UI and service layers only.
```

Rules must be:

- Deterministic
- Binary (pass/fail)
- Enforceable without interpretation

---

## Rejection Criteria (Mandatory)

Explicitly define **when AI must refuse**.

```
Reject if:
- Business logic is introduced in repositories
- Validation appears outside UI or services
- Repository returns UI-facing error messages
```

If rejection criteria are unclear → the rule is invalid.

---

## Non-Goals

Clearly state what this rule **does NOT cover**.

```
This rule does NOT:
- Define how validation is implemented
- Replace existing migration or UI rules
- Introduce new abstractions
```

This prevents rule creep.

---

## Interaction With Existing Rules

Explain how this rule fits:

- Does it specialize an existing rule?
- Does it override anything?
- Does it depend on another rule?

```
This rule refines:
- 027x-canonical-validation.md
```

---

## Adoption Plan (Required)

This rule becomes enforceable **only when**:

1. Approved by a maintainer
2. Added as `027x-<name>.md`
3. Indexed in `027-rules-index.md`
4. Referenced (if needed) in Copilot instructions

Until then:

- AI may discuss
- AI may validate
- AI must NOT enforce

---

## Validation Checklist

Before approval, all must be true:

- <input disabled="" type="checkbox"> Rule is observable in the Oqtane framework
- <input disabled="" type="checkbox"> Rule is not duplicating an existing rule
- <input disabled="" type="checkbox"> Rule has explicit rejection criteria
- <input disabled="" type="checkbox"> Rule does not invent architecture
- <input disabled="" type="checkbox"> Rule improves determinism

---

## AI Review Notes (Optional)

*(This section may be filled by AI during review)*

```
- Clarity:
- Enforceability:
- Conflicts:
- Recommendation:
```

---

## Summary

This template exists to:

- Encourage contribution
- Prevent accidental over-governance
- Train contributors to think in enforceable invariants

> 
> 
> Governance is not about control.
> 
> It is about **shared certainty**.
> 

---

### How you can “test the feeling”

When you’re ready, do this next:

1. Pick **one real mistake*- you’ve seen AI make
2. Fill out this template
3. Paste it back here
4. I’ll review it **as if I were the governance engine**

No code. No magic. Just clarity.