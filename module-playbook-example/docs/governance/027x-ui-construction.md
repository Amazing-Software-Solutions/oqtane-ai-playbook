# **Oqtane UI Construction Rules (Enforced)**

## Purpose

These rules define **mandatory UI construction standards** for all Oqtane modules.

They exist to ensure:

- Consistent user experience across modules
- Predictable behavior for validation and actions
- Alignment with canonical Oqtane UI patterns
- Prevention of implicit or framework-invented behavior

## **Rule 1: Framework UI First**

Oqtane provides built-in UI components and interaction patterns that **must be preferred over generic Blazor or JavaScript solutions**.

When implementing UI behavior (including but not limited to confirmations, dialogs, navigation, notifications, and validation feedback), the AI **MUST first evaluate existing Oqtane UI controls**.

Examples include (but are not limited to):

- `ActionDialog`
- `ActionLink`
- Oqtane messaging / notification patterns
- Oqtane module controls under `Oqtane.Modules.Controls`

### **Required Behavior**

Before introducing any of the following:

- JavaScript dialogs (`confirm`, `alert`, custom JS modals)
- `IJSRuntime` UI interop
- Third-party UI components
- Custom modal or confirmation implementations

The AI **MUST**:

1. Check whether Oqtane provides a built-in control that satisfies the requirement
2. Use that control if it exists
3. If not used, explicitly state:

    - Which Oqtane control was evaluated
    - Why it was insufficient
    - What framework gap exists

### **Reject if**

- `IJSRuntime` is used for UI confirmation where `ActionDialog` is applicable
- UI behavior is implemented via JavaScript without evaluating Oqtane controls
- Framework UI primitives are bypassed silently
- Generic Blazor patterns are used where Oqtane has an established alternative

This rule exists to ensure:

- UI consistency across modules
- Alignment with Oqtane UX standards
- Long-term maintainability
- Avoidance of unnecessary JavaScript and abstraction leakage

[Rule 2: Prohibited Use of EditForm](#rule-2-prohibited-use-of-editform) (Explicit Opt-In)
## Rule 2: Prohibited Use of `EditForm`

The Blazor `EditForm` component **MUST NOT be used by default**.

UI must be constructed using **explicit HTML elements**, including:

- `<form>`
- `<input>`
- `<select>`
- `<textarea>`
- `<button type="button">`

### **Basic Input Types**

1. **`text`** - Single-line text field
2. **`password`** - Masked text field (for passwords)
3. **`email`** - Email address field with validation
4. **`tel`** - Telephone number field
5. **`url`** - URL field with validation
6. **`search`** - Search field (often with clear button)
7. **`number`** - Numeric input field
8. **`range`** - Slider control for numbers
9. **`color`** - Color picker
10. **`date`** - Date picker
11. **`datetime-local`** - Date and time picker (no timezone)
12. **`time`** - Time picker
13. **`week`** - Week picker
14. **`month`** - Month picker
15. **`file`** - File upload control

### **Selection Input Types**

1. **`checkbox`** - Checkbox (multiple selection)
2. **`radio`** - Radio button (single selection)

### **Button Input Types**

1. **`button`** - Generic button
2. **`submit`** - Form submission button
3. **`reset`** - Form reset button
4. **`image`** - Image as submit button

### **Special/Hidden Input Types**

1. **`hidden`** - Hidden field (not visible)
2. **`datetime`** - **Deprecated** - Date and time with timezone

### **HTML5 New Input Types**

(These are the modern types added in HTML5):

* `email`, `url`, `tel`, `search`
* `number`, `range`
* `color`
* `date`, `datetime-local`, `time`, `week`, `month`
* `file` (with `multiple` attribute) 

The button must have the attribute type="button" failing to do so will cause the button to act like a "submit" button

Validation and save behavior must be **explicit, visible, and imperative** in code.

No controls from the Microsoft.AspNetCore.Components.Forms namespace

---

### Explicit Opt-In Exception

`EditForm` **MAY ONLY** be used when **explicitly requested by the user** in the prompt.

An explicit request MUST:

- Mention `EditForm` by name
- Mention `Microsoft.AspNetCore.Components.Forms` by name
- Clearly state that its use is intentional

Examples of valid opt-in prompts:

- **Use `EditForm` for this component**
- **Implement this using Blazor `EditForm` and DataAnnotations**
- **This UI should explicitly use `EditForm`**

If the prompt does **not** explicitly opt in, `EditForm` is **forbidden**.

---

### Reject If

Reject the output immediately if **any** of the following occur:

- `EditForm` is used without an explicit opt-in request
- Validation logic is hidden behind framework abstractions
- Form submission behavior is implicit or inferred
- `type="submit"` is used without being explicitly requested
- Business or save logic is obscured by Blazor form abstractions

---

### Enforcement Notes

- Familiarity, convention, or **best practice** is **not justification**
- Historical Blazor defaults are **irrelevant**
- Governance rules override AI priors and training bias
- Silence is **not consent**

---

### Intent

This rule exists to ensure that:

- UI behavior is inspectable
- Validation is traceable
- Save logic is auditable
- AI does not **helpfully** abstract critical behavior away

---

## Rule 3: Explicit Button Type Declaration

All buttons **must explicitly declare their type**.

```
<button type="button">
```

**Reject if:**

- The `type` attribute is omitted
- Default browser behavior is relied upon
- Button intent is ambiguous

---

## Rule 4: Controlled Use of `type="submit"`

`type="submit"` **must not be used** unless:

- The request explicitly requires submit semantics
- Submit behavior is intentional, reviewed, and documented

**Reject if:**

- `type="submit"` is used by default
- Submit is used as a convenience
- Submit behavior is implied rather than deliberate

---

## Rule 5: Navigation via Oqtane Mechanisms

Navigation **must** use Oqtane-approved patterns:

- `ActionLink`
- Oqtane routing infrastructure

**Reject if:**

- Direct URL manipulation is used
- `NavigationManager.NavigateTo` is used where `ActionLink` is appropriate
- Anchor tags bypass Oqtane navigation conventions

---

## Canonical Alignment

These rules align with UI patterns found in:

- Oqtane framework admin modules
- HtmlText module
- Core Oqtane edit and management pages

The **Oqtane Framework** itself is the canonical reference.

---

## Validation Checklist

A UI implementation is valid only if:

- Bootstrap is used exclusively
- Bootstrap Icons are used for icons
- `EditForm` is not present
- All buttons declare `type`
- `type="submit"` is only used when explicitly required
- Navigation uses `ActionLink` or equivalent Oqtane routing

If any check fails, **reject the change**.

---

## Enforcement

- This rule is **enforced**
- AI must refuse to generate or modify UI code that violates this document
- Violations must not be worked around or softened
- If uncertainty exists, refusal is preferred over assumption

### **UI Discovery Enforcement**

When generating or modifying UI code, the AI must demonstrate **framework discovery** before implementation.

If discovery is not demonstrated, the output is **non-compliant**.

#### Discovery Evidence Includes:

- Naming the relevant Oqtane control
- Explaining its applicability or limitation

#### Immediate Rejection Conditions:

- "Generic Blazor best practice" used as justification
- JavaScript interop proposed without framework evaluation
- Claims of portability without Oqtane context

