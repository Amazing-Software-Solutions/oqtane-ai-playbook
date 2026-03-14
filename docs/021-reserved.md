# 021 - Reserved: Multi-Tenancy Patterns

> **Status: Planned**
>
> This chapter is **reserved** for future content on safe multi-tenant coding patterns.

---

## Intended Coverage

When written, this chapter will cover:

- How tenant context flows through module code
- Writing queries that are always tenant-scoped
- Common ways tenant isolation is accidentally broken:
  - Static fields or singleton services holding per-request state
  - Caching without a tenant key
  - Shared in-memory collections
  - Assuming a single `SiteId`
- How tenant safety intersects with Scheduled Jobs (which run once per tenant)
- Anti-patterns AI tools commonly generate that break multi-tenancy

---

## Why This Gap Exists

Multi-tenancy is referenced as a concern in several other chapters
(`012-migrations.md`, `013-scheduled-jobs.md`), but is not yet consolidated
into a single authoritative reference.

Until this chapter is written, refer to:

- `013-scheduled-jobs.md` - Tenant safety section
- `012-migrations.md` - Multi-database and tenant context notes
- Oqtane framework source (`Oqtane.Server`) for canonical tenant resolution patterns

---

> **Do not use this file number** for any other topic.
> When this chapter is written, replace this placeholder entirely.
