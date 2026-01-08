# AI Decision Timeline

This folder contains **decision records** created when AI-assisted development
exposed a non-obvious rule, constraint, or framework invariant.

AI systems are stateless.
This timeline exists to preserve **human learning** where AI cannot.

---

## Purpose

The AI Decision Timeline captures **resolved, high-signal discoveries** that:

- Corrected AI-generated but invalid output
- Revealed subtle Oqtane framework constraints
- Required explicit rules to prevent recurrence
- Influenced governance, prompts, or rejection criteria

These are **not changelogs**.
They are **not implementation notes**.
They are **not retrospectives**.

They are architectural memory.

---

## When to Add an Entry

Create a timeline entry when:

- AI output was *plausible but wrong*
- A fix required multiple iterations or explicit constraints
- A framework rule was rediscovered rather than documented
- You want future AI interactions to avoid the same failure mode

Do **not** create entries for:
- Routine bugs
- Typographical errors
- Straightforward refactors
- Pure implementation work

Signal over noise.

---

## File Naming

```text
YYYY-MM-DD-short-description.md
