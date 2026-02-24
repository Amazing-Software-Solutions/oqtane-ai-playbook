# Migration Governance

Understanding How Schema Changes Work in OAP and MPE

Database migrations are not just technical files.
They are the history of your module’s structure.

The Oqtane AI Playbook enforces migration discipline because incorrect migrations can break upgrades, tenants, and production systems.

This section explains what OAP expects and why.

---

## How Oqtane Actually Executes Migrations

Oqtane compares versions as four numeric segments:

Major.Minor.Patch.Build

Example:

ReleaseVersion = 1.0.0
Is treated internally as:

01.00.00.00

If you create migrations:

01000001
01000002

Both are greater than 01.00.00.00 and will execute.

This is by design.

ReleaseVersion defines the baseline.
Build segment migrations accumulate during development.

---

## The Model We Use (Baseline + Build)

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

## Required Structure for Every Migration

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

## RevisionNumber Must Match the Latest Migration

When you add a migration:

You must update ModuleInfo.cs RevisionNumber.

Format:

Comma separated, no spaces, 2 digits per segment.

Example:

Migration: 01000002
RevisionNumber: "01,00,00,02"

This ensures deterministic installs and upgrades.

---

## EntityBuilder Rule (Extremely Important)

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

## Why This Discipline Exists

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

## Critical Rule

Only increase the build segment during development unless explicitly instructed otherwise.

Do not randomly change major or minor versions for schema tweaks.

Major and minor reflect release intent.
Build reflects incremental development.

---

## Quick Version Reference

Migration filename:

01000001

RevisionNumber:

01,00,00,01

ReleaseVersion:

1.0.0

If these are misaligned, migrations may not execute as expected.

---

## In Simple Terms

ReleaseVersion says:

"This is the version we shipped."

Migration build numbers say:

"These are the database changes since that release."

Keep those two ideas separate.

That separation is what makes Oqtane upgrades safe.


