# Canonical Module Overview

## Purpose of This Document

This document explains **what the canonical module contains**, **why each part exists**, and **how it should be interpreted**.

It does **not** teach Oqtane basics.
It does **not** justify design decisions.
It exists to make the canonical module **navigable, auditable, and enforceable**.

---

## What the Canonical Module Is

The canonical module is a **fully functional, minimal, production-aligned Oqtane module** that demonstrates:

- Correct architectural boundaries
- Correct service layering
- Correct authorization enforcement
- Correct validation and error handling
- Correct logging usage
- Correct use of Oqtane infrastructure

It is intentionally **boring**.

Boring is the goal.

---

## What the Canonical Module Is Not

The canonical module is **not**:

- A tutorial
- A playground
- A feature showcase
- A UI demo
- An optimization reference

Any code that exists purely to “show how something could be done” has been intentionally excluded.

---

## High-Level Structure

The canonical module mirrors a standard Oqtane module layout:

Canonical.Module/
├── Client/
├── Server/
├── Shared/
├── Resources/
└── Canonical.Module.csproj

Each folder has a **strict responsibility boundary**.

---

## Client Project

### Responsibility

The Client project is responsible for:

- UI rendering
- User interaction
- UI-level validation
- Displaying feedback and errors
- Calling server services

### Explicit Non-Responsibilities

The Client project must **never**:

- Enforce authorization rules
- Contain business logic
- Access repositories
- Make security decisions
- Assume permissions based on roles

### Patterns Demonstrated

- `<form>` usage with JS interop validation
- Defensive handling of `AddModuleMessage`
- Try/catch boundaries around service calls
- Client-side logging via base-class logger
- Navigation via `NavigationManager`

---

## Server Project

### Responsibility

The Server project is responsible for:

- Authorization enforcement
- Business logic
- Data validation
- Repository interaction
- Logging security-relevant events
- Raising sync events
- Returning deterministic outcomes

### Patterns Demonstrated

- Permission-based authorization (never role checks)
- Oqtane `ILogManager` usage
- Explicit HTTP status handling
- Defensive validation before persistence
- Sync event registration

---

## Shared Project

### Responsibility

The Shared project contains:

- DTOs
- Service interfaces
- Permission definitions
- Constants shared between client and server

### Contract Rules

- Interfaces are shared **only** when implemented by both client and server
- Server-only services must not leak into Shared
- Client-only abstractions must remain client-side

The Shared project defines the **contract**, not the behavior.

---

## Services and Repositories

### Services

Services follow a strict pattern:

- Interface defined in Shared
- Client implementation calls HTTP APIs
- Server implementation enforces authorization and business rules

No shortcuts.
No conditional behavior based on runtime context.

### Repositories

Repositories are:

- Server-only
- Injected
- Abstracted
- Never referenced by Client or Shared

---

## Authorization Model

The canonical module enforces the following rules:

- Authorization is permission-based
- Roles are configuration only
- Runtime checks use permissions exclusively
- No deny logic
- No role name checks
- No `User.IsInRole` calls

Authorization failures are logged.

---

## Validation Strategy

Validation exists at **two layers**:

### UI Validation
- Required field checks
- Form completeness
- User feedback

### Server Validation
- Model state validation
- Permission checks
- Data integrity checks

UI validation improves UX.
Server validation protects the system.

Both are mandatory.

---

## Logging Strategy

### Client Logging
- Used for operational visibility
- Uses the base class logger
- Logs failures, not control flow

### Server Logging
- Uses `ILogManager`
- Logs security events
- Logs state-changing operations
- Logs failures explicitly

Logging is not optional.
Logging is not decorative.

---

## Scheduled Jobs (If Present)

If scheduled jobs exist, they:

- Inherit from `HostedServiceBase`
- Use constructor-based configuration
- Execute per-tenant
- Resolve services via scoped providers
- Never depend on UI concepts

---

## Intentional Gaps

The canonical module intentionally omits:

- Advanced UI composition
- Custom theming
- Performance optimizations
- Feature toggles
- Experimental APIs

These are **outside scope**.

---

## How This Overview Should Be Used

This document exists to:

- Orient new contributors
- Anchor AI reasoning
- Prevent misinterpretation
- Support review discussions

If confusion arises, the **code** is the final authority.

---

## Closing Statement

The canonical module is not impressive.

It is **correct**.

Correctness is the foundation upon which everything else is built.

---
