# 10 — Services: Contracts, Boundaries, and Responsibility

Services are the backbone of most Oqtane modules.

They are also one of the easiest places for architectural drift to begin — especially when AI tools default to generic ASP.NET patterns.

This chapter defines **what services are in Oqtane**, **where they belong**, and **how responsibility is correctly divided** across Client, Server, and Shared projects.

---

## The Oqtane Service Model (Mental Model)

Oqtane modules are **distributed by design**.

Even though Client and Server code live in the same solution, they are separated by:
- Runtime boundaries
- Deployment boundaries
- Trust boundaries

Services must respect those boundaries.

The correct mental model is:

- **Shared** → contracts only
- **Client** → UI-facing logic and API calls
- **Server** → data access, persistence, and enforcement

Anything that blurs these lines introduces risk.

---

## Roles of Each Project

### Shared Project

The Shared project exists for **cross-boundary contracts only**.

It may contain:
- Interfaces
- DTOs
- Enums
- Constants used across boundaries

It must **never** contain:
- Service implementations
- Business logic
- Data access logic
- Dependency injection registration

Shared defines *what* can be done — never *how*.

---

### Client Project

The Client project is responsible for:
- UI logic
- Calling server APIs
- Client-side orchestration
- Mapping API responses to UI needs

Client services may:
- Implement Shared interfaces
- Be client-only helpers

Client services must not:
- Access the database
- Contain security enforcement logic
- Assume trust

---

### Server Project

The Server project is responsible for:
- Data access
- Business rules
- Authorization enforcement
- Persistence
- Integration with Oqtane infrastructure

Server services may:
- Implement Shared interfaces
- Depend on repositories and DbContexts

Server services must be treated as **authoritative**.

---

## Cross-Boundary Services

A service is considered *cross-boundary* when it is used by both Client and Server.

### Required Pattern

If a service is used by both sides:

1. Define **one interface** in the Shared project
2. Implement the interface in the Client project
3. Implement the interface in the Server project
4. Register each implementation in its respective DI container

This is non-negotiable.

---

### Common Violations (and Why They Matter)

| Violation | Why It’s Dangerous |
|---------|-------------------|
| Interface defined in Client | Server dependency inversion is broken |
| Interface duplicated | Client and Server drift |
| Implementation in Shared | Runtime boundary violation |
| Shared logic beyond contracts | Hidden coupling |

**Reject these patterns immediately.**

---

## Client-Only Services

Not all services need to cross boundaries.

If a service is **only used in the Client project**:

- Define the interface and implementation in Client
- Do not create a Shared interface

Creating Shared contracts “just in case” leads to unused abstractions and confusion.

---

## Server-Only Services

If a service is **only used in the Server project**:

- Define the interface and implementation in Server
- Do not expose it via Shared

Server-only services are common and healthy.

---

## Dependency Direction (Hard Rule)

Allowed dependencies:

- Client → Shared
- Server → Shared

Forbidden dependencies:

- Shared → Client
- Shared → Server
- Client → Server (direct references)

These rules protect:
- Deployment independence
- Testability
- Multi-tenant safety

## External Packages and Dependencies (Guardrail)

Before adding any external NuGet package, you MUST verify that:

- The functionality does not already exist in Oqtane or the .NET BCL
- Runtime deployment of the package assemblies is explicitly handled
- The module `.nuspec` is updated to include the dependency

Oqtane does NOT automatically resolve or deploy module dependencies at runtime.

If runtime deployment or packaging steps are unclear, you MUST STOP and explain
what would be required instead of adding the package.

Do NOT assume NuGet restore is sufficient.


**Reject any reverse dependency.**

---

## Authorization Responsibility

Services do not decide *who* a user is.

They enforce *what* the user is allowed to do.

Server services must:
- Enforce permissions
- Assume client input is untrusted

Client services must:
- Never enforce authorization
- Never assume access rights

Authorization rules are covered in detail in the next chapter.

---

## How AI Commonly Gets This Wrong

Without governance, AI frequently generates:

- Services that live entirely in Shared
- Direct Server references from Client
- Shared interfaces for single-project usage
- “Helper” services that mix responsibilities

These mistakes are subtle and compound over time.

The playbook exists to make them impossible.

---

## Rejection Rules (Non-Negotiable)

Reject any service change if:

- A Shared project contains implementations
- A Shared interface exists without both Client and Server implementations
- Authorization is enforced in Client
- Client references Server directly
- Dependency direction is violated
- Service scope is inferred instead of explicit

Rejection is preferable to correction.

---

## Why This Matters

Service boundaries determine:
- Security correctness
- Upgrade safety
- Maintainability
- Long-term module health

Most serious Oqtane issues trace back to services that crossed boundaries incorrectly.

---

## What Comes Next

With service boundaries established, the next critical concern is **authorization**.

Oqtane’s authorization model is frequently misunderstood, and AI tools are especially prone to getting it wrong.

The next chapter focuses on:

> **Roles, Permissions, and Enforceable Authorization in Oqtane**
