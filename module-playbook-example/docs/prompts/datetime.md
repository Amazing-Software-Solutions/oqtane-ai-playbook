# AI Instruction: DateTime Handling

**Instruction Context**: When the user requests to writing properties, validation, logic, or UI formatting related to Dates and Times., you must load and execute this file.

---

## Mandatory Context

Before responding, you MUST:

1. Read `.github/copilot-instructions.md`
2. Read `docs/governance/027x-datetime-handling.md`

If any of the above are missing, **STOP and refuse**.

---

## DateTime Execution Rules (Non-Negotiable)

You MUST:
- Use `DateTime.UtcNow` for all new timestamps.
- Store **all dates globally** in UTC Server-side.
- Preserve existing UTC values without transformation.

You MUST NOT:
- Store `DateTime.Now` directly in the database. 
- Use `.ToLocalTime()` before persistence.
- Apply timezone offsets prior to storage.
- Persist local or context-derived time.

---

## Expected Output
- Precise usage of `DateTime.UtcNow`.
- Absence of timezone conversion logic in persistence layers.
