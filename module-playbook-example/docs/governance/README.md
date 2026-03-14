# Governance Rules

![Rule-Based Governance](https://img.shields.io/badge/Governance-Rule%20Based-purple)
![No Invented Patterns](https://img.shields.io/badge/AI-No%20Invented%20Patterns-red)
![Timeline Enforced](https://img.shields.io/badge/AI-Decision%20Timeline-orange)  
![Governed](https://img.shields.io/badge/Governed-Oqtane%20AI%20Playbook-blue)

> Add These Shields to the top of your README to indicate that your repository is governed by the Oqtane AI Playbook and its enforceable rules.
> 
> [![Governed](https://img.shields.io/badge/Governed-Oqtane%20AI%20Playbook-darkblue)](https://github.com/leigh-pointer/oqtane-ai-playbook)   
> ![Governed](https://img.shields.io/badge/Oqtane%20AI%20Playbook-027%20Governance-orange) 


## AI Governance

This module follows the **Oqtane AI Playbook** governance model.


This folder contains the **enforceable AI governance rules** for this repository.

These rules exist to ensure that:
- AI-generated code follows Oqtane's architectural constraints
- Invalid patterns are rejected early
- Decisions are consistent, reviewable, and repeatable
- Previously rejected approaches are not reintroduced

This is **governance as code**, not guidance.

---

## How Governance Works

This repository uses a **rule reference model**.

- Rules are **file-backed**
- Only files listed in `027-rules-index.md` are enforceable
- AI must discover and apply relevant rules before generating or modifying code
- If no applicable rule exists, AI must **refuse or propose a new rule**

AI is **not permitted to invent rules**.

---

## AI Assistant Instruction Governance

Canonical AI assistant instructions are defined in `.github/copilot-instructions.md`
and MUST be referenced by all governed modules.

Modules MUST NOT copy or replace this file.

Modules MAY extend AI behavior by providing a `.github/module-instructions.md` file.
This file is additive only and must not contradict governance rules or relax enforcement.

This rule exists to preserve a single point of truth while allowing intentional,
auditable module-specific customization.

## Required Files

### 1. `027-rules-index.md`
The authoritative index of all enforceable rules.

- Defines **what rules exist**
- Defines **when rules apply**
- Controls **rule discovery**

If a rule is not indexed, it does not exist.

---

### 2. `027x-*` Rule Files

Each `027x-*` file defines **enforceable rules** for a specific domain.

Rule files must:
- Be explicit
- Contain rejection criteria
- Be enforceable without interpretation
- Avoid recommendations or 'best practices'

Examples:
- `027x-core-ai-behavior.md`
- `027x-authorization.md`
- `027x-scheduled-jobs.md`

---

## UI Framework Policy

This playbook is **Oqtane-first**.

By default, all UI guidance follows:
- Bootstrap
- Explicit HTML elements
- Visible validation and save logic
- Canonical Oqtane UI patterns

Alternative UI frameworks (such as MudBlazor) are **not enabled by default**.

They may be used **only by explicit opt-in** and are governed by
dedicated rule documents (for example: `027x-ui-mudblazor.md`).

If a framework is not explicitly requested and governed,
it must not be introduced.

---

## Rule Enforcement Order

When rules conflict, precedence is:

1. Canonical module reference
2. Domain-specific rule
3. General rule
4. AI output (always loses)

---

## AI Decision Timeline

Historical decisions and invariants are recorded in:

`/docs/ai-decision-timeline.md`


AI must:
- Read the timeline before non-trivial responses
- Not reintroduce rejected patterns
- Propose new entries when a refusal or invariant occurs

Timeline entries are **append-only**.

---

## Governance File Visibility (Critical)

This playbook **does not require copying files** into every module.

What matters is **IDE visibility**, not physical location.

### Supported Model (Recommended)

Governance and prompt files may live **anywhere on disk**, as long as:

* They are added to the module **solution** as *existing documents*
* They appear under a `docs/` solution folder
* AI assistant can *read* them at prompt time

### Example (Linked Files)

A module solution may include:

```
docs/
├── governance/
│   ├── 027-rules-index.md
│   ├── 027x-ui-construction.md
│   ├── 027x-migrations.md
│   └── ...
└── prompts/
    ├── ui.md
    ├── services.md
    ├── diagnostics.md
    └── ...
```

These files may be **linked** from another folder or repository:

```
<Folder Name="/docs/governance/">
      <File Path="../../../../Oqtane Development/oqtane-ai-playbook/module-playbook-example/docs/governance/027-rules-index.md" />
</Folder>
```

---

## Adding or Changing Rules

AI **cannot** add or modify rules directly.

To introduce new governance:
1. Propose a rule document
2. Review with maintainers
3. Add the rule to `027-rules-index.md`
4. Commit the rule file

Only then does the rule become enforceable.

---

## Enforcement Statement

Failure to follow governance rules invalidates AI output.

When in doubt:
- Reject
- Explain why
- Reference the governing rule

This folder is binding.

## Using the Prompts

## Q, How do I use the prompts?

> Below is the literal, practical workflow a developer follows.

## The Short Answer
 
The prompt file is **not executed automatically**. 

It is a **deliberate instruction anchor** the developer invokes when needed.


Think of it as:

- a **contract**
- a **guardrail**
- a **shared language** between the developer and AI assistant

---

## How a Developer Uses `docs/prompts/authorization.md`

### 1️⃣ During Development (The Normal Flow)

A developer is working in a module and asks AI assistant something like:

> 
> 
> “Add authorization to this controller method.”
> 

AI assistant may **guess** unless guided.

This is where the prompt comes in.

---

### 2️⃣ Explicit Invocation (Recommended)

The developer **copies the intent** of the prompt into the AI assistant chat:

**Example prompt:**

> 
> 
> Use the **Authorization Prompt** from `docs/prompts/authorization.md`.
> 
> 
> I am adding authorization to a module API controller.
> 
> The secured entity is **ModuleId**.
> 
> Required permission is **Edit**.
> 
> 
> Generate compliant authorization logic.
> 

📌 Why this works:

- AI assistant now **knows which rule set to apply**
- You’ve scoped the entity and permission
- You’ve prevented invention

---

### 3️⃣ “Guardrail Mode” (When Reviewing Code)

When reviewing or refactoring existing code:

> 
> 
> Review this controller using the **Authorization Prompt**.
> 
> Identify violations of `027x-authorization.md`.
> 
> Do not rewrite unless necessary.
> 

This flips AI assistant into **auditor mode**, not generator mode.

---

### 4️⃣ When AI Assistant Refuses (By Design)

If the developer writes:

> 
> 
> “Just secure this using Admin role.”
> 

AI assistant should now respond with:

> 
> 
> **Authorization Refusal**
> 
> Role-based authorization is not permitted here without an explicit exception.
> 
> Please clarify the permission and entity scope.
> 

This is **success**, not failure.