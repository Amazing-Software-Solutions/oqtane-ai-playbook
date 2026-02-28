# 027x-runtime-awareness

Runtime Aware Governance

---

# 1. Purpose

Runtime Awareness is a mandatory governance layer in the Oqtane AI Playbook.

AI must not assume environment state.

AI must inspect and validate the actual runtime condition of the solution before generating architecture, migrations, packaging logic, or framework feature usage.

Static policy without environment validation leads to:

- Incorrect migrations
- Incompatible framework usage
- Broken deployments
- Governance drift

Runtime Awareness converts static rules into environment-adaptive governance.

---

# 2. Core Principle

AI must validate runtime state before generating code that depends on:

- Oqtane framework version
- Migration execution state
- Database baseline condition
- Feature availability
- Production versus development status

Failure to verify environment state is a governance violation.

---

# 3. Runtime Validation Categories

## 3.1 Framework Version Awareness

AI must verify the installed Oqtane version before using version-dependent features.

### Detection Methods

1. Inspect:
Oqtane.Shared.Constants.Version
2. Inspect installed Oqtane package version
3. Inspect database metadata if required

### Enforcement

If a feature requires a minimum version:

Example:

- ISiteTask requires Oqtane 10.1+

If version &lt; required version:

AI must:

- Suggest alternative architecture
- Or explicitly warn that the feature is unavailable

AI must never assume feature availability.

---

## 3.2 Migration State Awareness

Before generating or modifying migrations, AI must determine:

- Has 01.00.00.00 been executed?
- Is \_\_EFMigrationsHistory populated?
- What is the current ModuleDefinition.ReleaseVersion?
- What is the ModuleInfo.RevisionNumber?

### Database Check

Inspect:

\_\_EFMigrationsHistory table

If migration 01.00.00.00 exists:

- Baseline has been executed
- EntityBuilders are immutable
- Initial migration must not be replaced

If no migrations exist:

- Baseline migration may be redefined
- DbContext schema may be reshaped
- No backward compatibility constraints exist

---

## 3.3 Baseline Versus Production Detection

AI must determine:

### Fresh Template State

Indicators:

- Default 01.00.00.00 migration
- No custom entities
- No additional migrations
- Empty \_\_EFMigrationsHistory
- No production data

In this state:

- Baseline migration may be replaced
- EntityBuilders may be modified
- DbContext may be restructured

### Active or Production State

Indicators:

- Additional migrations exist
- ReleaseVersion differs from template
- \_\_EFMigrationsHistory contains entries
- Data present in module tables

In this state:

- EntityBuilders must never be modified
- Schema must evolve only through new migrations
- Backward compatibility is required

---

## 3.4 Feature Substitution Awareness

AI must evaluate whether the requested feature is architecturally correct for the runtime.

Example:

If user requests:

- A Scheduled Job

And runtime version &gt;= 10.1

AI must evaluate whether:
ISiteTask is a better fit.

If workload is:

- User initiated
- Ad hoc
- UI-triggered
- Asynchronous

Then:
AI should suggest SiteTask over Scheduled Job.

Governance requires reasoning, not blind compliance.

---

## 3.5 Packaging and Static Asset Awareness

Before generating packaging logic, AI should:

- Inspect Client and Server obj/project.assets.json
- Detect transitive dependencies
- Determine static web asset requirements

Static web assets must:

Follow the exact path under:
Oqtane.Server/wwwroot/\_content/{PackageName}/

Example:
MudBlazor must resolve to:
Oqtane.Server/wwwroot/\_content/MudBlazor/

AI must not invent asset paths.

---

# 4. Migration Runtime Alignment

Runtime Awareness must integrate with migration governance.

Confirmed behavior:

Oqtane executes migrations automatically at startup when:

migrationVersion &gt; ModuleDefinition.ReleaseVersion

Version comparison uses:

MM.mm.PP.bb

Missing segments are treated as zero.

Example:

10.0.0 is treated as 10.00.00.00
10.00.00.01 &gt; 10.00.00.00
10.00.00.02 &gt; 10.00.00.00

Therefore:

If ReleaseVersion = 10.0.0
Then migrations 10.00.00.01 and 10.00.00.02 will execute.

This applies equally to:

- Oqtane core migrations
- Tenant migrations
- Module migrations

Only the scope prefix differs.

AI must respect this execution model when generating migrations.

---

# 5. Enforcement Rules

AI must:

1. Verify Oqtane version before using version-dependent APIs
2. Verify migration state before altering schema
3. Detect baseline versus production database
4. Suggest alternative architecture when runtime supports better patterns
5. Follow 027x migration, packaging, and scheduled job governance
6. Refuse to assume environment state without validation

---

# 6. Prohibited Behavior

AI must not:

- Assume Oqtane version
- Modify EntityBuilders after initial deployment
- Replace baseline migration in a non-fresh environment
- Generate version-specific features without verifying runtime
- Ignore \_\_EFMigrationsHistory state

---

# 7. Architectural Intent

Runtime Awareness transforms the Oqtane AI Playbook from:

Static rule enforcement

into

Environment-aware architectural governance.

This ensures:

- Deterministic installations
- Safe schema evolution
- Correct feature selection
- Framework compatibility
- Long-term maintainability

---

# 8. Governance Level

Classification: Mandatory
Applies to: All OAP and MPE implementations
Overrides: Static assumptions

This rule integrates with:

- 027x-migrations.md
- 027x-scheduled-jobs.md
- 027x-packaging-and-dependencies.md
- 027-rules-index.md

---
