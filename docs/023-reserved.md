# 023 - Reserved: Site Tasks and Module Bootstrap

> **Status: Planned**
>
> This chapter is **reserved** for future content on Site Tasks and first-run module setup.

---

## Intended Coverage

When written, this chapter will cover:

- What a Site Task is in Oqtane and why it exists
- How modules use Site Tasks to:
  - Seed default data on first install
  - Register default permissions
  - Perform one-time setup operations
  - Initialize module configuration
- The correct base class and interface (`IInstallable`)
- Why AI tools invent alternatives (constructor seeding, migration-based seeding,
  global startup code) that violate Oqtane's lifecycle model
- Hard rejection rules for Site Task anti-patterns

---

## Why This Gap Exists

Site Tasks are already covered by a governance rule (`027x-site-tasks.md`),
but there is no corresponding playbook chapter explaining the *why* and *how*
in the framework-invariant range (10-25).

This is a high-priority gap - AI tools that don't know about Site Tasks will
invent dangerous alternatives.

Until this chapter is written, refer to:

- `docs/governance/027x-site-tasks.md` - Governance rule (enforcement details)
- Oqtane framework source for `IInstallable` and Site Task execution model

---

> **Do not use this file number** for any other topic.
> When this chapter is written, replace this placeholder entirely.
