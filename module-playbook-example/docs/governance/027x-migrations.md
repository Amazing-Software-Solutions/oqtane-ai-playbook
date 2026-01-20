# 027x – Database Migration Rules

## Scope

These rules govern **all database migrations** for Oqtane modules.

They exist to ensure migrations are:

- Deterministic
- Reversible
- Provider-agnostic
- Compatible with Oqtane’s multi-database execution model

Oqtane automatically discovers and executes module migrations during application startup.

These rules are **strictly enforced**.

---

## Rule 1: Migration Execution Model

- Migrations are executed automatically by Oqtane during startup
- Execution occurs when:
  - A migration exists with a version **greater than** `ModuleDefinition.ReleaseVersion`

**Reject if:**

- Manual migration execution is assumed
- Startup hooks or custom execution logic are introduced

---

## Rule 2: Migration File Naming

**Required format**

`Version_Description.cs`


### Version Rules

- Exactly **8 numeric digits**
- Strictly increasing
- Determines execution order
- Common format: `MMmmPPbb`
  - Major / Minor / Patch / Build
- Example:
  - Version `1.0.0.0` → `01000000`

### Description Rules

- PascalCase
- Describes the schema change

### Valid Examples

- `01000000_InitializeModule.cs`
- `02000000_AddPhase2Tables.cs`

**Reject if:**

- Version is not 8 digits
- Version is not increasing
- Filename does not follow the required pattern

---

## Rule 3: Migration Class Structure

All migrations must:

- Inherit from `MultiDatabaseMigration`
- Accept `IDatabase database` in the constructor
- Pass `database` to the base constructor

### Required Attributes

- `[DbContext(typeof(ModuleContext))]`
- `[Migration("Fully.Qualified.Namespace.Version")]`

The version in the `[Migration]` attribute **must match the filename version**.

**Example**

```csharp
[DbContext(typeof(ModuleContext))]
[Migration("Acme.Modules.Sample.01.00.00.00")]
```

**Reject if:**

* Any required attribute is missing
* Version mismatch exists
* Inheritance or constructor signature is incorrect

* * *

## Rule 4: EntityBuilder Usage (New Tables)

All new tables must:

* Have a corresponding EntityBuilder
* Reside in:

    ```
    Server/Migrations/EntityBuilders
    ```
* Inherit from:

    * `BaseEntityBuilder<T>` or
    * `AuditableBaseEntityBuilder<T>`
* Define:

    * Table name constant
    * Primary key
* Implement `BuildTable`

### Required Usage Pattern

```
var builder = new MyEntityBuilder(migrationBuilder, ActiveDatabase);
builder.Create();
```

**Reject if:**

* Tables are created inline without an EntityBuilder
* Provider-specific SQL is used without justification

* * *

## Rule 5: Up() Method Rules

The `Up()` method must:

* Perform **schema changes only**
* Use database-agnostic APIs
* Prefer EntityBuilders for table creation

### Allowed Operations

* Create tables
* Add columns
* Add indexes

**Reject if:**

* Raw SQL is used unnecessarily
* Provider-specific assumptions are made

* * *

## Rule 6: Down() Method (Mandatory)

Every migration must implement `Down()`.

The `Down()` method must:

* Fully reverse the operations in `Up()`
* Drop tables, columns, and indexes created in `Up()`

**Reject if:**

* `Down()` is missing
* `Down()` does not strictly reverse `Up()`

* * *

## Rule 7: Data Type Compatibility

* Use Oqtane helper methods in EntityBuilders

    * `AddStringColumn`
    * `AddIntegerColumn`
    * etc.
* Ensure compatibility with:

    * SQL Server
    * SQLite
    * PostgreSQL
    * MySQL

**Reject provider-specific SQL unless explicitly guarded.**

* * *

## Rule 8: DbContext and Model Synchronization

When adding new tables:

* Add a `DbSet<T>` to the module’s DbContext

When modifying schema:

* Update the corresponding model class

**Reject if:**

* DbContext is not updated
* Models do not reflect schema changes

* * *

## Rule 9: Module Release Version Update

After adding a migration:

* Update `ModuleDefinition.ReleaseVersion`
* The value **must match the latest migration version**

This is the mechanism Oqtane uses to trigger migrations.

**Reject if ReleaseVersion is not updated.**

* * *

## Validation Checklist

A migration is valid **only if all conditions are met**:

* Filename version is valid and increasing
* Inherits `MultiDatabaseMigration`
* `[DbContext]` and `[Migration]` attributes are correct
* `Up()` is database-agnostic
* `Down()` fully reverses `Up()`
* EntityBuilders are used for new tables
* DbContext is updated when required
* Models reflect schema changes
* `ModuleDefinition.ReleaseVersion` is updated

If any check fails, **reject the change**.