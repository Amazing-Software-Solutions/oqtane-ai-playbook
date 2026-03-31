# Oqtane UI Validation Rules (Enforced)

These rules govern **all user input validation** in Oqtane modules.

Validation exists to:
- Protect server-side invariants
- Prevent invalid state persistence
- Ensure predictable UI behavior

Validation must be **explicit, layered, and enforced**.

---

## Rule 1: Validation Is Mandatory

All user-modifiable input must be validated.

This includes:
- Forms
- Dialogs
- Inline edits
- API-bound UI components

```html
<form @ref="form"
      class="@(validated ? "was-validated" : "needs-validation")"
      novalidate>

    <!-- form fields -->
     <div>
        <label for="name">Name</label>
        <input type="text" @bind="model.Name" required />
        <div class="invalid-feedback">Name is required</div>
     </div>


    <button type="button"
            class="btn btn-primary"
            @onclick="Save">
        Save
    </button>
</form>
```
Save Structure (Mandatory Execution Pattern)  
All save operations MUST follow this structure:

1. Set validation state
2. Execute Oqtane validation
3. Exit immediately if invalid
4. Execute persistence logic only if valid

```csharp
@code {
    private ElementReference form;
    private bool validated;
    private SampleModel model = new();

    private async Task Save()
    {
        validated = true;

        var interop = new Oqtane.UI.Interop(JS);

        if (!await interop.FormValid(form))
        {
            return;
        }

        await SaveModelAsync(model);
    }
}
```



**Reject if input is accepted without validation.**

---

## Rule 2: Client Validation Is Advisory Only

Client-side validation:

- Improves UX
- Reduces round-trips
- Is never authoritative

**Client validation must never be trusted alone.**

**Reject if server-side validation is missing or weakened.**

---

## Rule 3: Server Validation Is Required

All server endpoints must:

- Validate input explicitly
- Reject invalid data deterministically
- Return structured error information

**Reject if validation relies solely on client behavior.**

---

## Rule 4: No Implicit or Hidden Validation

Validation rules must be:

- Visible in code
- Reviewable
- Deterministic

**Reject if validation is:**
- Implicit
- Convention-based
- Hidden inside frameworks without explicit checks

---

## Rule 5: Validation Placement

Validation may occur in:

- Controllers
- Server services
- Domain validators

Validation must **not** be embedded in:
- Repositories
- DbContexts
- UI rendering logic

**Reject validation logic placed in persistence layers.**

---

## Rule 6: Validation Feedback

UI validation feedback must:

- Be explicit
- Be user-readable
- Map to a specific failure condition

**Reject generic or silent failures.**

---

## Rule 7: No Validation Bypass

Validation must not be bypassed via:
- Optional flags
- Debug modes
- Client-only checks

**Reject any conditional validation disabling.**

---

## Validation Checklist

A UI change is valid only if:

- Client validation exists where appropriate
- Server validation is explicit and enforced
- Invalid input is rejected deterministically
- Validation logic is visible and reviewable

If any check fails, **reject the change**.

---

This rule set exists to ensure UI input never compromises module correctness.
