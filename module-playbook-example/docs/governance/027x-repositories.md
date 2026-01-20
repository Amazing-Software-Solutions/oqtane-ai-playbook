# Oqtane Repository Pattern Rules (Enforced)

These rules govern **all repository implementations** in Oqtane modules.

Repositories exist to:
- Encapsulate data access
- Enforce persistence boundaries
- Protect domain logic from infrastructure concerns

---

## Rule 1: Repository Scope

Repositories must:

- Handle data access only
- Contain no business logic
- Contain no validation logic

**Reject repositories that implement domain behavior.**

---

## Rule 2: Server-Only Enforcement

Repositories must:

- Reside in the Server project
- Never be referenced by client code

**Reject any client-side repository usage.**

---

## Rule 3: DbContext Usage

Repositories must:

- Use the module DbContext
- Respect Oqtane multi-tenant boundaries
- Avoid static or cached DbContext usage

**Reject DbContext misuse or caching.**

---

## Rule 4: No UI or Transport Awareness

Repositories must not:

- Know about HTTP
- Know about UI state
- Return view models

**Reject repositories that leak presentation concerns.**

---

## Rule 5: Explicit Interfaces

Repositories must:

- Implement explicit interfaces
- Be registered via `IServerStartup`

**Reject concrete repository usage without an interface.**

---

## Rule 6: Deterministic Queries

Repository methods must:

- Be explicit
- Be predictable
- Avoid hidden filtering or magic behavior

**Reject ambiguous or side-effect-driven queries.**

---

## Rule 7: Error Propagation

Repositories may:

- Throw exceptions
- Return null or empty results intentionally

Repositories must not:
- Swallow errors
- Log business-level decisions

**Reject silent repository failures.**

---

## Repository Validation Checklist

A repository is valid only if:

- It is server-only
- It contains no business or validation logic
- It uses DbContext correctly
- It exposes explicit interfaces
- It avoids UI or transport concerns

If any check fails, **reject the change**.

---

This rule set exists to keep persistence predictable and enforceable.
