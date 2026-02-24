# 027x – Database Migration Governance

⚠ AI MIGRATION SAFETY WARNING

Before generating any database migration, confirm:

1. Current ModuleDefinition.ReleaseVersion
2. Latest migration version present
3. ModuleInfo.RevisionNumber
4. EntityBuilders have not been modified

If any of the above is unclear, STOP and request clarification.

---

## AI ENFORCEMENT WARNING

After generating any migration:

1. You MUST create a new migration file
2. You MUST increment the version correctly
3. You MUST update ModuleInfo.cs RevisionNumber
4. You MUST ensure RevisionNumber matches the migration version exactly
5. You MUST NOT modify existing EntityBuilder files after initial deployment

Failure to comply results in an invalid migration.

---

# 1. Migration Execution Model (Confirmed Behavior)

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
Then migrations 10.00.00.01 and 10.00.00.02 WILL execute.

This applies equally to:

• Oqtane core migrations
• Tenant migrations
• Module migrations

Only the scope prefix differs.

This behavior is by design.

---

# 2. Version Structure

Migration version format:

MMmmPPbb

Where:

MM = Major
mm = Minor
PP = Patch
bb = Build

Filename format:

01000000_InitializeModule.cs
01000001_AddDescription.cs

Exactly 8 digits. No exceptions.

Reject if:

• Not exactly 8 digits
• Not strictly increasing
• Does not follow MMmmPPbb pattern

---

# 3. Development Version Strategy (Clarified)

During a development cycle:

• Set ModuleDefinition.ReleaseVersion to major.minor.patch only
• Do NOT include the build segment in ReleaseVersion
• Use the build segment in migration filenames for incremental schema changes

Example:

ReleaseVersion = 1.2.0
This is treated as 01.02.00.00

You may create:

01020001_AddColumn.cs
01020002_AddIndex.cs
01020003_AddForeignKey.cs

All will execute because:

01.02.00.01 > 01.02.00.00

This allows incremental development migrations.

Important:

The ReleaseVersion acts as the baseline.
Migrations above it execute.

---

# 4. RevisionNumber Synchronization (Critical Rule)

After creating a migration:

You MUST update ModuleInfo.cs:

public override string RevisionNumber => "01,02,00,03";

Mapping rule:

Migration file:
01020003_AddIndex.cs

RevisionNumber must be:
"01,02,00,03"

Rules:

• Comma separated
• No spaces
• Exactly 4 segments
• Must match latest migration

If this is incorrect:

• Migrations may not execute
• Schema drift may occur
• Production failures may occur

This rule is mandatory.

---

# 5. EntityBuilder Immutability Rule (CRITICAL)

EntityBuilder files define the INITIAL schema only.

They are used exclusively by:

01000000_InitializeModule.cs

After initial deployment:

YOU MUST NEVER MODIFY ENTITYBUILDERS.

Why:

EntityBuilders are historical artifacts.
They represent the original schema state.

All schema evolution must occur through new migration files.

---

## Correct Pattern

Initial schema:

01000000_InitializeModule.cs
Uses EntityBuilders

Schema changes:

01000001_AddDescription.cs
01000002_UpdateForeignKey.cs

Pure migration logic only.

---

## Incorrect Pattern

Modifying:

CreatorProfileEntityBuilder.cs

To change a foreign key.

This is forbidden.

---

# 6. Migration Class Requirements

All migrations must:

• Inherit from MultiDatabaseMigration
• Accept IDatabase database in constructor
• Include [DbContext(typeof(ModuleContext))]
• Include [Migration("Fully.Qualified.Namespace.MM.MM.PP.BB")]

The version in the attribute must match the filename.

Reject if mismatch exists.

---

# 7. Up() Method Rules

Up() must:

• Perform schema changes only
• Be provider agnostic
• Use EntityBuilders for new tables

Allowed:

• Create tables
• Add columns
• Add indexes
• Add foreign keys

Reject if:

• Raw SQL used unnecessarily
• Provider specific assumptions made

---

# 8. Down() Method (Mandatory)

Every migration must implement Down().

Down() must:

• Fully reverse Up()
• Remove only what Up() created

Reject if missing.

---

# 9. DbContext and Model Synchronization

When schema changes occur:

• Update DbContext DbSet<T>
• Update corresponding model classes

Reject if:

• DbContext not updated
• Model and schema diverge

---

# 10. ReleaseVersion Governance

ReleaseVersion is:

• The module baseline version
• Not the migration counter

It should typically be:

major.minor.patch

Example:

1.2.0

During development, you increment only migration build segments.

At official release:

You may bump:

Major
Minor
Patch

Then restart build sequence appropriately.

---

# 11. Migration Pattern is Identical to Oqtane Core

The execution engine for:

• Core migrations
• Tenant migrations
• Module migrations

Is the same.

Only the prefix differs:

Tenant.10.00.00.02
Acme.Module.Sample.01.02.00.01

The comparison logic is identical.

This is confirmed.

---

# Validation Checklist

A migration is valid only if:

• Filename version is 8 digits
• Version is strictly increasing
• Only build segment incremented unless instructed
• RevisionNumber updated and matches
• EntityBuilders not modified
• Inherits MultiDatabaseMigration
• Attributes correct
• Up() schema only
• Down() reversible
• DbContext updated
• Models updated

If any check fails:

Reject the change.

---

Now this is clean, deterministic, and aligned with actual Oqtane runtime behavior.

If you would like, next we can:

• Convert this into tutorial format for readability
• Add visual diagrams for version comparison
• Add an AI warning block specific to migration generation
• Or tighten Rule 3 wording around build increments even further

This is one of the most important governance documents in your entire playbook.
