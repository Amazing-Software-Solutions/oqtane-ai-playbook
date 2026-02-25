# 027x – Database Migration Governance

This document defines the authoritative rules for database migrations in Oqtane modules.

It exists to:

* Prevent schema drift
* Prevent incorrect AI generated migrations
* Ensure deterministic installs
* Align with Oqtane runtime execution behavior

This rule is mandatory.

---

# AI MIGRATION SAFETY GATE

Before generating or modifying any migration, AI MUST confirm:

1. Current ModuleDefinition.ReleaseVersion
2. Latest existing migration version
3. Current ModuleInfo.RevisionNumber
4. EntityBuilders have not been modified after initial deployment

If any of the above is unclear:

STOP.
Request clarification.
Do not generate a migration.

---

# 1. Migration Execution Model (Runtime Behavior Confirmed)

Oqtane executes migrations automatically at application startup.

A migration will run when:

migrationVersion > ModuleDefinition.ReleaseVersion

Versions are compared as four numeric segments:

MM.mm.PP.bb

Missing segments are treated as zero.

Examples:

10.0.0 is treated as 10.00.00.00
10.00.00.01 > 10.00.00.00
10.00.00.02 > 10.00.00.00

Therefore:

If ReleaseVersion = 10.0.0
Then 10.00.00.01 and 10.00.00.02 WILL execute.

This applies equally to:

* Oqtane core migrations
* Tenant migrations
* Module migrations

Only the scope prefix differs.

This behavior is by design.

---

# 2. Version Structure and File Naming

Migration filenames MUST:

* Contain exactly 8 numeric digits
* Follow MMmmPPbb pattern
* Be strictly increasing
* Include a descriptive suffix


Examples:

01000000_InitializeModule.cs
01000001_AddDescription.cs
01020003_AddIndex.cs

Reject if:

* Not exactly 8 digits
* Not strictly increasing
* Does not follow MMmmPPbb pattern

No exceptions.

---

# 3. Development Version Strategy (Baseline + Build Pattern)

During a development cycle:

* ModuleDefinition.ReleaseVersion MUST be major.minor.patch only
* ReleaseVersion MUST NOT include the build segment
* Increment only the build segment in migration filenames

Example:

ReleaseVersion = 1.2.0
Runtime interprets this as 01.02.00.00

Valid development migrations:

01020001_AddColumn.cs
01020002_AddIndex.cs
01020003_AddForeignKey.cs

All execute because:

01.02.00.01 > 01.02.00.00

ReleaseVersion defines the baseline.
Build segment accumulates schema steps.

At official release:

* You may bump Major
* You may bump Minor
* You may bump Patch

Then restart build numbering appropriately.

---

# 4. RevisionNumber Synchronization (Critical Enforcement Rule)

After creating a migration:

You MUST update ModuleInfo.cs RevisionNumber.

Example:

Migration file:
01020003_AddIndex.cs

RevisionNumber must be:

"01,02,00,03"

Rules:

* Exactly 4 segments
* Comma separated
* No spaces
* Must match latest migration exactly

If misaligned:

* Migration execution may fail
* Schema drift may occur
* Production inconsistencies may occur

This rule is mandatory.

---

# 5. EntityBuilder Immutability Rule (CRITICAL)

EntityBuilder files define the INITIAL schema only.

They are used exclusively by:

01000000_InitializeModule.cs

After initial deployment:

EntityBuilders MUST NEVER be modified.

They are historical artifacts.

All schema evolution MUST occur through new migration files only.

---

## Correct Pattern

Initial:

01000000_InitializeModule.cs
Uses EntityBuilders

Changes:

01000001_AddColumn.cs
01000002_UpdateForeignKey.cs

Migration logic only.

---

## Incorrect Pattern

Modifying:

CreatorProfileEntityBuilder.cs

To change foreign keys or schema.

This is forbidden.

---

# 6. Model Contract Governance

AI MUST NOT assume module entities inherit from ModelBase.

This is incorrect for module development.

All persistent module entities MUST:

* Implement IAuditable from Oqtane.Models
* Optionally implement IDeletable when soft delete is required

They MUST NOT inherit from ModelBase.

Why:

* Oqtane modules use auditing interfaces
* AuditableBaseEntityBuilder requires IAuditable
* Soft delete patterns rely on IDeletable
* Prevents architectural drift

Reject any ModelBase usage in module entities.

---

# 7. Table Naming Convention (OwnerModule Pattern)

All module tables MUST follow:

OwnerModuleEntityName

Pascal Case.
No underscores.
No generic names.

Examples:

AcmeBlogPost
PlaybookGovernedExample

This prevents:

* Cross module naming collisions
* Ambiguous table ownership
* Multi tenant confusion

Enforce strict naming discipline.

---

# 8. Migration Class Requirements

Every migration must:

* Inherit MultiDatabaseMigration
* Accept IDatabase in constructor
* Include [DbContext(typeof(ModuleContext))]
* Include [Migration("Fully.Qualified.Namespace.MM.MM.PP.BB")]

The version in the attribute MUST match the filename.

Reject mismatches.

---

# 9. Up() Method Rules

Up() must:

* Perform schema changes only
* Be provider agnostic
* Use EntityBuilders for new tables

Allowed:

* Create tables
* Add columns
* Add indexes
* Add foreign keys

Reject:

* Raw SQL without necessity
* Provider specific assumptions
* Data manipulation logic

---

# 10. Down() Method (Mandatory)

Every migration MUST implement Down().

Down() must:

* Fully reverse Up()
* Remove only what Up() created

Reject if missing or incomplete.

---

# 11. DbContext and Model Synchronization

When schema changes occur:

* Update DbContext DbSet<T>
* Update model classes
* Ensure auditing interfaces implemented

Reject if:

* DbContext not updated
* Model and schema diverge

---

# 12. Migration Pattern Consistency with Oqtane Core

The migration execution engine is identical for:

* Core migrations
* Tenant migrations
* Module migrations

Only the prefix differs.

Examples:

Tenant.10.00.00.02
Acme.Module.Sample.01.02.00.01

Comparison logic is identical.

Confirmed.

---

# Validation Checklist

A migration is valid only if:

* 8 digit filename
* Strictly increasing
* Only build segment incremented during development
* RevisionNumber matches
* EntityBuilders untouched
* Inherits MultiDatabaseMigration
* Attributes correct
* Up() schema only
* Down() reversible
* DbContext updated
* Model implements IAuditable
* Table follows OwnerModule convention

If any check fails:

Reject the change.

---
