# 027x Concurrency Control (Opt-In)

## Purpose

This rule governs the implementation of Concurrency Control to prevent "Lost Updates" in multi-user environments.

This is an **[Opt-In]** rule. It must only be applied when the user explicitly requests concurrency control, multi-user update protection, or the `ModifiedOn` concurrency pattern.

---

# 1. Default Behavior (When Not Opted-In)

Unless explicitly requested:
- Standard Oqtane editing patterns apply (last write wins).
- Do not add concurrency validation logic to repositories or services.
- Do not modify Blazor components to handle concurrency exceptions.

---

# 2. Approved Pattern: The ModifiedOn Check

When concurrency control is requested, AI MUST implement the **ModifiedOn Concurrency Pattern** (as defined in Playbook `# 033`).

AI MUST NOT introduce a `RowVersion` or `[Timestamp]` byte array column unless specifically instructed to do so by the user. 

### Implementation Requirements:

1. **Server-Side Validation**:
   - The update method in the Repository or Manager must retrieve the current record from the database (preferably using `.AsNoTracking()`).
   - It must compare the `ModifiedOn` value in the database against the `ModifiedOn` value submitted by the client.
   - If they do not match, it must throw an `InvalidOperationException` (or a specific concurrency exception defined by the module).

2. **Client-Side Handling**:
   - The Blazor Edit component must retain the original `ModifiedOn` value loaded from the API.
   - The `Update` method must catch the concurrency exception.
   - The UI must display a clear, user-friendly error message (e.g., "This record was updated by another user while you were editing it.").

3. **Timestamp Refresh**:
   - Upon successful update, the `ModifiedOn` property must be updated to `DateTime.UtcNow` by the server before calling `SaveChanges()`.

---

# 3. Anti-Patterns (Immediate Rejection)

When this rule is active, reject the following patterns:
- **Silently overwriting records**: Ignoring the client's `ModifiedOn` ticket.
- **Premature Schema Changes**: Adding `byte[] RowVersion` to the EF Core model without user consent.
- **Unhandled UI Crashes**: Failing to catch the concurrency exception in the Blazor component, resulting in a generic 500 server error displayed to the user.
