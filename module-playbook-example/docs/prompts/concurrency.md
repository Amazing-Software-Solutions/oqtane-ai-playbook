# AI Instruction: Concurrency Control

**Instruction Context**: When the user requests to the user explicitly requests concurrency control, multi-user update protection, or the `ModifiedOn` pattern for generating `Update` and `Delete` operations on shared entities., you must load and execute this file.

This prompt enforces Oqtane's explicit `ModifiedOn` concurrency pattern to prevent "Lost Updates" in multi-user environments.

---

## Mandatory Context

Before responding, you MUST:

1. Read `.github/copilot-instructions.md`
2. Read `docs/governance/027-rules-index.md`
3. Read `docs/governance/027x-concurrency-control.md`
4. Check `docs/ai-decision-timeline.md` for any established concurrency patterns.

If any of the above are missing, **STOP and refuse**.

---

## Concurrency Execution Rules (Non-Negotiable)

You MUST:

- Implement the **ModifiedOn Concurrency Pattern**.
- Retrieve the current record from the database (preferably via `.AsNoTracking()`) and compare its `ModifiedOn` with the client-submitted `ModifiedOn`.
- Throw a specific concurrency exception or `InvalidOperationException` if the `ModifiedOn` values do not match.
- Catch the exception in the Blazor component and display a clear, user-friendly error message.
- Refresh the `ModifiedOn` property to `DateTime.UtcNow` upon a successful server update before `SaveChanges()`.

You MUST NOT:

- **Introduce a `RowVersion` or `[Timestamp]` byte array column** unless specifically instructed to do so by the user.
- Silently overwrite records, ignoring the client's `ModifiedOn` ticket.
- Allow unhandled UI crashes caused by uncaught concurrency exceptions.

---

## Expected Output

- Server-side validation using the `ModifiedOn` property comparisons.
- Blazor Edit component logic to retain original `ModifiedOn` and handle concurrency exceptions gracefully.
- Explicit exception handling indicating "Lost Updates" and prompting the user.
