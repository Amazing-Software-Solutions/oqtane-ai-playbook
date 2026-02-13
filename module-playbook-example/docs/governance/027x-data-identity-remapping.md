## Rule: Identity Remapping Is Mandatory for Hierarchical Import

When implementing module import/export using `IPortable`, and the module contains multiple related entities (parent/child or deeper hierarchies), identity remapping must be explicitly implemented.

Raw database identity values (primary keys) must never be reused or assumed to match between environments.

Imports must remap identities deterministically and preserve relational integrity.

This rule applies to all modules with:

- Multiple related tables
- Foreign key relationships
- Self-referencing entities
- Deep object graphs
- Cross-entity dependencies

---

## Why This Rule Exists

Primary keys are environment-specific.

When importing content into another tenant or environment:

- Identity values will differ
- FK references will break if reused
- Data corruption can occur silently
- Partial imports can appear successful but be logically invalid

For simple modules (single table), this is trivial.

For complex hierarchies, careless remapping causes subtle, production-only defects.

---

## Mandatory Requirements

### 1. No Raw Identity Reuse

Exported IDs must be treated as temporary identifiers only.

On import:

- Insert parent records first
- Capture newly generated IDs
- Maintain an old→new ID mapping dictionary
- Remap all foreign keys using that mapping

Example pattern:

```csharp
var idMap = new Dictionary<int, int>();

// Insert parent
var newParentId = _repository.AddParent(parent);
idMap[parent.Id] = newParentId;

// Insert children
foreach (var child in children)
{
    child.ParentId = idMap[child.ParentId];
    _repository.AddChild(child);
}
```

---

### 2. Deterministic Ordering

Import must follow dependency order:

1. Root entities
2. First-level children
3. Nested children
4. Cross-references

Circular references must be handled explicitly (two-pass import if necessary).

---

### 3. Tenant Isolation

Imported data must:

- Be assigned to the target tenant
- Not reference source-tenant IDs
- Not leak cross-tenant identifiers

TenantId must always be re-evaluated and set explicitly during import.

---

### 4. Version Awareness

If schema versions differ:

- Version parameter must be honored
- Transformations must be explicit
- Breaking changes must be handled intentionally

Silent schema drift is prohibited.

---

### 5. Idempotent Safety (When Possible)

Where feasible:

- Duplicate detection logic should exist
- Natural keys may be used to detect existing records
- Import should avoid unintended duplication

---

## Prohibited Patterns

❌ Reusing exported identity values directly

❌ Blind bulk insert of serialized data

❌ Assuming FK values will remain valid

❌ Ignoring TenantId reassignment

❌ Importing children before parents

❌ Ignoring schema version

---

## Acceptable Patterns

✔ Explicit ID mapping dictionary

✔ Dependency-aware import sequencing

✔ Two-pass remapping for circular graphs

✔ Explicit TenantId reassignment

✔ Clear version-based branching logic

---

## AI Mandatory Warning Block

⚠️ AI GOVERNANCE WARNING – IDENTITY REMAPPING REQUIRED ⚠️

This module implements hierarchical import/export.

You MUST:

- Remap all primary keys during import
- Maintain an old→new ID dictionary
- Reassign all foreign keys using the remapped IDs
- Preserve referential integrity
- Explicitly handle TenantId
- Respect version differences

You MUST NOT:

- Reuse original identity values
- Bulk insert serialized entities blindly
- Assume identity consistency between environments

If you cannot guarantee referential integrity and identity remapping, STOP and request clarification.

---

## Enforcement

Code review must confirm:

- ID mapping structure exists
- Import order is dependency-aware
- No raw ID reuse occurs
- Tenant isolation is enforced
- Version parameter is respected

Failure to implement identity remapping correctly invalidates the portability implementation.