 # 016 — Logging

Logging in Oqtane is part of the **platform contract**, not a diagnostic convenience.
It exists to record **security events**, **state changes**, and **operational failures** in a tenant-aware, auditable way.

This chapter defines the only supported logging model for Oqtane module development.

---

## Core Principle

> **Logging records intent. Enforcement controls behavior.**

Logs must never replace:
- Authorization
- Validation
- Exceptions
- HTTP responses

Logs are evidence, not execution.

---

## The Required Logger

All server-side Oqtane code MUST use:

```csharp
Oqtane.Infrastructure.ILogManager
```
This includes:

- Controllers
- Server services
- Background tasks
- Scheduled jobs

### Prohibited

- `ILogger<T>`
- Console logging
- Custom logging abstractions

Using a non-Oqtane logger breaks tenant context and auditability.

---

## Why `ILogManager` Exists

`ILogManager` provides:

- Tenant awareness
- Entity context
- Security categorization
- Structured event storage
- Integration with Oqtane’s log viewer

It is designed for **operations and auditing**, not debugging.

---

## Logging Semantics

Every log entry MUST declare **why it exists** using `LogFunction`.

Common values:

- `Security`
- `Create`
- `Read`
- `Update`
- `Delete`

This is not optional metadata.

It is how Oqtane understands system behavior.

---

## What Must Be Logged

Log the following events:

### Security Boundary Violations

```csharp
_logger.Log(
    LogLevel.Error,
    this,
    LogFunction.Security,
    "Unauthorized File Access Attempt {FileId}",
    id
);
```

Security violations are **always logged**.

---

### State Changes

```csharp
_logger.Log(
    LogLevel.Information,
    this,
    LogFunction.Create,
    "File Added {File}",
    file
);
```

State changes must be auditable.

---

### Operational Failures

```csharp
_logger.Log(
    LogLevel.Error,
    this,
    LogFunction.Create,
    ex,
    "File Upload Failed {Folder} {File}",
    folder,
    fileName
);
```

Failures must include:

- Exception (when available)
- Action context
- Domain identifiers

---

## What Must NOT Be Logged

Do NOT log:

- Validation failures
- Expected user mistakes
- UI feedback
- Control flow decisions
- Successful reads (unless audited)
- Framework lifecycle noise

Over-logging destroys signal.

---

## Logging and HTTP Boundaries

Logging must be paired with an explicit response.

Correct pattern:

```csharp
_logger.Log(...);
HttpContext.Response.StatusCode = (int)HttpStatusCode.Forbidden;
```

Incorrect pattern:

```csharp
_logger.Log(...);
// assume caller understands
```

Logs record. Responses enforce.

---

## Client vs Server Logging

Logging responsibilities differ by runtime boundary.

---

### Client Logging (Allowed, With Constraints)

Client-side logging is permitted **only** when using the logger provided by the Oqtane base component.

This logger:
- Is tenant-aware
- Routes logs to server infrastructure
- Is safe in interactive and WASM contexts

#### Valid Client Logging Use Cases

Client code MAY log:

- Unexpected exceptions
- Failed service calls
- Infrastructure or rendering failures

Example:

```csharp
catch (Exception ex)
{
    await logger.LogError(ex, "Error Loading Timeline {Error}", ex.Message);
}
```
This pattern is correct because:

- The failure is unexpected
- No enforcement decision is made
- No security conclusion is drawn
- The server still owns auditing and authorization

---

### Prohibited Client Logging

Client code MUST NOT log:

- Validation failures
- Authorization outcomes
- Business decisions
- Expected user mistakes
- Control flow or UI state

The client reports failures — it does not interpret them.

---

### Server Logging (Mandatory)

The server MUST log:

- Security violations
- Authorization failures
- State changes
- Background task failures

Server logging MUST use:

```csharp
Oqtane.Infrastructure.ILogManager
```

Client logging supplements diagnostics.

Server logging defines system truth.

---

## Scheduled Jobs and Background Tasks

Background execution MUST log:

- Start
- Failure
- Meaningful completion

They MUST NOT:

- Use UI messaging
- Suppress exceptions silently
- Depend on request context

---

## Explicit Prohibitions

The following patterns are invalid and must be rejected:

- Using `ILogger<T>` in Oqtane server code
- Logging validation failures
- Logging instead of enforcing
- Logging without `LogFunction`
- Logging UI concerns
- Logging without tenant context

---

## Why These Rules Matter

Incorrect logging leads to:

- Undetected security issues
- Broken audits
- Useless diagnostics
- AI-generated anti-patterns

Oqtane’s logging model exists to prevent this.

---

## Summary

Oqtane logging is:

- Intentional
- Structured
- Tenant-aware
- Security-first
- Enforcement-adjacent

If server code does not use `ILogManager`, it is wrong.

This chapter exists to make that unambiguous.