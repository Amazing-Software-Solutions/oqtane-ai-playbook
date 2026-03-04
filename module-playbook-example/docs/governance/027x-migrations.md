# 027x Migrations Governance

# 0. Purpose

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

Oqtane uses **two completely separate migration execution paths**.
They must not be confused with each other.

---

## 1.1 Path A — Framework Migrations (Core, Master, Tenant)

These are run by `DatabaseManager` at application startup via direct EF Core calls:

```
masterDbContext.Database.Migrate();
tenantDbContext.Database.Migrate();
```

These calls are **unconditional**.

EF Core applies any migration whose ID is absent from `__EFMigrationsHistory`.

`ReleaseVersions` in `Constants.cs` is **not consulted** for these migrations.

### Confirmed evidence

The `__EFMigrationsHistory` table contains entries such as:

```
Tenant.10.01.00.01
Tenant.10.01.00.02
Tenant.10.01.00.03
Tenant.10.01.00.04
```

These ran while `Oqtane.Constants.ReleaseVersions` ended at `"10.1.0"` (three segments, treated as `10.01.00.00`).

This proves conclusively that framework migrations run via EF Core tracking alone — they are never gated by `ReleaseVersions`.

---

## 1.2 Path B — Module Migrations

Module migrations follow a different path entirely.

`DatabaseManager` iterates the module's `ReleaseVersions` comma-separated list:

```csharp
var versions = moduleDefinition.ReleaseVersions.Split(',');
var index = Array.FindIndex(versions, item => item == moduleDefinition.Version);
if (index != (versions.Length - 1))
{
    for (var i = (index + 1); i < versions.Length; i++)
    {
        moduleObject.Install(tenant, versions[i]);
    }
}
```

Each call to `Install(tenant, version)` invokes the module manager's `Install` method, which calls:

```csharp
Migrate(new ModuleDbContext(...), tenant, MigrationType.Up);
```

This triggers `moduleDbContext.Database.Migrate()`, which applies all pending EF Core migrations for that module context.

After successful installation, `moduleDefinition.Version` is updated in the database to the last version in `ReleaseVersions`.

### Consequences

If `ReleaseVersions` contains only one entry and the installed version matches it:

```
index == versions.Length - 1
```

The loop does not execute.
`Install()` is never called.
`Database.Migrate()` is never called.
Any new EF migration files for the module will not run.

To trigger a module migration, a new entry must be appended to `ReleaseVersions`.

---

## 1.3 Summary of the Two Paths

|                             | Path A — Framework               | Path B — Module                                                                   |
| --------------------------- | -------------------------------- | --------------------------------------------------------------------------------- |
| Applies to                  | Master, Tenant DbContexts        | Module-specific DbContexts                                                        |
| Triggered by                | Direct `Database.Migrate()` call | `Install()` via `ReleaseVersions` list                                            |
| Gated by `ReleaseVersions`? | No                               | Yes                                                                               |
| Tracked in                  | `__EFMigrationsHistory`          | `__EFMigrationsHistory` (same table)                                              |
| Runs if                     | Migration ID not in history      | `installed version != last ReleaseVersions entry` AND migration ID not in history |

---

# 2. Development Version Strategy (Baseline + Build Pattern)

Governance adopts the following strategy:

* `ReleaseVersion` defines the baseline as `major.minor.patch`
* The fourth segment (build) is used for incremental schema changes during development

Example:

ReleaseVersion:

```
1.0.0
```

Baseline treated as:

```
01.00.00.00
```

Development migrations:

```
01000001_AddColumn.cs       → "StudioElf.Module.Doquetain.01.00.00.01"
01000002_AddIndex.cs        → "StudioElf.Module.Doquetain.01.00.00.02"
```

For each new migration file, a corresponding entry must be added to `ReleaseVersions`:

```
ReleaseVersions = "1.0.0,1.0.0.1"     → triggers 01000001
ReleaseVersions = "1.0.0,1.0.0.1,1.0.0.2"  → triggers 01000002
```

This allows:

* Multiple schema changes during development
* No artificial release bump for every migration
* Clean release semantics
* Predictable migration execution

At official release time:

* Bump major, minor, or patch
* Reset build segment accordingly
* `ReleaseVersions` entry reflects the release version (e.g. `"1.0.1"`)

---

# 3. RevisionNumber Governance

## 3.1 Version Segment Format

All migration versions use:

```
MM.mm.PP.bb
```

Segments are:

* Major
* Minor
* Patch
* Build

Segments are separated by periods.

Example:

```
10.00.00.01
1.0.0.1
```

---

## 3.2 What RevisionNumber Actually Is

`ModuleInfo.RevisionNumber` is:

* A comma separated list of **published release versions**
* Ordered chronologically
* Represents published module revisions
* Not a 4 segment mirror of migration version

Example:

```
"1.0.0,1.0.1,1.0.5,2.0.0"
```

Important:

* The build segment is not represented separately in RevisionNumber
* RevisionNumber does not contain development build increments like `1.0.0.1`, `1.0.0.2`
* Only official published releases belong in RevisionNumber
* Development `ReleaseVersions` entries (`1.0.0.1`, `1.0.0.2`) are separate from RevisionNumber

---

## 3.3 How Module Migration Execution Actually Works

At runtime, `DatabaseManager` compares:

```csharp
Array.FindIndex(versions, item => item == moduleDefinition.Version)
```

Where `versions` is derived from `moduleDefinition.ReleaseVersions.Split(',')`.

This is a **string equality list lookup**, not a numeric `>` comparison.

If the installed version matches the last entry in `ReleaseVersions`, no upgrade runs.

If the installed version is found at an earlier position, `Install()` is called for each subsequent entry.

### Example

```
Installed version:   1.0.0
ReleaseVersions:     "1.0.0,1.0.0.1"

versions = ["1.0.0", "1.0.0.1"]
index = 0 (found "1.0.0")
index != (length - 1) → true
→ Install(tenant, "1.0.0.1") is called
→ Database.Migrate() runs on module DbContext
→ 01000001 is applied
→ moduleDefinition.Version updated to "1.0.0.1"
```

---

## 3.4 Correct Governance Alignment

Under the Oqtane AI Playbook:

You must ensure:

* Migration filenames use 8 digit numeric format
* Migration attribute version matches filename
* `ModuleDefinition.ReleaseVersions` includes an entry for every new schema change
* `ModuleDefinition.Version` reflects the last installed version (updated automatically by Oqtane)
* RevisionNumber includes published release versions only
* RevisionNumber must not include development build increments

During development:

* Add a build-segment entry to `ReleaseVersions` for each new migration
* Example: `"1.0.0,1.0.0.1,1.0.0.2"`
* Only published releases belong in RevisionNumber

At release time:

* Update `ReleaseVersions` to include the release version
* Append that release to RevisionNumber

---

## 3.5 Why This Matters

If the new migration file exists but `ReleaseVersions` is not updated:

* `Install()` is never called
* `Database.Migrate()` is never called for the module context
* The column or table is never created
* The application fails silently or with a runtime error

The `__EFMigrationsHistory` evidence for Oqtane tenant migrations confirms this:
framework migrations run without `ReleaseVersions` because they use a direct `Database.Migrate()` call.
Module migrations do not have this shortcut — they require the `ReleaseVersions` list to be maintained.

---

# 4. Migration File Rules

Every migration must:

* Use exactly 8 numeric digits
* Follow `MMmmPPbb` format
* Be strictly increasing
* Match the version declared in the `Migration` attribute
* Correspond to an entry in `ReleaseVersions`

Example:

```
01000001_AddNotifyOnConflict.cs
→ [Migration("StudioElf.Module.Doquetain.01.00.00.01")]
→ ReleaseVersions must include "1.0.0.1"
```

No exceptions.

---

# 5. Migration Class Requirements

Each migration must:

* Inherit `MultiDatabaseMigration`
* Accept `IDatabase` in constructor
* Include:

```csharp
[DbContext(typeof(ModuleContext))]
[Migration("Fully.Qualified.Namespace.01.00.00.01")]
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

# 6.2 Table Naming Convention (OwnerModule Pattern)

## Rule Statement

All tables must follow a deterministic OwnerModule prefix pattern to ensure global uniqueness across the database.

The module identity is:

```
<Owner><ModuleName>
```

This identity must be applied exactly once.

If the table name is identical to the ModuleName, the name must not be repeated.

---

## Naming Requirements

All tables must:

- Use PascalCase
- Be prefixed with OwnerModule identity
- Contain no underscores
- Avoid plural guessing
- Be immutable after deployment
- Be globally unique across the database

---

## Canonical Pattern

Standard case:

```
<Owner><ModuleName><EntityName>
```

Special case where EntityName equals ModuleName:

```
<Owner><ModuleName>
```

Do not duplicate the module name.

---

## Examples

### Example 1 — Entity different from Module

Owner: StudioElf, Module: MyPlaybook, Table: DataTable → `StudioElfMyPlaybookDataTable`

### Example 2 — Table name equals Module name

Owner: StudioElf, Module: Storefront, Table: Storefront → `StudioElfStorefront` (not `StudioElfStorefrontStorefront`)

---

## AI Enforcement Requirement

When generating migrations, AI must:

1. Derive OwnerModule identity once
2. Compare EntityName to ModuleName
3. If equal, omit duplication
4. Validate final table name for deterministic correctness
5. Refuse to generate migrations that violate this rule

---

# 7. Model Contract Governance

Models should inherit from `ModelBase` to receive standard audit properties.

Optional:

```
Oqtane.Models.IDeletable
```

Rules:

* Inherit `ModelBase`
* Do not duplicate audit properties when inheriting `ModelBase`
* Implement `IDeletable` if soft delete is required
* Ensure the `DbContext` contains the corresponding `DbSet<T>` and mappings

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
* Ensure `DbSet<T>` exists
* Ensure model matches schema
* Ensure migration matches model
* Ensure `ReleaseVersions` includes an entry for the new migration

Schema, model, migration, and `ReleaseVersions` must remain aligned.

---

# 11. Runtime Aware Governance (Database Inspection Capability)

AI may inspect database state before generating migrations.

If possible:

1. Read connection string from configuration
2. Query `__EFMigrationsHistory`
3. Determine:

   * Has `01.00.00.00` executed?
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

---

# 12. Fresh Boilerplate Declaration (Clean Architectural State)

When a module is freshly created from the template:

State:

* Client untouched
* Server untouched
* Shared untouched
* No production data
* No releases
* Migration `01.00.00.00` is default scaffold

At this stage:

You may:

* Replace `01000000_InitializeModule.cs`
* Redefine schema
* Modify EntityBuilders
* Generate single authoritative baseline migration

You must:

* Define final entity model first
* Then generate baseline migration
* Follow versioning rules
* Set `ReleaseVersions` and RevisionNumber correctly

Do not assume legacy data.

---

# 13. AI Migration Safety Gate

Before generating a migration AI must confirm:

1. Current `ReleaseVersions` list in `ModuleInfo.cs`
2. Latest migration file in `Server/Migrations/`
3. Current RevisionNumber
4. Whether EntityBuilders were previously deployed
5. Whether migration history exists in database
6. Which execution path applies (Path A — framework, or Path B — module)

If unclear:

STOP and request clarification.

---

# Final Enforcement Summary

* Two execution paths exist: framework (direct `Database.Migrate()`) and module (via `ReleaseVersions` → `Install()`)
* Framework migrations are tracked by `__EFMigrationsHistory` alone
* Module migrations require a new `ReleaseVersions` entry AND a new migration file
* `ReleaseVersions` comparison is string equality against a list — not numeric `>`
* Migration filenames use 8-digit `MMmmPPbb` format
* Migration attribute version must match filename
* EntityBuilders are immutable after initial deployment
* Models inherit `ModelBase`
* All schema changes via new migrations
* `Down()` mandatory
* `ReleaseVersions`, model, migration, and DbContext must stay aligned

This rule is mandatory under 027 governance.

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

# 3. RevisionNumber Governance

## 3.1 Version Segment Format

All migration versions use:

```
MM.mm.PP.bb
```

Segments are:

* Major
* Minor
* Patch
* Build

Segments are separated by periods.

Example:

```
10.00.00.01
1.2.0.3
```

    * * 

      ## 3.2 What RevisionNumber Actually Is

      `ModuleInfo.RevisionNumber` is:
    * A comma separated list of release versions
    * Ordered chronologically
    * Represents published module revisions
    * Not a 4 segment mirror of migration version

Example:

```
"1.0.0,1.0.1,1.0.5,2.0.0"
```

Important:

* The build segment is not represented separately
* RevisionNumber does not use comma separated numeric segments like `01,02,00,02`
* That previous format was incorrect
    * * 

      ## 3.3 How Migration Execution Actually Works

      At runtime Oqtane compares:

      ```
      migrationVersion > ModuleDefinition.ReleaseVersion
      ```

      Comparison is numeric and segment based:

      ```
      MM.mm.PP.bb
      ```

      Missing segments are treated as zero.

      Example:

      ```
      ReleaseVersion = 10.0.0
      Treated as     = 10.00.00.00
      ```

      Therefore:

      ```
      10.00.00.01 > 10.00.00.00
      10.00.00.02 > 10.00.00.00
      ```

      Both will execute.

      This behavior is identical for:
    * Core migrations
    * Tenant migrations
    * Module migrations

Only the prefix changes.

    * * 

      ## 3.4 Correct Governance Alignment

      Under the Oqtane AI Playbook:

      You must ensure:
    * Migration filenames use 8 digit numeric format
    * Migration attribute version matches filename
    * ModuleDefinition.ReleaseVersion reflects the baseline release
    * RevisionNumber includes published release versions only
    * RevisionNumber must not be used as a 4 segment mirror of migration build increments

During development:

* You may increment only the build segment for schema changes
* You do not need to append every build increment to RevisionNumber
* Only published releases belong in RevisionNumber

At release time:

* Update ReleaseVersion appropriately
* Append that release to RevisionNumber
    * * 

      ## 3.5 Why This Matters

      If ReleaseVersion is wrong:
    * Migrations may not execute
    * Or may execute unexpectedly

If RevisionNumber is malformed:

* Upgrade tracking may fail
* Installed modules may not reflect proper release history

The two fields serve different purposes:

ReleaseVersion
→ Runtime migration baseline

RevisionNumber
→ Historical release tracking

They must not be conflated.

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

# 6.2 Table Naming Convention (OwnerModule Pattern)

## Rule Statement

All tables must follow a deterministic OwnerModule prefix pattern to ensure global uniqueness across the database.

The module identity is:

<Owner><ModuleName>

This identity must be applied exactly once.

If the table name is identical to the ModuleName, the name must not be repeated.

---

## Naming Requirements

All tables must:

- Use PascalCase
- Be prefixed with OwnerModule identity
- Contain no underscores
- Avoid plural guessing
- Be immutable after deployment
- Be globally unique across the database

---

## Canonical Pattern

Standard case:

<Owner><ModuleName><EntityName>

Special case where EntityName equals ModuleName:

<Owner><ModuleName>

Do not duplicate the module name.

---

## Examples

### Example 1 – Entity different from Module

Owner: StudioElf
Module: MyPlaybook
Table: DataTable

Result:

StudioElfMyPlaybookDataTable

---

### Example 2 – Table name equals Module name

Owner: StudioElf
Module: Storefront
Table: Storefront

Correct result:

StudioElfStorefront

Not:

StudioElfStorefrontStorefront

---

## Rationale

The OwnerModule prefix already guarantees uniqueness.

Repeating the module name when the table name matches the module:

- Adds no additional uniqueness
- Increases verbosity
- Breaks naming elegance
- Complicates migration readability

The database should reflect identity once, not redundantly.

---

## AI Enforcement Requirement

When generating migrations, AI must:

1. Derive OwnerModule identity once.
2. Compare EntityName to ModuleName.
3. If equal, omit duplication.
4. Validate final table name for deterministic correctness.
5. Refuse to generate migrations that violate this rule.

---

# 7. Model Contract Governance

AI commonly makes this mistake:

Models must inherit from `ModelBase`.

Correct contract:

Models should inherit from `ModelBase` so they receive the standard audit properties (for example: `CreatedBy`, `CreatedDate`, `ModifiedBy`, `ModifiedDate`) and consistent behavior across modules.

Optional:

```
Oqtane.Models.IDeletable
```

Rules:

* Inherit `ModelBase`
* Do not duplicate audit properties when inheriting `ModelBase`
* Implement `IDeletable` if soft delete is required
* Ensure the `DbContext` contains the corresponding `DbSet<T>` and mappings for the model contract

Accept `ModelBase` usage in module models.

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
* Ensure audit columns exist (provided by `ModelBase` do not implement `IAuditable` separately)
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
* Models inherit `ModelBase` (do not implement `IAuditable` separately)
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