 # Mdoule-Playbook-Example

**Canonical, Governed Reference Module for Oqtane AI Development**

## What This Is

**Module-Playbook-example*- is a **fully governed, working reference module*- that demonstrates how the Oqtane AI Playbook is meant to be applied in practice.

It is:

- A **living, buildable example**
- A **canonical reference implementation**
- The **bridge*- between abstract governance rules and real Oqtane modules

> 
> You **do not*- reference the *Oqtane AI Playbook- directly in your application modules.
> You reference **this example**.

---

## What This Is *Not*

- ❌ Not a framework
- ❌ Not a template generator
- ❌ Not something you deploy to production
- ❌ Not something application modules depend on at runtime

It exists purely to make governance **concrete, testable, and trustworthy**.

---

## Governance Model (One Sentence)

> 
> **Rules are authored in the Oqtane AI Playbook, proven in Module-Playbook-example, and then copied or referenced by real modules.**

---

## Repository Role in the 3-Layer Model

| Layer | Purpose |
| --- | --- |
| **Authoring Layer*- | Oqtane AI Playbook (rules, templates, governance logic) |
| **Reference Layer*- | **Module-Playbook-example (this repo)*- |
| **Application Layer*- | Your real modules |

Only the **Reference Layer*- is meant to be *looked at- by application modules.

---

## Folder Structure (Canonical)

Module-Playbook-example mirrors the exact structure expected in a governed module:

```
.github/
└── copilot-instructions.md

docs/
├── ai-decision-timeline.md
├── deviations.md
├── governance/
│   ├── 027-rules-index.md
│   ├── 027x-*.md
│   └── README.md
└── prompts/
    ├── README.md
    ├── ui.md
    ├── services.md
    └── diagnostics.md
```

This structure is **intentional*- and **enforced**.

---

## How to Use Module-Playbook-Example in a Solution

### Important Principle

> 
> **Files must be visible in the IDE solution to be seen by Copilot.Folders alone are ignored.**

You **do not copy*- these files into your module.
You **reference them*- using *Add Existing Item*.

---

## Step-by-Step: Wiring Module-Playbook-Example into Visual Studio

### 1. Create Solution Folders

In your module solution, create the following **solution folders**:

```
.github
docs
docs/governance
docs/prompts
```

> 
> These are *solution folders*, not physical folders.

---

### 2. Add Files Using “Add Existing Item”

For each folder:

1. Right-click the **solution folder**
2. Choose **Add → Existing Item…**
3. Browse to the corresponding file in **Module-Playbook-example**
4. Add it

Example paths:

```
Module-Playbook-example/.github/copilot-instructions.md
Module-Playbook-example/docs/ai-decision-timeline.md
Module-Playbook-example/docs/deviations.md
Module-Playbook-example/docs/governance/027-rules-index.md
Module-Playbook-example/docs/governance/027x-ui-construction.md
Module-Playbook-example/docs/prompts/ui.md
```

✔ Files remain **single-source**
✔ No duplication
✔ Governance stays in sync

---

### 3. Verify Copilot Visibility

Ask Copilot:

> 
> **“Summarize the non-negotiable rules you must follow in this repository.”**

If wired correctly, Copilot will:

- Reference `027-rules-index.md`
- Cite specific `027x-*` rules
- Mention the AI Decision Timeline
- Refuse invalid requests

If it doesn’t → refresh Copilot and re-check file visibility.

---

## Why This Matters

Without Module-Playbook-example:

- Rules feel theoretical
- Trust in AI output is low
- Developers second-guess governance

With Module-Playbook-example:

- AI can **prove*- behavior
- Developers can **compare*- implementations
- Governance becomes **observable and enforceable**

---

## How Real Modules Use This

Your real module:

- References **Module-Playbook-example**
- Copies or links only the files it needs
- May opt-in to additional rules (e.g. localization, MudBlazor)
- Never references the authoring playbook directly

This keeps adoption **low-friction*- and **developer-friendly**.

---

## Summary

- **Oqtane AI Playbook** → writes the rules
- **Module-Playbook-example** → proves the rules work
- **Your module** → safely adopts the rules
- **Application Example** → https://github.com/leigh-pointer/Playbook.Module.GovernedExample

If you want AI you can trust,
**this reference layer is non-optional**.

