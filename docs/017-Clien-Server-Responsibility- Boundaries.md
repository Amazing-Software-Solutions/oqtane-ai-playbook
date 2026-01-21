# 017 - Client / Server Responsibility Boundaries

Oqtane is a **distributed application framework**.
Every feature crosses a client/server boundary, whether explicitly or not.

Most bugs, security issues, and AI-generated anti-patterns in Oqtane modules come from violating this boundary.

This chapter defines **what belongs where** — and what never should.

---

## The Core Rule

> **The client requests.  
> The server decides.  
> The platform enforces.**

Anything that violates this sequence is wrong.

---

## Mental Model

Think in terms of **trust levels**:

| Layer | Trust Level | Responsibility |
|----|----|----|
| Client (UI) | Untrusted | Collect input, display state |
| Server | Trusted | Enforce rules, mutate state |
| Platform | Absolute | Authorization, auditing, tenancy |

The client is never a source of truth.

---

## Client Responsibilities (Allowed)

The client MAY:

- Collect user input
- Perform UI-only validation (required fields, formats)
- Call server services
- Display success, warning, and error messages
- Log unexpected failures using the Oqtane base logger
- Manage navigation and component state

### Example — Valid Client Validation

```csharp
if (!await interop.FormValid(form))
{
    AddModuleMessage("Please provide all required information", MessageType.Warning);
    return;
}
```
This improves UX.

It does not enforce anything.

---

## Client Responsibilities (Explicitly Prohibited)

The client MUST NOT:

- Enforce authorization
- Assume permissions
- Decide access rules
- Persist state directly
- Log security decisions
- Interpret authorization outcomes
- Trust query string values
- Replace server validation

If the client can bypass it, it is not enforcement.

---

## Server Responsibilities (Mandatory)

The server MUST:

- Enforce permissions
- Validate all inputs
- Own business rules
- Control persistence
- Log security events
- Define audit history
- Return authoritative outcomes

### Example — Server Enforcement

```csharp
if (!_userPermissions.IsAuthorized(User, siteId, EntityNames.Folder, folderId, PermissionNames.Edit))
{
    _logger.Log(LogLevel.Error, this, LogFunction.Security,
        "Unauthorized Folder Update Attempt {FolderId}", folderId);

    HttpContext.Response.StatusCode = (int)HttpStatusCode.Forbidden;
    return null;
}
```

The server:

- Decides
- Logs
- Enforces

---

## Validation Boundaries

| Type | Location | Purpose |
| --- | --- | --- |
| UI Validation | Client | User experience |
| Data Validation | Server | Data integrity |
| Security Validation | Server | Protection |

Client validation is optional.

Server validation is mandatory.

---

## Error Handling Boundaries

### Client Errors

The client handles:

- Displaying messages
- Recovering UI state
- Navigation

The client does NOT:

- Classify security issues
- Decide retry logic
- Swallow failures silently

---

### Server Errors

The server:

- Logs failures
- Returns appropriate HTTP status codes
- Protects internal details

The server never assumes the client will “do the right thing”.

---

## Logging Boundaries

| Location | Logging Role |
| --- | --- |
| Client | Report unexpected failures |
| Server | Record security, state, and failures |

Client logs are **diagnostic**.

Server logs are **authoritative**.

---

## Scheduled Jobs and Background Tasks

Scheduled jobs run:

- Without a user
- Without UI
- Without a request

Therefore they MUST:

- Enforce permissions explicitly (if applicable)
- Log all failures
- Never depend on UI state
- Never call client logic

They operate entirely on the server side of the boundary.

---

## The AI Failure Pattern

Most AI-generated Oqtane code fails because it:

- Moves logic into the client
- Uses role checks instead of permissions
- Logs in the wrong layer
- Treats validation as enforcement
- Assumes a single-user context

This chapter exists to prevent that.

---

## Boundary Violations (Reject on Sight)

The following patterns must be rejected immediately:

- Authorization checks in Razor components
- Business rules in client code
- `ILogger<T>` used in Oqtane server code
- Client-side permission assumptions
- Logging security decisions in the client
- Trusting UI-only validation

---

## Summary

- The client is untrusted
- The server is authoritative
- The platform enforces invariants

If a rule can be bypassed by the browser, it is not a rule.

This boundary is not optional.

It is the foundation of robust Oqtane modules.