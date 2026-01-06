# Canonical Verification Checklist

## Purpose

This document defines a **mechanical verification checklist** for determining whether:

- A module
- A template
- A scaffold
- An AI-generated output
- A documentation example

**conforms to the canonical reference implementation**.

This checklist removes opinion from the evaluation process.

---

## How This Checklist Is Used

This checklist is used when:

- Reviewing pull requests
- Evaluating AI-generated code
- Validating new templates or stubs
- Auditing existing modules
- Refactoring legacy code
- Answering the question: *“Is this acceptable?”*

Failure at any required item means **non-compliance**.

---

## Verification Levels

Each item is marked as:

- **REQUIRED** — must pass
- **CONDITIONAL** — must pass if applicable
- **INFORMATIONAL** — used for awareness only

---

## 1. Structural Compliance (REQUIRED)

- [ ] Module follows canonical folder and project structure
- [ ] Client, Server, Shared boundaries are preserved
- [ ] No cross-layer leakage (Client → Server internals, etc.)
- [ ] Shared project contains only DTOs, models, interfaces, and constants
- [ ] No business logic exists in Shared

---

## 2. Service Architecture (REQUIRED)

- [ ] Services have a shared interface when used by Client and Server
- [ ] Client-only or Server-only services exist only in their respective projects
- [ ] Service interfaces define behavior, not implementation details
- [ ] Dependency injection follows canonical patterns
- [ ] No direct repository access from Client code

---

## 3. Authorization & Permissions (REQUIRED)

- [ ] Authorization is permission-based
- [ ] No role-name checks exist in runtime logic
- [ ] `User.IsInRole` is not used for enforcement
- [ ] Oqtane permission APIs or attributes are used
- [ ] Permission checks occur at the correct boundary (Server enforcement)

---

## 4. UI Validation (REQUIRED)

- [ ] Client-side form validation is present
- [ ] `FormValid` interop is used correctly
- [ ] Required fields are enforced before submission
- [ ] Validation feedback is visible to the user
- [ ] UI validation does not replace server-side validation

---

## 5. Error Handling (REQUIRED)

- [ ] Exceptions are caught at appropriate boundaries
- [ ] User-facing errors are handled gracefully
- [ ] Internal exceptions are not leaked to the UI
- [ ] Failures result in predictable outcomes
- [ ] No empty or swallowed catch blocks

---

## 6. Logging – Server (REQUIRED)

- [ ] Uses Oqtane `ILogManager`
- [ ] Correct `LogLevel` is selected
- [ ] Correct `LogFunction` is used
- [ ] Security-related events are logged as `Security`
- [ ] CRUD operations are logged appropriately
- [ ] Sensitive data is not logged

---

## 7. Logging – Client (REQUIRED)

- [ ] Client logging uses the base class logger
- [ ] Exceptions are logged with context
- [ ] Logging is asynchronous where applicable
- [ ] Client logs do not replace server logs
- [ ] Logging does not interfere with UI flow

---

## 8. Scheduled Jobs (CONDITIONAL)

- [ ] Inherits from `HostedServiceBase`
- [ ] Uses tenant-aware execution
- [ ] Does not access UI or client services
- [ ] Uses dependency injection correctly
- [ ] Logs actions using `ILogManager`
- [ ] Does not invent scheduling mechanisms

---

## 9. Database Migrations (CONDITIONAL)

- [ ] Migration naming follows canonical versioning
- [ ] Inherits from `MultiDatabaseMigration`
- [ ] Uses EntityBuilders for schema creation
- [ ] `Up()` and `Down()` are fully implemented
- [ ] DbContext is updated when required
- [ ] Module version is updated correctly

---

## 10. Multi-Tenancy (REQUIRED)

- [ ] Tenant context is respected
- [ ] SiteId is validated where required
- [ ] Cross-tenant access is impossible
- [ ] No hardcoded tenant assumptions exist

---

## 11. AI Compliance (REQUIRED)

- [ ] Output aligns with canonical reference
- [ ] No invented patterns or abstractions
- [ ] No simplification that weakens enforcement
- [ ] No omission of required code paths
- [ ] Violations result in rejection, not correction

---

## 12. Deviation Handling (REQUIRED)

- [ ] Any deviation is intentional
- [ ] Deviation is documented
- [ ] Trade-offs are understood
- [ ] Deviation does not break core guarantees

---

## Final Gate

Before acceptance, answer:

> **Would this still be correct if copied verbatim into another module?**

If the answer is **NO**, it does not belong in the canonical ecosystem.

---

## Enforcement Statement

This checklist is **binding**.

Passing the checklist is mandatory.
Failure is not a matter of taste — it is non-compliance.

---
