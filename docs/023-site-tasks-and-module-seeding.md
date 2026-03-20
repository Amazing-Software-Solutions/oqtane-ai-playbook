# 023 - Site Tasks and Module Seeding

In Oqtane 10.1+, the framework introduced **Site Tasks** to solve a specific architectural problem: how to execute long-running or one-off "heavy" workloads without blocking the UI or application startup.

This chapter defines the role of Site Tasks in module development, specifically for **module seeding** and **asynchronous processing**.

---

## Mental Model: Site Tasks vs. Scheduled Jobs

It is critical to distinguish Site Tasks from Scheduled Jobs (covered in [# 13 - Scheduled Jobs](013-scheduled-jobs.md)).

| Feature | Scheduled Jobs (#013) | Site Tasks (#023) |
| :--- | :--- | :--- |
| **Cadence** | Recurring (e.g., every hour) | Ad-hoc / One-off |
| **Trigger** | Time-based (internal timer) | Event-based (explicitly queued) |
| **Purpose** | Maintenance, Housekeeping | Workflows, Seeding, User Requests |
| **Persistence** | Defined in code/DB | Queued as transient records |

---

## Primary Use Case: Module Seeding (First-Run Setup)

One of the most common failure modes for AI-generated modules is attempting to seed large datasets (sample content, default roles, configuration) during the synchronous Migration or Installation phase.

- **The Problem**: Writing thousands of rows during `IInstallable.Install` blocks the entire framework startup sequence for that tenant.
- **The Solution**: Use the **Site Task Seeding Pattern**.

### The Site Task Seeding Pattern
1. In `IInstallable.Install`, check if the module is being installed for the first time.
2. If seeding is required, create a `SiteTask` record.
3. The framework's internal `SiteTaskJob` will pick up the task and execute the seeding logic in the background.

```csharp
public bool Install(Tenant tenant, string version)
{
    if (version == "1.0.0") 
    {
        // Enqueue high-volume data seeding
        var task = new SiteTask(tenant.SiteId, "Seed MyModule Data", "MyModule.Tasks.SeedTask, MyModule.Server", "");
        _siteTaskRepository.AddSiteTask(task);
    }
    return true;
}
```

---

## Secondary Use Case: User-Triggered Async Work

Any operation initiated by a user that takes > 2 seconds must be offloaded to a Site Task.

- **Bulk Operations**: Importing users, global find-and-replace, bulk email.
- **Data Export**: Generating large CSV/Excel files.
- **Integrations**: Synchronizing with external APIs (which may be slow or throttled).

---

## Implementation Requirements

### 1. Interface Implementation
A task must implement `ISiteTask` (located in `Oqtane.Infrastructure`).

```csharp
public class MyTask : ISiteTask
{
    public string ExecuteTask(IServiceProvider provider, Site site, string parameters) => "";

    public async Task<string> ExecuteTaskAsync(IServiceProvider provider, Site site, string parameters)
    {
        // Resolve tenant-scoped services from the provider
        // Perform the work
        return "Process completed successfully.";
    }
}
```

### 2. Registration
Site Tasks are registered by adding a record to the `SiteTask` table via `ISiteTaskRepository` (Server) or `ISiteTaskService` (Client).

---

## Hard Rejection Rules (AI Governance)

1. **Reject custom polling**: No module should create a background timer or polling job to process its own "work queue". Use the Site Task framework.
2. **Reject blocking installs**: No module should perform "heavy" data seeding (blocking I/O) inside `IInstallable.Install`.
3. **Reject unmanaged tasks**: Never use `Task.Run()` for module-level background work. Oqtane cannot monitor, retry, or persist these operations.

---

## Why This Matters
Using Site Tasks ensures that:
- The **UI remains responsive**.
- The **Application startup is fast**.
- Long-running work is **observable** via the Site Tasks log in the Admin dashboard.
- Failed tasks can be **audited** and manually re-queued if necessary.
