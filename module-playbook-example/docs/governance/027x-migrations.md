# 027x Migrations Governance

## 0. Purpose

This document defines mandatory governance for database migrations in Oqtane modules.

Its purpose is to:

* Prevent schema drift
* Prevent destructive AI generated changes
* Preserve deterministic installs
* Align with Oqtane runtime execution behavior
* Separate runtime facts from governance enforcement
* Enable runtime aware migration decisions

This rule is mandatory for all modules governed by the Oqtane AI Playbook.

---

# 1. Migration Execution Model (Confirmed Runtime Behavior)

Oqtane executes migrations automatically at application startup.

A migration will run when:

```
migrationVersion > ModuleDefinition.ReleaseVersion
```

Versions are compared as four numeric segments:

```
MM.mm.PP.bb
```

Missing segments are treated as zero.

Examples:

```
10.0.0       = 10.00.00.00
10.00.00.01  > 10.00.00.00
10.00.00.02  > 10.00.00.00
```

Therefore:

If:

```
ReleaseVersion = 10.0.0
```

Then:

```
10.00.00.01
10.00.00.02
```

WILL execute.

This behavior applies equally to:

* Oqtane core migrations
* Tenant migrations
* Module migrations

Only the migration scope prefix differs.

This is by design.

---

# 2. Development Version Strategy (Baseline + Build Pattern)

Governance adopts the following strategy:

* `ReleaseVersion` defines the baseline as `major.minor.patch`
* The fourth segment (build) is used for incremental schema changes during development

Example:

ReleaseVersion:

```
1.2.0
```

Baseline treated as:

```
01.02.00.00
```

Development migrations:

```
01020001_AddDescription.cs
01020002_AddIndex.cs
```

This allows:

* Multiple schema changes during development
* No artificial release bump for every migration
* Clean release semantics
* Predictable migration execution

At official release time:

* Bump major, minor, or patch
* Reset build segment accordingly

---

# 3. RevisionNumber Synchronization Rule

For deterministic installs:

`ModuleInfo.RevisionNumber` must always reflect the latest migration version.

Format:

```
01,02,00,02
```

Rules:

* Four segments
* Comma separated
* No spaces
* Must match latest migration exactly

If misaligned:

* Migrations may not execute
* Or may execute unpredictably

This is governance enforced.

---

# 4. Migration File Rules

Every migration must:

* Use exactly 8 numeric digits
* Follow MMmmPPbb format
* Be strictly increasing
* Match the version declared in the Migration attribute
* Match the RevisionNumber

Example:

```
01020002_AddIndex.cs
```

No exceptions.

---

# 5. Migration Class Requirements

Each migration must:

* Inherit `MultiDatabaseMigration`
* Accept `IDatabase` in constructor
* Include:

```
[DbContext(typeof(ModuleContext))]
[Migration("Fully.Qualified.Namespace.01.02.00.02")]
```

The numeric version in the attribute must match the filename.

---

# 6. EntityBuilder Governance

## 6.1 EntityBuilder Immutability (CRITICAL)

EntityBuilders define the initial schema only.

They are used exclusively by:

```
01000000_InitializeModule.cs
```

After initial deployment:

* NEVER modify EntityBuilder files
* NEVER update foreign keys in EntityBuilders
* NEVER change column definitions in EntityBuilders

All schema evolution must occur in new migration files.

Violation corrupts migration history.

---

## 6.2 Table Naming Convention (OwnerModule Pattern)

All tables must follow:

* PascalCase
* Prefixed with module identity
* No underscores
* No plural guessing
* Immutable after deployment

Example:

```
PlaybookGovernedExample
CreatorProfile
```

Renaming tables requires a migration.

Never rename directly in EntityBuilder.

---

# 7. Model Contract Governance

AI commonly makes this mistake:

Models must NOT inherit from `ModelBase`.

Correct contract:

All models must implement:

```
Oqtane.Models.IAuditable
```

Optional:

```
Oqtane.Models.IDeletable
```

Rules:

* Do not inherit ModelBase
* Implement IAuditable
* Implement IDeletable if soft delete required
* Ensure DbContext matches model contract

Reject ModelBase usage in module models.

---

# 8. Up() Method Rules

Up() must:

* Contain schema only
* Be provider agnostic
* Use EntityBuilders for new tables
* Avoid raw SQL unless absolutely required
* Avoid business logic
* Avoid data transformations unless unavoidable

---

# 9. Down() Method Rules

Down() is mandatory.

It must:

* Reverse exactly what Up() created
* Be deterministic
* Not introduce new schema elements

No irreversible migrations allowed.

---

# 10. DbContext and Schema Synchronization

When adding or modifying schema:

* Update DbContext
* Ensure DbSet<T> exists
* Ensure model matches schema
* Ensure IAuditable columns exist
* Ensure migration matches model

Schema, model, and migration must remain aligned.

---

# 11. Runtime Aware Governance (Database Inspection Capability)

AI may inspect database state before generating migrations.

If possible:

1. Read connection string from configuration
2. Query:

```
__EFMigrationsHistory
```

3. Determine:

* Has 01.00.00.00 executed?
* Are there applied migrations?
* Is database untouched?

This enables:

* Safe baseline replacement for fresh templates
* Strict migration-only behavior for deployed systems
* Prevention of destructive re-baselining

If migration history exists:

Do NOT replace baseline migration.

If no migration history exists:

Baseline may be safely redefined.

This transforms governance from static to runtime aware.

---

# 12. Fresh Boilerplate Declaration (Clean Architectural State)

When a module is freshly created from the template:

State:

* Client untouched
* Server untouched
* Shared untouched
* No production data
* No releases
* Migration 01.00.00.00 is default scaffold

At this stage:

You may:

* Replace 01.00.00.00
* Redefine schema
* Modify EntityBuilders
* Generate single authoritative baseline migration

You must:

* Define final entity model first
* Then generate baseline migration
* Follow versioning rules
* Set RevisionNumber correctly

Do not assume legacy data.

Do not preserve placeholder entities unless required.

---

# 13. AI Migration Safety Gate

Before generating a migration AI must confirm:

1. Current ReleaseVersion
2. Latest migration file
3. Current RevisionNumber
4. Whether EntityBuilders were previously deployed
5. Whether migration history exists in database

If unclear:

STOP and request clarification.

---

# Final Enforcement Summary

* Runtime comparison is MM.mm.PP.bb
* Baseline defined by ReleaseVersion
* Build segment used for development increments
* RevisionNumber must match latest migration
* EntityBuilders immutable after initial deployment
* Models implement IAuditable, not ModelBase
* All schema changes via new migrations
* Down() mandatory
* Database state must be considered when possible

This rule is mandatory under 027 governance.

---

This version is:

* Structurally ordered
* Runtime aligned
* AI hardened
* Boilerplate aware
* Deterministic
* Non duplicated
* Ready for GitHub Pages publication

If you would like next, we can:

* Create a visual migration lifecycle diagram
* Add a governance decision flowchart
* Or create a short human readable guide version alongside this hardened spec
