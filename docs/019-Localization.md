# Localization in Oqtane Modules

## Purpose

Localization in Oqtane is **optional**, but when it is required it must be implemented
**correctly, consistently, and completely**.

This document explains:

- When localization should be considered
- How localization works in Oqtane
- Common mistakes when adding localization late
- How localization is governed when enabled

This document is **guidance**, not enforcement.

Enforcement is handled separately via governance rules.

---

## When Localization Is Appropriate

Localization is recommended when a module:

- Is intended for international or multilingual audiences
- Is distributed publicly or commercially
- Is used in environments where UI language must follow tenant culture
- Contains user-facing UI text beyond simple labels

Localization is often **not necessary** for:

- Internal-only tools
- Proof-of-concept modules
- Highly technical admin-only extensions
- Single-tenant, single-language deployments

Localization should be a **deliberate decision**, not an afterthought.

---

## Canonical Oqtane Localization Model

Oqtane uses standard ASP.NET Core localization patterns:

- `IStringLocalizer<T>`
- `.resx` resource files
- Culture resolution per tenant

Localization is **not handled automatically**.
Every user-facing string must be explicitly localized.

Typical usage:

- Razor components inject `IStringLocalizer<T>`
- Resource keys map to `.resx` entries
- Culture is resolved by the framework

---

## What Must Be Localized

When localization is enabled, the following must be localized:

- UI labels and headings
- Button text
- Validation messages
- Error messages
- User-facing notifications and warnings
- Tooltips and help text

**Mixing localized and hard-coded strings is not acceptable.**

---

## Common Pitfalls

Localization often fails due to:

- Hard-coded UI strings left behind
- Validation messages not localized
- Error messages constructed dynamically
- Partial localization applied inconsistently
- Localization added late, after UI is already built

These issues become increasingly expensive to fix over time.

---

## Opt-In Governance Model

Localization is governed using an **opt-in rule**.

By default:
- Localization rules do not apply
- AI will not enforce localization automatically

Once a module explicitly opts in:
- Localization becomes mandatory
- All user-facing strings must be localized
- AI governance rules apply strictly

This opt-in is governed by:

📄 `docs/governance/027x-localization.md`

---

## Signaling Localization Intent

A module should clearly signal when localization is enabled.

Recommended approaches:

- A README badge (e.g. “Localization Enabled”)
- An explicit opt-in prompt for AI tools
- Governance rule activation via documentation

Once signaled, localization rules are enforced consistently.

---

## Relationship to AI Governance

When localization is enabled:

- AI must not generate hard-coded UI text
- AI must refuse partial localization
- AI must validate against canonical Oqtane patterns
- AI must explain violations clearly

If localization is **not enabled**, AI must not invent localization behavior.

---

## Summary

- Localization is optional, but serious when enabled
- Oqtane provides a clear, canonical localization model
- Partial localization is worse than none
- Governance rules exist to enforce correctness once opted in
- This document explains *why* and *how*, not *when to enforce*

---

For enforcement details, see:

`docs/governance/027x-localization.md`
