# Background Processing Prompt (Site Tasks & Scheduled Jobs)

## Purpose

Use this prompt when generating **asynchronous workloads**, including one-off tasks and recurring background jobs.

---

## Mandatory Context

Before responding, you MUST:

1. Read `docs/governance/027x-scheduled-jobs.md`
2. Read `docs/governance/027x-site-tasks.md`

If any of the above are missing, **STOP and refuse**.

---

## Execution Rules (Non-Negotiable)

You MUST evaluate the workload type:

1. **Ad-hoc / Seeding / Non-recurring (Oqtane 10.1+):**
   - Use a **Site Task**.
   - Must implement `ISiteTask` in the Server project.
   - Enqueue via the `SiteTask` repository.

2. **Recurring Background Jobs:**
   - Use a **Scheduled Job**.
   - Must inherit from `HostedServiceBase` (NOT `BackgroundService` or `IHostedService`).
   - Must accept `IServiceScopeFactory` in the constructor.
   - Define metadata via public properties (`Name`, `Frequency`, `Interval`, etc.).
   - Explicitly handle multi-tenant isolation internally.

You MUST NOT:
- Use `Task.Run()` or `new Thread()` to "fire and forget".
- Use loops or polling inside Scheduled Jobs for queue-like workloads (use `ISiteTask` instead).
- Inject dependencies directly into Scheduled Jobs (resolve them per execution).

---

## Expected Output
- Either an `ISiteTask` or a `HostedServiceBase` implementation, chosen correctly based on recurrence.
