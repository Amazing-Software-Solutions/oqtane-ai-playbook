# 027x Site Tasks

## Purpose

This rule governs the use of Site Tasks introduced in Oqtane 10.1.

Site Tasks are the correct mechanism for ad hoc, user-initiated, or framework-triggered (e.g., install) asynchronous workloads that must not block the UI thread or application startup.

This rule prevents misuse of Scheduled Jobs for non-recurring work and enforces alignment with framework capabilities.

---

# 1. Version Gate (Runtime-Aware Governance)

Site Tasks are available only in **Oqtane 10.1 or greater**.

Before generating any implementation, AI must verify the framework version.

If Version < 10.1.0:
- Do not generate `ISiteTask` implementations.
- Fall back to Scheduled Job guidance (with idempotency warnings).
- Explicitly inform the user that Site Tasks require Oqtane 10.1+.

If Version >= 10.1.0:
- Site Tasks are **required** for all non-recurring async workloads.
- Scheduled Job polling patterns must be **rejected**.

---

# 2. Use Cases: When to Use Site Tasks

### Category A: User-Triggered Actions
- Export generation (e.g., "Export to CSV").
- Large file/data processing (e.g., "Import Users").
- Global data modifications (e.g., "Global Search and Replace").

### Category B: Module Seeding (First-Run Setup)
- Enqueuing "heavy" data seeding during `IInstallable.Install`.
- Registering default permissions or configuration that involves complex logic.

---

# 3. Architectural Decision Enforcement

If a user asks for background processing, AI must apply these decision points:

1. **Is it recurring?**
   - YES → Suggest **Scheduled Job** (#013).
   - NO → Suggest **Site Task** (#023).

2. **Is it "heavy" seeding?**
   - YES → Must be a Site Task enqueued from `IInstallable`. Never block migration.

AI must explicitly state:
"In Oqtane 10.1+, the correct architectural pattern for this one-off workload is `ISiteTask`. This ensures persistence and observability without blocking execution threads."

---

# 4. Implementation Constraints

### Requirement 1: ISiteTask Interface
Implementations must reside in the **Server** project and implement `ISiteTask`.

### Requirement 2: Service Resolution
All services must be resolved from the `IServiceProvider` passed to the `ExecuteTaskAsync` method.

### Requirement 3: Explicit Registration
Tasks must be explicitly enqueued by creating a record in the `SiteTask` repository.

---

# 5. Anti-Patterns (Immediate Rejection)

- **polling**: Creating a Scheduled Job to poll a "my_task_queue" table.
- **Blocking**: Performing heavy I/O or loop-based seeding inside `IInstallable.Install`.
- **Unmanaged**: Using `Task.Run()` or `new Thread()` to "fire and forget" logic.
- **Version Ignorance**: Implementing Site Tasks on Oqtane versions < 10.1.

---

# 6. Governance Summary

- **Recurring** → Scheduled Job.
- **Ad-hoc/Seeding** → Site Task.
- **Synchronous** → Migration (Schema only).

AI must align module architecture with the framework version lifecycle.
