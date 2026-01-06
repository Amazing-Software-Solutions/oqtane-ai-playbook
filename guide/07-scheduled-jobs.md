# 07 — Scheduled Jobs: Framework-Managed Background Work

Scheduled Jobs in Oqtane are frequently misunderstood.

They are often confused with generic background services, cron jobs, or hosted workers commonly found in ASP.NET Core applications. This misunderstanding is amplified when AI tools apply familiar patterns from other frameworks.

This chapter defines the **correct execution model**, **hard constraints**, and **safe patterns*- for implementing Scheduled Jobs in Oqtane modules.

---

## The Oqtane Scheduled Job Model (Mental Model)

In Oqtane:

- Scheduled Jobs are **framework-managed**
- Job discovery, scheduling, execution, and persistence are handled by Oqtane
- Jobs run **per tenant**
- Jobs are **repeatable*- and must be safe to re-execute

A Scheduled Job is not a background worker you control.

It is a unit of work the framework invokes under controlled conditions.

---

## What Scheduled Jobs Are Not

Scheduled Jobs are **not**:

- `BackgroundService`
- `IHostedService`
- Timers
- Cron jobs
- Long-running workers
- Message queue processors

Attempting to use these patterns inside Oqtane bypasses the framework and introduces serious risk.

---

## Required Base Class

All Scheduled Jobs must:

- Inherit from `HostedServiceBase`
- Reside in the **Server*- project

This base class integrates the job with:

- Tenant execution
- Dependency scoping
- Scheduling metadata
- Job history and logging

Using any other base class is invalid.

---

## Constructor Requirements

A Scheduled Job constructor must:

- Accept `IServiceScopeFactory`
- Pass it directly to the base constructor

Example (structural pattern only):

```csharp
public SampleJob(IServiceScopeFactory serviceScopeFactory)
    : base(serviceScopeFactory)
{
}
```
Dependency injection must not be bypassed or cached.

---

## Job Metadata Configuration

Scheduling is defined declaratively via properties on the job class, such as:

- `Name`
- `Frequency`
- `Interval`
- `StartDate`
- `EndDate`
- `RetentionHistory`
- `IsEnabled`

These values are read by Oqtane during startup.

Jobs must not implement custom scheduling logic.

---

## Execution Method

A Scheduled Job must implement one of:

- `ExecuteJob(IServiceProvider provider)`
- `ExecuteJobAsync(IServiceProvider provider)`

Execution rules:

- Resolve all dependencies from the provided `IServiceProvider`
- Perform short-lived, deterministic work
- Return a string describing the execution outcome

The returned string is persisted in the job history.

---

## Tenant Safety

Scheduled Jobs execute **once per tenant**.

Job logic must:

- Assume multi-tenant execution
- Never store static or in-memory state
- Never share data across tenants
- Rely on tenant-scoped services

Tenant handling is performed by the framework, not by the job.

---

## Idempotency Requirement

Jobs may be:

- Delayed
- Retried
- Re-executed
- Run after partial failure

For this reason, jobs must be **idempotent**.

They must not assume:

- A specific execution time
- A fixed schedule
- A previous successful run

Re-execution must be safe.

---

## Error Handling and Logging

Scheduled Jobs must:

- Handle exceptions locally
- Return error information via the result string
- Avoid throwing unhandled exceptions

Oqtane records:

- Execution status
- Execution time
- Returned output

Custom logging pipelines are unnecessary and discouraged.

---

## Forbidden Patterns (Reject Immediately)

The following patterns must never appear in Scheduled Jobs:

- `BackgroundService` or `IHostedService`
- Timers or infinite loops
- `Task.Run` for background execution
- Static state or caches
- Manual tenant resolution
- Custom scheduling logic
- Long-running blocking work

These patterns bypass Oqtane’s job lifecycle.

---

## Common AI Failure Modes

Without governance, AI frequently generates:

- Generic hosted services
- Async loops with delays
- Cron-style scheduling
- Jobs that run only once
- Single-tenant assumptions
- External schedulers

These implementations are incorrect in Oqtane.

---

## Rejection Rules (Non-Negotiable)

Reject any Scheduled Job implementation if:

- It does not inherit from `HostedServiceBase`
- It implements generic background services
- It manages its own scheduling
- It stores state between executions
- It is not tenant-safe
- It performs long-running work

Scheduled Jobs must conform to the framework’s execution model.

---

## Why This Matters

Incorrect Scheduled Jobs can:

- Block application startup
- Leak tenant data
- Run unpredictably
- Consume unbounded resources
- Become impossible to reason about

Correctly implemented jobs are:

- Predictable
- Observable
- Safe to upgrade
- Safe to retry

---

## What Comes Next

With Scheduled Jobs defined, the core architectural risk areas of Oqtane modules are covered.

The next chapter focuses on **applying these rules in practice**, especially when working with existing projects and real-world constraints.

> 
> 
> **Governing without rewriting: introducing the playbook into active solutions**