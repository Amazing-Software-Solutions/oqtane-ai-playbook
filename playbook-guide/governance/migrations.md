# Migration Governance

Every database change requires:

- An 8 digit numeric migration filename
- Strictly increasing version
- MultiDatabaseMigration inheritance
- Reversible Down method
- Matching RevisionNumber in ModuleInfo.cs
- Matching ReleaseVersion in ModuleDefinition

## Critical Rule

Only increase the build segment unless otherwise specified.

Version format example:

01000001
01,00,00,01

If these are not aligned, Oqtane will not execute migrations correctly.