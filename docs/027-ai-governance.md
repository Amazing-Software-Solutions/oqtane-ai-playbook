# AI Governance

## Purpose

- This document defines how AI tools are **allowed, constrained, and evaluated*- when used in Oqtane module development.
- AI is treated as a **code generation assistant**, not a designer, architect, or decision-maker.
- This repository prioritizes **predictability and correctness*- over novelty or speed.
- This document applies to all AI-assisted code generation, regardless of tool.

---

## Core Principle

> AI may generate code, but it may not define rules.

All architectural decisions, patterns, and constraints are defined **outside*- AI systems and enforced **against*- their output.

---

## Allowed Uses of AI

AI tools MAY be used to:

- Generate boilerplate that follows canonical patterns
- Fill in repetitive or mechanical code
- Expand existing patterns already defined in this repository
- Assist with refactoring **when behavior is preserved**
- Help explain or summarize existing code

AI output is always treated as **untrusted until verified**.

---

## Prohibited Uses of AI

AI tools MUST NOT be used to:

- Invent new architectural patterns
- Simplify or bypass enforcement logic
- Replace explicit code with abstractions
- Introduce role-based authorization
- Introduce routing via `@page` in modules
- Remove validation, logging, or error handling
- Make “best practice” substitutions without reference

If AI output introduces something not explicitly allowed by this repository, it is rejected.

---

## Canonical Authority Hierarchy

When AI produces output, authority is resolved in this order:

1. Canonical reference implementation
2. Repository rules and guides
3. Oqtane framework constraints
4. AI output

AI always ranks last.

---

## AI Rejection Rules

AI-generated output must be **rejected immediately*- if it:

- Violates canonical structure
- Uses non-canonical patterns
- Removes explicit enforcement
- Introduces ambiguity
- Assumes intent
- Adds convenience at the cost of rigor

Correction is optional.
Rejection is mandatory.

---

## Review Expectations

AI-generated code is reviewed as if written by:
- A junior developer
- With no domain context
- And no authority to decide architecture

The burden of proof is on the output, not the reviewer.

---

## AI Is Stateless

AI has:
- No memory
- No long-term context
- No responsibility for consequences

Therefore:
- All rules must be explicit
- All patterns must be visible
- All constraints must be enforceable in code

---

## Enforcement Statement

- AI governance is not advisory.
- Failure to comply invalidates the output regardless of correctness elsewhere.
- AI exists to **reduce effort**, not **reduce discipline**.

---

## Service Registration and Startup Governance

### Non-Negotiable Rule

**Oqtane modules do not own application startup.**

AI must never assume that an Oqtane module controls:
- Application bootstrapping
- The hosting model
- The global dependency injection container
- The HTTP request pipeline

Any attempt to introduce generic ASP.NET Core startup patterns is invalid.

---

### Allowed Startup Extension Points

AI **may only*- register services using Oqtane-defined interfaces:

| Scope   | Interface        | Purpose |
|--------|------------------|--------|
| Client | `IClientStartup` | Client-side service registration |
| Server | `IServerStartup` | Server-side services and optional middleware |

These interfaces are the **only valid mechanism*- for module startup participation.

---

### Client Service Rules

When generating client-side code, AI must:

- Register services exclusively via `IClientStartup`
- Assume services run in a Blazor client context
- Avoid server-only dependencies
- Prevent duplicate registrations where possible
- Treat services as module-scoped, not application-wide

AI **must not**:
- Register server services on the client
- Assume access to server infrastructure
- Introduce application startup logic

---

### Server Service Rules

When generating server-side code, AI must:

- Register services exclusively via `IServerStartup`
- Respect tenant isolation
- Treat DbContexts, repositories, and managers as server-only
- Register middleware only within the module’s scope

AI **must not**:
- Assume ownership of the request pipeline
- Introduce global middleware ordering assumptions
- Register client services on the server

---

### Explicitly Forbidden Patterns

AI must reject generation of:

- `Program.cs`
- `Startup.cs`
- `WebApplicationBuilder`
- `IHostBuilder`
- Global DI configuration
- Cross-boundary (client/server) service registration

If any of these appear, the output is **architecturally invalid**, even if it compiles.

---

### Canonical Validation Source

The canonical module under:

`/docs/reference/canonical-module`> 
> This reference must be used when evaluating AI output for structural correctness.

No new content, just clarifies *how- it’s used in practice.

is the authoritative source for:
- Valid startup patterns
- Service registration boundaries
- Client/server separation

AI must treat this as a **validation reference**, not a pattern to extend or reinterpret.

---

### Enforcement Statement

If AI-generated code violates these startup or service registration rules:

- The output must be rejected
- No “best effort” correction is acceptable
- Oqtane conventions take precedence over generic ASP.NET practices

### AI-Assisted Debugging and Root Cause Reports

AI may be used to assist with debugging **only if the final outcome is captured as an explicit rule or invariant**.

If an AI-assisted debugging session uncovers:

- A framework requirement
- A constructor or registration invariant
- A client/server boundary rule
- A shared model or lifecycle constraint

Then that knowledge **must not remain conversational**.

It must be:

- Documented
- Formalized
- Enforceable against future AI output

AI conversations are transient.

Architecture rules are not.

---

### Post-Fix Reporting Is Mandatory

After resolving a non-trivial issue with AI assistance, developers **should request a structured report*- that includes:

- Symptoms
- False assumptions
- Root cause
- Violated framework invariant
- Correct canonical pattern
- Preventative checklist

This report becomes:

- A governance artifact
- A future rejection rule
- A training signal for both humans and AI

---

### Example: ServiceBase Construction Invariant

If debugging reveals that a service **must**:

- Inherit from a specific base class
- Accept required framework state
- Call a specific base constructor

Then this becomes a **non-negotiable invariant**, not an implementation detail.

Future AI output that violates this invariant is rejected immediately.

---
## Transport and Boundary Failure Diagnostics

### Non-Negotiable Diagnostic Rule

When diagnosing client/server failures, **transport correctness must be validated before application logic**.

If a client expects:

- JSON
- DTOs
- Structured API responses

And instead receives:

- HTML
- Redirect pages
- Login views
- Framework error documents

Then the failure is **not** a business logic bug.

It is a **boundary or pipeline violation**.

---

### Canonical Failure Signal

> **HTML where JSON is expected is never incidental.**

This indicates one or more of the following:

- Authorization failure
- Missing or incorrect permissions
- Middleware interception
- Incorrect endpoint exposure
- Incorrect execution pipeline (public vs protected API)

AI must immediately stop deeper inspection when this signal is detected.

---

### Forbidden Debugging Behavior

When transport validation has not been confirmed, AI **must not**:

- Propose DTO changes
- Propose JSON serialization fixes
- Propose retry logic
- Propose async or timing changes
- Suggest client-side workarounds

Any such suggestion before transport validation is **invalid**.

---

### Required Debugging Order

AI **must** follow this diagnostic sequence:

1. Confirm response type (JSON vs HTML)
2. Confirm HTTP status codes
3. Confirm authorization and permission enforcement
4. Confirm middleware execution order
5. Only then inspect application logic

Skipping steps invalidates the analysis.

---

### Logging Expectations

Transport and boundary failures must be observable through:

- Server-side logging (authorization, security, middleware)
- Client-side logging (unexpected response shape)

AI must:

- Correlate client errors with server logs
- Treat silent failures as high-risk signals
- Assume missing logs indicate missing enforcement

---

### Final Enforcement Statement

- Transport failures are architectural failures.
- Debugging beyond the boundary without validating it is prohibited.
- AI must respect framework signals over inferred intent.
- Correct code built on an invalid boundary is still invalid.








---
# Example
## Copilot prompt snippet
Here’s a **drop-in Copilot prompt snippet*- you can put directly into

`.github/copilot-instructions.md`.

It is intentionally **authoritative, restrictive, and non-negotiable**, matching the tone of your playbook.

```md
## Oqtane Module AI Instructions (Mandatory)

You are assisting with **Oqtane module development**.

This repository defines **authoritative architectural rules**.

Your output is **validated against documentation**, not vice versa.

### Authority Order (Highest → Lowest)

1. `/docs/reference/canonical-module`
2. Numbered documents in `/docs` (e.g. `027-ai-governance.md`)
3. Oqtane framework constraints
4. Your generated output

If your output conflicts with any of the above, it is **invalid and must be rejected**.

----

### Non-Negotiable Rules

You **MUST**:

- Follow Oqtane module patterns exactly
- Respect strict client/server separation
- Use permission-based authorization only
- Follow canonical migration, logging, validation, and job patterns
- Treat the canonical module as a **diff reference**, not a template
- Generate explicit, reviewable code (no hidden abstractions)

You **MUST NOT**:

- Invent new architectural patterns
- Introduce generic ASP.NET Core or Blazor conventions
- Add `Program.cs`, `Startup.cs`, `WebApplicationBuilder`, or host configuration
- Use `@page` routing in modules
- Introduce role-based authorization
- Register services outside `IClientStartup` or `IServerStartup`
- Simplify or bypass enforcement logic
- Renumber, reorder, or reinterpret documentation

----

### Startup & Service Registration Rules

Oqtane modules **do not own application startup**.

When registering services:

- Client services → `IClientStartup`
- Server services → `IServerStartup`
- No cross-boundary registration
- No global middleware assumptions

If a required capability cannot be implemented within these constraints, **do not invent a workaround**. State the limitation instead.

----

### Validation Requirement

Before finalizing output, you must:

- Verify alignment with the canonical module
- Confirm no forbidden patterns were introduced
- Prefer rejection over correction if uncertain

If uncertain, ask for clarification **instead of guessing**.

----

### Output Expectations

Your role is to **generate code that survives review**, not code that merely compiles.

Correctness, predictability, and framework integrity are mandatory.
```