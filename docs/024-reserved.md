# 024 - Reserved: Module Versioning and Release Lifecycle

> **Status: Planned**
>
> This chapter is **reserved** for future content on module versioning and the release lifecycle.

---

## Intended Coverage

When written, this chapter will cover:

- How `ReleaseVersion` (major.minor.patch) relates to migration versions
- Rules for incrementing major vs. minor vs. patch version numbers
- How to communicate breaking changes to downstream module consumers
- The policy for deprecating features in a community module
- How to safely prepare a module for a new Oqtane framework version
- What an upgrade-safe change looks like vs. a breaking change
- How AI tools get versioning wrong (inventing semver schemes that conflict with
  the migration model, or bumping versions in ways that skip migrations)

---

## Why This Gap Exists

`012-migrations.md` covers the migration version format in detail, but
the broader lifecycle question - when and how to increment `ReleaseVersion`,
and what that means for module consumers - is not yet addressed.

Until this chapter is written, refer to:

- `012-migrations.md` - Migration versioning format and trigger rules
- `027x-migrations.md` - Governance rule for migration correctness

---

> **Do not use this file number** for any other topic.
> When this chapter is written, replace this placeholder entirely.
