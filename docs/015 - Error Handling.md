# 015 - Error Handling

Error handling in Oqtane modules must respect **execution boundaries**, **rendering boundaries**, and **responsibility boundaries**.

This chapter defines what constitutes an error, how it is handled, and where error-related APIs are allowed to execute.

These rules are **non-negotiable**.

---

## Core Principle

> **Errors must be handled at the boundary where they occur.**

Errors must never be:
- Silently swallowed
- Re-routed across layers
- Converted into UI concerns by default
- Used as control flow

---

## Error Categories

Oqtane module code deals with three distinct categories:

### 1. Validation Failures
- Expected
- User-correctable
- Not exceptional

### 2. Operational Failures
- Unexpected
- Recoverable
- Must be logged

### 3. System Failures
- Fatal or framework-level
- Not recoverable
- Must surface clearly

Each category has different handling rules.

---

## Validation Failures

Validation failures:

- MUST block save or execution
- MUST be handled deterministically
- MUST NOT throw exceptions
- MUST NOT be logged

Example (correct):

```csharp
if (!await interop.FormValid(form))
{
    AddModuleMessage("Please provide all required information.", MessageType.Warning);
    return;
}
```
The message is optional.

The early return is mandatory.

---

## Operational Failures

Operational failures include:

- Database errors
- Network errors
- Serialization failures
- Permission violations

These MUST:

- Be caught at the execution boundary
- Be logged
- Surface a user-visible message when appropriate

Example (correct):

```csharp
try
{
    await SaveAsync(model);
}
catch (Exception ex)
{
    logger.LogError(ex, "Error saving model {Id}", model.Id);
    AddModuleMessage(Localizer["Error.Save"], MessageType.Error);
}
```

---

## System Failures

System failures:

- MUST NOT be suppressed
- MUST NOT be converted into UI messages
- MUST propagate naturally

Examples:

- Missing framework services
- Invalid host configuration
- Broken module wiring

Let these fail fast.

---

## The `AddModuleMessage` Boundary (CRITICAL)

`AddModuleMessage` is **NOT a general-purpose UI helper**.

It requires a valid `RenderModeBoundary` and is only available when the component is hosted inside an Oqtane module.

### Enforcement Rules

`AddModuleMessage` MAY be used:

- In top-level module components
- In components that explicitly receive `RenderModeBoundary`

`AddModuleMessage` MUST NOT be used:

- In services
- In repositories
- In shared libraries
- In background tasks
- In scheduled jobs
- In controllers
- In child components without `RenderModeBoundary`
- As a replacement for logging
- As a substitute for exceptions

Violating these rules will cause runtime failures.

---

## RenderMode Boundary Rule

If a component calls `AddModuleMessage`, it MUST guarantee the boundary:

```html
<ChildComponent RenderModeBoundary="RenderModeBoundary" />
```

Any component that cannot guarantee this MUST NOT call `AddModuleMessage`.

---

## Client vs Server Responsibilities

### Client (UI)

The client MAY:

- Show validation warnings
- Show operation failure messages
- Trigger retries or navigation

The client MUST NOT:

- Suppress server errors
- Guess error causes
- Handle authorization failures silently

---

### Server

The server MUST:

- Throw exceptions for invalid state
- Enforce authorization
- Log failures
- Never depend on UI messaging

The server MUST NOT:

- Return success for failed operations
- Encode UI messaging logic
- Assume UI context exists

---

## Logging Boundary

Logging and messaging serve different purposes.

| Concern | Mechanism |
| --- | --- |
| Diagnostics | Logging |
| User feedback | Module messages |
| Control flow | Exceptions |
| Validation | Deterministic checks |

Never mix these responsibilities.

---

## Explicit Prohibitions

The following patterns are invalid:

- Catching exceptions without logging
- Using `AddModuleMessage` inside services
- Using messages to control execution
- Swallowing framework exceptions
- Logging validation failures
- Throwing exceptions for expected user input errors

Any generated code violating these rules must be rejected.

---

## Why These Rules Exist

Without strict error boundaries:

- UI components crash unexpectedly
- Background tasks fail silently
- Logs become meaningless
- AI-generated code becomes dangerous

These rules make behavior predictable and debuggable.

---

## Summary

Error handling in Oqtane modules is:

- Boundary-aware
- Explicit
- Logged appropriately
- UI-safe
- Framework-aligned

If error handling crosses boundaries, the code is wrong.

This chapter exists to prevent that.