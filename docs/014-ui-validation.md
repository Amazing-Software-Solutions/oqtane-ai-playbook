# 014 — UI Validation

UI validation in Oqtane modules must be **explicit, deterministic, and framework-aligned**.
This chapter defines the **only supported pattern*- for form validation and save execution in module UI components.

This is a **framework rule**, not a stylistic preference.

---

## Core Principle

> **No data is persisted unless the form is valid.**

Validation must occur:
- Before any save logic
- Inside the Blazor component
- Using Oqtane-provided interop

Browser-native validation popups must be suppressed in favor of controlled UI feedback.

---

## Required Form Pattern

All forms MUST:

- Use a `<form>` element
- Disable browser validation (`novalidate`)
- Apply Bootstrap validation classes
- Be validated explicitly before save

### Canonical Razor Example

```html
<form @ref="form"
      class="@(validated ? "was-validated" : "needs-validation")"
      novalidate>

    <div class="mb-3">
        <label class="form-label">
            Name <span class="text-danger">*</span>
        </label>

        <input class="form-control"
               @bind="model.Name"
               required />
    </div>

    <button type="button"
            class="btn btn-primary"
            @onclick="Save">
        Save
    </button>
</form>
```
### Mandatory Rules

- `novalidate` MUST be present
- Save buttons MUST be `type="button"`
- `was-validated` MUST only be applied after submission
- Validation state MUST be component-controlled

---

## Validation Execution Rule

Validation MUST be executed using **Oqtane UI interop**.

### Canonical Save Method

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

### Enforcement Rules

- Validation MUST run before save logic
- Save MUST exit immediately if validation fails
- Interop MUST be used (no raw JavaScript)

---

## JavaScript Boundary

Developers MUST NOT implement custom validation JavaScript.

Oqtane already provides the required interop internally:

```javascript
formValid: function (formRef) {
    return formRef.checkValidity();
}
```

This ensures:

- Cross-browser compatibility
- Framework consistency
- Predictable AI generation

---

## Error Handling Requirement

Validation failure is **not an error*- and MUST NOT be logged.

Save failures after validation MUST:

- Be caught
- Be logged
- Surface a user-visible message if appropriate

```csharp
try
{
    await SaveModelAsync(model);
}
catch (Exception ex)
{
    logger.LogError(ex, "Error saving model");
}
```

Silent failures are not acceptable.

---

## Explicit Prohibitions

The following are NOT allowed:

- Submitting forms without validation
- Relying on browser popup validation
- Calling save logic from `onsubmit`
- Using raw `IJSRuntime.InvokeAsync` for validation
- Writing custom JavaScript validation helpers
- Saving data before validation completes

Any generated code violating these rules must be rejected.

---

## Why This Matters

Incorrect validation patterns cause:

- Inconsistent UX
- Partial saves
- Hard-to-debug state bugs
- AI-generated anti-patterns

A single, enforced pattern eliminates ambiguity and failure modes.

---

## Summary

UI validation in Oqtane modules is:

- Explicit
- Interop-driven
- Framework-aligned
- Deterministic

If a form does not follow this pattern, it is incorrect.

This rule exists to protect data integrity and developer sanity.
