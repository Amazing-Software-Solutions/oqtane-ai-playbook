# Migration Governance

Understanding How Schema Changes Work in OAP and MPE

Database migrations are not just technical files.
They are the history of your module’s structure.

The Oqtane AI Playbook enforces migration discipline because incorrect migrations can break upgrades, tenants, and production systems.

This section explains what OAP expects and why.

---

You are absolutely right to call that out.

The previous guide wording softens the comparison logic too much and could imply that ReleaseVersion and migration numbers merely “relate” to each other. In reality, the execution rule is precise and deterministic.

Below is a corrected section that should replace the execution model portion in:

oqtane-ai-playbook/playbook-guide/governance/migrations.md

This version reflects the runtime behavior clearly and without ambiguity.

---

## Migration Execution Model (Confirmed Runtime Behavior)

Oqtane executes migrations automatically at application startup.

A migration runs when:

migrationVersion > ModuleDefinition.ReleaseVersion

This comparison is strict and deterministic.

Versions are compared as four numeric segments:

MM.mm.PP.bb  
(Major.Minor.Patch.Build)

Missing segments are treated as zero.

Examples:

10.0.0  
is interpreted as  
10.00.00.00

10.00.00.01 > 10.00.00.00  
10.00.00.02 > 10.00.00.00

Therefore:

If ReleaseVersion = 10.0.0  
Then migrations 10.00.00.01 and 10.00.00.02 WILL execute.

This is not accidental behavior.  
It is the intended version comparison model.

---

### Scope Consistency

This execution model applies equally to:

• Oqtane core migrations  
• Tenant migrations  
• Module migrations

Only the scope prefix differs.

For example:

Tenant.10.00.00.02  
My.Module.01.00.00.01

The comparison logic is identical.

---

### What ReleaseVersion Actually Represents

ReleaseVersion is the baseline.

It does NOT need to match a migration exactly.  
It defines the minimum version already applied.

Any migration with a strictly greater version will execute automatically.

This is why build-segment migrations accumulate correctly during development.

---

This version:

• Removes ambiguity  
• Explicitly states strict greater-than comparison  
• Confirms equal behavior across core, tenant, and modules  
• Avoids implying matching is required  
• Aligns precisely with runtime behavior

If you would like, I can now:

• Refactor the entire migrations guide so it flows logically from execution model → development workflow → governance enforcement  
• Or reconcile this section with the RevisionNumber enforcement language so there is zero conceptual drift between runtime behavior and playbook governance

---

### The Model We Use (Baseline + Build)

During development:

• Keep ReleaseVersion as major.minor.patch
• Do not include the build segment in ReleaseVersion
• Increment only the build segment in migration filenames

Example:

ReleaseVersion = 1.0.0

Migrations:

01000001_AddDescription.cs
01000002_AddIndex.cs

These will execute automatically because they are greater than 01.00.00.00.

ReleaseVersion signals when you publish.
Build increments represent development schema steps.

---

### Required Structure for Every Migration

Every migration must:

* Use exactly 8 numeric digits in the filename
* Be strictly increasing
* Inherit MultiDatabaseMigration
* Include both Up() and Down()
* Be schema-only
* Be provider-agnostic

Example:

01000003_AddForeignKey.cs

---

### RevisionNumber Must Match the Latest Migration

When you add a migration:

You must update ModuleInfo.cs RevisionNumber.

Format:

Comma separated, no spaces, 2 digits per segment.

Example:

Migration: 01000002
RevisionNumber: "01,00,00,02"

This ensures deterministic installs and upgrades.

---

### EntityBuilder Rule (Extremely Important)

EntityBuilders define the original schema only.

They are used by:

01000000_InitializeModule.cs

After initial deployment:

EntityBuilders must NEVER be modified.

All schema evolution must happen in new migration files.

If you need to:

* Add a column
* Change a foreign key
* Modify constraints

Create a new migration.

Do not edit the EntityBuilder.

EntityBuilders represent history.
Migrations represent change.

---

### Why This Discipline Exists

Without strict migration governance:

• Tenants upgrade inconsistently
• Development and production drift
• AI generates unsafe schema changes
• Database state becomes unpredictable

OAP enforces this so that:

AI becomes predictable
Schema evolution is traceable
Releases are clean
Upgrades are safe

---

### Critical Rule

Only increase the build segment during development unless explicitly instructed otherwise.

Do not randomly change major or minor versions for schema tweaks.

Major and minor reflect release intent.
Build reflects incremental development.

---

### Quick Version Reference

Migration filename:

01000001

RevisionNumber:

01,00,00,01

ReleaseVersion:

1.0.0

If these are misaligned, migrations may not execute as expected.

---

### In Simple Terms

ReleaseVersion says:

"This is the version we shipped."

Migration build numbers say:

"These are the database changes since that release."

Keep those two ideas separate.

That separation is what makes Oqtane upgrades safe.


