# Module Portability

**Rule: Complete & Deterministic Module Import/Export**

## Status

Mandatory When Implemented (Opt-In Governance)

---

## 1. Purpose

Oqtane provides the `IPortable` interface to enable module content portability via import/export functionality.

When a module opts in to portability, it **must export and import the complete, consistent, and restorable state of the module**.

Partial portability is prohibited.

---

## 2. Framework Context

Oqtane supports module portability via:

```
public interface IPortable
{
    // You Must Set The "ServerManagerType" In Your IModule Interface

    string ExportModule(Module module);

    void ImportModule(Module module, string content, string version);
}
```

This allows:

- Exporting module content
* Importing module content
* File-based import/export via the administrative UI
* Cross-tenant or cross-environment portability

Portability is optional.

However:

> 
> 
> If implemented, it must be complete and correct.
> 

---

## 3. Governance Requirements

### 3.1 Completeness Rule

If `IPortable` is implemented, the module must:

* Export all persisted data required to fully reconstruct the module
* Include hierarchical relationships
* Include child entities
* Include configuration settings stored outside primary tables
* Preserve logical relationships (not just flat records)

Exporting only the primary table is insufficient if:

* Child tables exist
* Lookup tables are required
* Foreign key relationships are involved
* Metadata is required for rendering

---

### 3.2 Determinism Rule

Importing exported data must:

* Recreate the same functional state
* Not duplicate data unintentionally
* Not corrupt foreign key relationships
* Respect tenant isolation
* Be idempotent when possible

The following must be validated:

* Server mode
* WebAssembly mode (API path)
* Multi-tenant scenarios

---

### 3.3 Hierarchical Data Handling

For simple modules (single table):

* JSON export of table data is usually sufficient

For complex modules (multiple tables / tree structures):

The export must:

* Serialize hierarchy in correct order
* Preserve parent-child mapping
* Handle identity regeneration
* Remap foreign keys correctly during import

AI-generated implementations often fail here.

This must be manually reviewed.

---

## 4. AI Governance Warning Block

The following block must appear in this file:

---

### ⚠️ AI IMPLEMENTATION WARNING — MODULE PORTABILITY

Before generating `IPortable` code:

You must:

1. Identify ALL tables involved in the module
2. Identify ALL child and related entities
3. Identify ALL configuration or settings data
4. Confirm multi-tenant isolation
5. Confirm referential integrity during re-import

You must NOT:

* Export only a primary entity if children exist
* Ignore foreign key relationships
* Hardcode IDs
* Assume identity values will remain stable
* Ignore version parameter

You must generate:

* Structured JSON export
* Safe and validated import logic
* Relationship remapping logic if required

If unsure about hierarchy depth — ask before generating code.

Portability must restore the complete functional state.

---

## 5. Enforcement Criteria

A module implementing `IPortable` is non-compliant if:

* Imported module is missing child records
* Exported data does not rehydrate correctly
* Import causes duplicate rows on repeated execution
* Foreign keys are broken after import
* Tenant boundaries are violated

---

## 6. Why This Matters

Proper portability ensures:

* Safe migration between environments
* Reliable tenant cloning
* Backup & restore scenarios
* Marketplace distribution readiness
* Predictable behavior in enterprise deployments

Improper portability results in:

* Silent data loss
* Partial imports
* Production inconsistencies
* Broken UI rendering
* Corrupted relationships

---

## 7. Best Practice Pattern

Recommended:

* Use DTO structures for export
* Serialize complete object graphs
* Validate import preconditions
* Wrap import in transactional logic
* Handle version parameter explicitly
* Document schema version compatibility

---

## 8. Cross-Reference

This rule complements:

* 027x-execution-parity.md
* 027x-multi-tenancy.md
* 027x-data-layer-governance.md
* 027x-javascript-usage.md
* 027x-ui-css-and-styling.md