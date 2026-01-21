# Governance Rule Proposal — UI Construction Standards

## Proposed Rule Name

**027x-ui-construction.md**

---

## Motivation

Oqtane UI consistency, predictability, and maintainability depend on strict adherence to framework-aligned UI patterns.

AI-generated UI code frequently introduces:

- Mixed UI frameworks
- Blazor `EditForm` abstractions that hide validation and submit behavior
- Implicit form submissions
- Navigation patterns that bypass Oqtane routing conventions

This rule exists to prevent:

- Accidental form submission side effects
- Inconsistent UI behavior
- Divergence from canonical Oqtane UI patterns
- Fragile or non-auditable UI abstractions

---

## Scope

This rule applies to **all UI code** in Oqtane modules, including:

- Razor components
- Admin and Edit pages
- Dialogs
- Toolbar actions
- Navigation elements

---

## Proposed Rules

### Rule 1: UI Framework Standardization

All UI must use:

- **Bootstrap** for layout and styling
- **Bootstrap Icons** for icons

**Reject if:**

- Any other CSS framework is introduced
- Custom icon systems are used
- Inline styling replaces Bootstrap classes unnecessarily

---

### Rule 2: No `EditForm` Usage

UI must use **standard HTML form elements**.

- `<form>`
- `<input>`
- `<select>`
- `<textarea>`

Client-side validation must be explicit.

**Reject if:**

- `EditForm` is used
- Validation logic is hidden behind framework abstractions
- Implicit submit behavior is relied upon

---

### Rule 3: Button Type Enforcement

All buttons must explicitly declare:

```
<button type="button">
```

**Reject if:**

- `type` is omitted
- `type="submit"` is used unless explicitly requested
- Button behavior depends on default browser submission

---

### Rule 4: Explicit Submit Intent Only

`type="submit"` may **only** be used when:

- The request explicitly requires form submission
- Submit behavior is intentional and documented

**Reject if:**

- Submit is used as a convenience
- Submit behavior is implied rather than explicit

---

### Rule 5: Navigation via ActionLink

Navigation must prefer:

- `ActionLink`
- Oqtane routing mechanisms

**Reject if:**

- Direct URL manipulation is used
- `NavigationManager.NavigateTo` is used where `ActionLink` is appropriate
- Anchor tags bypass Oqtane navigation patterns

---

## Canonical Reference

This proposal aligns with patterns used in:

- Oqtane framework admin modules
- HtmlText module UI patterns
- Core framework edit and management pages

Final validation should reference:

- Oqtane Client components
- Oqtane Admin UI implementations

---

## Enforcement Intent

If adopted as an enforced rule:

- This proposal will become `docs/governance/027x-ui-construction.md`
- It must be indexed in `027-rules-index.md`
- AI must refuse UI code generation that violates any rule above

---

## Open Questions

- Should `NavigationManager` ever be allowed as a fallback?
- Should Bootstrap utility class usage be constrained further?
- Should icon usage be limited to a defined subset?

---

## Status

**Status:** Proposed

**Next Step:** Review → Validate against canonical Oqtane UI → Approve or refine