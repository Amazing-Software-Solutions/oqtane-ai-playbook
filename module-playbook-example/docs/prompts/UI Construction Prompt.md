# UI Construction Prompt (Oqtane Module)

## Purpose

Use this prompt when creating or modifying **any UI component*- in this module.

This prompt enforces **Oqtane-first UI construction**, module governance, and prevents reinvention of framework UI patterns.

---

## Mandatory Context

Before responding, you MUST:

1. Read `.github/copilot-instructions.md`
2. Read `docs/governance/027-rules-index.md`
3. Load all applicable `027x-ui-*` rule documents
4. Check `docs/ai-decision-timeline.md` for relevant prior decisions
5. **Inspect Oqtane framework UI components and module controls**

If any required file or reference is missing or inaccessible, **STOP and refuse**.

---

## Framework UI First (Non-Negotiable)

Before inventing or proposing **any UI behavior**, you MUST:

1. Check whether Oqtane already provides a UI component or pattern

    - Examples include (but are not limited to):

        - `ActionDialog`
        - `ActionLink`
        - Built-in confirmation dialogs
        - Framework form patterns
2. Prefer **existing Oqtane UI components*- over:

    - Raw JavaScript
    - `IJSRuntime` wrappers
    - Custom dialogs or modals
3. Only propose a custom UI implementation if:

    - No framework component exists **and**
    - You explicitly state **why*- it cannot be used

**Reject if:**

- A framework UI component exists and is not used
- Custom JS or dialogs are introduced without justification
- `IJSRuntime` is used where an Oqtane control already solves the problem

---

## UI Construction Rules (Non-Negotiable)

You MUST:

- Use **explicit HTML elements only**

    - `<form>`, `<input>`, `<select>`, `<textarea>`
- Use **Bootstrap classes*- for layout and styling
- Use **Bootstrap Icons*- where icons are required
- Declare `type="button"` on **ALL*- buttons
- Implement validation explicitly and visibly in code
- Use `ActionLink` for navigation where applicable
- Keep UI logic inside the Razor component

You MUST NOT:

- Use `EditForm` (unless explicitly instructed)
- Use implicit Blazor validation abstractions
- Use `type="submit"` unless explicitly requested
- Hide validation or save behavior
- Introduce routing via `@page`
- Introduce business logic or persistence
- Introduce JavaScript confirmation or dialogs if Oqtane provides an equivalent control

---

## Discovery & Explanation Requirement

If proposing **any*- of the following:

- JavaScript interop
- Custom dialog / modal
- Custom confirmation logic
- New UI abstraction

You MUST first answer:

1. **What existing Oqtane UI component was evaluated?**
2. **Why it cannot be used in this scenario**
3. **What gap exists in the framework (if any)**

Failure to do so is grounds for rejection.

---

## Expected Output

- Razor component fragment
- Explicit HTML markup
- Explicit validation logic
- Explicit explanation of UI decisions
- Zero invented abstractions

If uncertain, **REFUSE and explain why**.