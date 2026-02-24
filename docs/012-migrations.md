# 12 — Database Migrations: Startup Execution, Versioning, and Multi-Database Safety

Database migrations in Oqtane are fundamentally different from “typical” Entity Framework Core usage.

Many issues in Oqtane modules stem from assuming standard EF Core migration behavior, especially when AI tools generate code based on generic .NET patterns.

This chapter defines the **correct migration model**, **non-negotiable rules**, and **safe patterns** for evolving module data in Oqtane.

---

## The Oqtane Migration Model (Mental Model)

In Oqtane:

- Migrations are **executed at application startup**
- Migration execution is **owned by the framework**
- Migrations must support **multiple database providers**
- Versioning is **module-driven**, not developer-driven

Modules do not decide *when* migrations run.
They only define *what* changes occur.

---

## What Triggers a Migration

A migration is triggered when:

- The module’s **ReleaseVersion** is higher than the last applied migration version

At startup, Oqtane:
1. Scans loaded modules
2. Compares module versions
3. Executes any missing migrations in order

There is no manual execution step.
There is no user-driven migration command.

---

## Migration Ownership and Location

All module migrations must:

- Reside in the **Server** project
- Be associated with the module’s DbContext
- Be discoverable at startup

Migrations are part of the module’s **deployment contract**, not its runtime logic.

---

## Migration Class Requirements

Each migration must:

- Inherit from `MultiDatabaseMigration`
- Accept `IDatabase` via constructor
- Pass `IDatabase` to the base class

This ensures:
- Database-provider awareness
- Correct SQL generation
- Multi-database compatibility

---

## Required Attributes

Every migration class must include:

- `[DbContext(typeof(ModuleDbContext))]`
- `[Migration("Fully.Qualified.Namespace.Version")]`

The migration identifier:
- Must be unique
- Must be stable
- Must match the migration version number

These attributes are not optional.

---

## Migration File Naming

Migration file names follow this format:

MMmmPPbb

(Major, Minor, Patch, Build)

Example:
- Version 1.0.0.0 → `01000000`

---

## EntityBuilders: The Key to Multi-Database Safety

Oqtane supports multiple database providers.

Raw SQL or provider-specific APIs are unsafe by default.

To ensure compatibility, new tables must be defined using **EntityBuilders**.

### EntityBuilder Rules

- Each new table must have a corresponding EntityBuilder
- EntityBuilders must:
  - Inherit from `BaseEntityBuilder<T>` or `AuditableBaseEntityBuilder<T>`
  - Define table name and primary key
  - Define columns using Oqtane helper methods

EntityBuilders exist to abstract database differences safely.

---

## Up() Method Responsibilities

The `Up()` method must:

- Apply schema changes
- Use database-agnostic APIs
- Rely on EntityBuilders for table creation
- Avoid raw SQL unless absolutely necessary

Common actions:
- Create tables
- Add columns
- Create indexes

Migrations should assume they may be executed automatically during startup.

---

## Down() Method Responsibilities

The `Down()` method must:

- Reverse the changes made in `Up()`
- Be safe to execute
- Use database-agnostic APIs

Down methods are critical for:
- Failed upgrades
- Controlled rollbacks
- Development and testing scenarios

Skipping `Down()` leads to fragile upgrade paths.

---

## Context and Model Synchronization

Whenever a migration changes schema:

- Model classes in **Shared** must be updated
- The module DbContext must be updated accordingly

Schema, models, and context must evolve together.

Drift between these layers leads to runtime failures.

---

## Release Baseline and Build Migration Model

The Oqtane AI Playbook adopts the baseline + build model.

ReleaseVersion defines the published module baseline (major.minor.patch).

Migration versions follow MM.mm.PP.bb and may increment the build segment during development.

Migrations execute when:

migrationVersion > ReleaseVersion

Developers must:

- Increment only the build segment during development
- Update ModuleInfo.RevisionNumber to latest migration
- Never modify EntityBuilders after initial deployment
- Maintain reversible migrations

This ensures runtime alignment, deterministic startup, and safe multi-tenant upgrades.

---

## Forbidden Patterns (Reject Immediately)

The following patterns must never appear in module migrations:

- Manual migration execution
- Runtime-triggered migrations
- Raw SQL without provider guards
- Ignoring Down() methods
- Provider-specific assumptions
- Storing migration state manually

These patterns bypass Oqtane’s migration contract.

---

## AI Failure Modes in Migrations

Without governance, AI frequently generates:

- Standard EF Core `Migration` classes
- `Update-Database` instructions
- Raw SQL migrations
- One-way schema changes
- Provider-specific column types

These approaches are incompatible with Oqtane.

---

## Rejection Rules (Non-Negotiable)

Reject any migration-related change if:

- It does not inherit from `MultiDatabaseMigration`
- Required attributes are missing
- EntityBuilders are not used for new tables
- Raw SQL is used without justification
- Down() is missing or incomplete
- Module version is not updated

Migration correctness is more important than speed.

---

## Why This Matters

Database migrations:

- Are difficult to undo
- Affect every tenant
- Persist long after code is replaced

Mistakes here compound silently.

A strict migration model protects:
- Data integrity
- Upgrade safety
- Multi-database compatibility
- Long-term maintainability


