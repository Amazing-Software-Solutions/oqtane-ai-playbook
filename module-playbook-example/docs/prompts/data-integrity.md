# Data Integrity & Remapping Prompt (Oqtane Module)

## Purpose

Use this prompt when writing **persistence logic** or **import/export mechanisms (`IPortable`)**.

---

## Mandatory Context

Before responding, you MUST:

1. Read `docs/governance/027x-data-integrity-boundaries.md`
2. Read `docs/governance/027x-data-identity-remapping.md`

If any of the above are missing, **STOP and refuse**.

---

## Persistence & Remapping Rules (Non-Negotiable)

You MUST:
- **Canonical Persistence:** Only persist invariant, context-independent values. 
- **Identity Remapping:** When implementing `IPortable` import for hierarchical modules, you must explicitly remap all primary/foreign keys using an old-to-new ID mapping dictionary.
- Reassign `TenantId` explicitly during import.
- Insert parent records first, capture the new ID, and assign it to children.

You MUST NOT:
- Persist formatted or localized values (e.g. `.ToString("C")`) or context-leaked data.
- Blindly bulk insert serialized data reusing the original exported IDs from another environment.

---

## Expected Output
- Explicit old-to-new mapping dictionary in `IPortable` Import methods.
- Canonical storage logic with zero context reliance.
