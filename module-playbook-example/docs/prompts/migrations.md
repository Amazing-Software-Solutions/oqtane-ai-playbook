# AI Instruction: Migrations Governance

**Instruction Context**: When the user requests to generating or modifying database migrations or EntityBuilders., you must load and execute this file.

---

## Mandatory Context

Before responding, you MUST:

1. Read `.github/copilot-instructions.md`
2. Read `docs/governance/027-rules-index.md`
3. Read `docs/governance/027x-migrations.md`

If any of the above are missing, **STOP and refuse**.

---

## Migration Rules (Non-Negotiable)

You MUST:
- Use an exact 8-numeric-digit format `MMmmPPbb` for migration files (e.g., `01000001_AddColumn.cs`) and matching `[Migration("Namespace.01.00.00.01")]` attributes.
- Inherit from `MultiDatabaseMigration`.
- Implement a `Down()` method that exactly reverses `Up()`.
- Treat EntityBuilders (`01000000_InitializeModule.cs`) as immutable after initial deployment.
- Ensure all new table names follow the strict `<Owner><ModuleName><EntityName>` OwnerModule prefix pattern to guarantee global uniqueness (e.g. `StudioElfMyPlaybookDataTable`). Do not duplicate the ModuleName if it matches EntityName.
- Update `ModuleInfo.ReleaseVersions` so the migration runs via `Install()`.

You MUST NOT:
- Generate EF Core code-first commands.
- Modify EntityBuilders for schema evolution after baseline (use a new migration instead).
- Assume framework migrations and module migrations share the same execution behavior.

---

## Expected Output
- A migration class inheriting `MultiDatabaseMigration`.
- The exact 8-digit filename and attribute.
- Strict table naming compliant with the OwnerModule rule.
