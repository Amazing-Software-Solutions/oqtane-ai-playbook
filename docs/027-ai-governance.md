Perfect — you’re very close already. What you need now is **a clean, final, authoritative 027-ai-governance.md*- that:

- Reads as *policy*, not discussion
- Has zero ambiguity for humans *or- Copilot
- Integrates the timeline, debugging rules, and startup governance cleanly
- Can be referenced verbatim from `copilot-instructions.md`

Below is a **finalized version**. This is a *drop-in replacement- for `027-ai-governance.md`.

---

# AI Governance

## Purpose

This document defines how AI tools are **allowed, constrained, and evaluated*- when used in Oqtane module development.

AI is treated strictly as a **code generation assistant**, not a designer, architect, or decision-maker.

This repository prioritizes **predictability, correctness, and framework integrity*- over novelty, convenience, or speed.

These rules apply to **all AI-assisted development**, regardless of tooling (Copilot, ChatGPT, etc.).

---

## Core Principle

> 
> **AI may generate code, but it may not define rules.**

All architectural decisions, patterns, and constraints are defined **outside AI systems*- and enforced **against their output**.

---

## Canonical Authority Hierarchy

When evaluating AI-generated output, authority is resolved in this order:

1. **Canonical reference implementation**
`/docs/reference/canonical-module`
2. **Numbered playbook documents*- in `/docs`
3. **Oqtane framework constraints**
4. **AI-generated output**

AI always ranks **last**.

---

## Allowed Uses of AI

AI **MAY*- be used to:

- Generate boilerplate that follows canonical patterns
- Fill in repetitive or mechanical code
- Expand patterns already defined in this repository
- Assist with refactoring **when behavior is preserved**
- Summarize or explain existing code

All AI output is **untrusted until verified**.

---

## Prohibited Uses of AI

AI **MUST NOT*- be used to:

- Invent new architectural patterns
- Introduce abstractions to “simplify” enforcement
- Replace explicit logic with inferred behavior
- Introduce role-based authorization
- Introduce routing via `@page` in modules
- Remove validation, logging, or error handling
- Substitute “best practices” without canonical reference

If AI output introduces anything not explicitly permitted, it is **rejected**.

---

## AI Rejection Rules

AI-generated output **must be rejected immediately*- if it:

- Violates canonical structure
- Uses non-canonical patterns
- Removes explicit enforcement
- Introduces ambiguity
- Assumes intent
- Trades rigor for convenience

Correction is optional.
**Rejection is mandatory.**

---

## Review Expectations

AI-generated code is reviewed as if written by:

- A junior developer
- With no domain context
- And no authority to make architectural decisions

The burden of proof is on the output, **not the reviewer**.

---

## AI Is Stateless

AI has:

- No memory
- No historical context
- No responsibility for outcomes

Therefore:

- All rules must be explicit
- All patterns must be visible
- All constraints must be enforceable in code

---

## Service Registration and Startup Governance

### Non-Negotiable Rule

**Oqtane modules do not own application startup.**

AI must never assume control over:

- Application bootstrapping
- Hosting configuration
- Global dependency injection
- The HTTP request pipeline

Any generic ASP.NET Core startup pattern is **invalid**.

---

### Allowed Startup Extension Points

AI may register services **only*- via Oqtane-defined interfaces:

| Scope | Interface | Purpose |
| --- | --- | --- |
| Client | `IClientStartup` | Client-side service registration |
| Server | `IServerStartup` | Server-side services and optional middleware |

No other startup mechanism is permitted.

---

### Client Service Rules

AI **must**:

- Register services only via `IClientStartup`
- Assume a Blazor client execution context
- Avoid server-only dependencies
- Prevent duplicate registrations
- Treat services as module-scoped

AI **must not**:

- Register server services
- Assume server infrastructure access
- Introduce application startup logic

---

### Server Service Rules

AI **must**:

- Register services only via `IServerStartup`
- Respect tenant isolation
- Treat DbContexts, repositories, and managers as server-only
- Register middleware only within module scope

AI **must not**:

- Assume ownership of the request pipeline
- Make global middleware ordering assumptions
- Register client services on the server

---

### Explicitly Forbidden Patterns

AI **must reject*- generation of:

- `Program.cs`
- `Startup.cs`
- `WebApplicationBuilder`
- `IHostBuilder`
- Global DI configuration
- Cross-boundary service registration

If any appear, the output is **architecturally invalid**, even if it compiles.

---

## Canonical Validation Source

The canonical module located at:

```
/docs/reference/canonical-module
```

is the authoritative validation source for:

- Startup patterns
- Service registration boundaries
- Client/server separation

It is used to **validate correctness**, not to invent variations.

---

## AI-Assisted Debugging and Root Cause Governance

AI may assist with debugging **only if outcomes are formalized**.

If AI-assisted debugging uncovers:

- A framework invariant
- A lifecycle requirement
- A constructor or registration rule
- A client/server boundary constraint

That knowledge **must not remain conversational**.

It must be documented, formalized, and enforceable.

---

### Mandatory Post-Fix Reporting

After resolving a non-trivial issue with AI assistance, developers **should request a structured report*- including:

- Symptoms
- False assumptions
- Root cause
- Violated invariant
- Correct canonical pattern
- Preventative checklist

This report becomes a **governance artifact**, not a chat transcript.

---

## Transport and Boundary Failure Diagnostics

### Non-Negotiable Diagnostic Rule

**Transport correctness is validated before application logic.**

If a client expects JSON but receives HTML (login pages, redirects, error documents), the failure is **not business logic**.

It is a **boundary or pipeline violation**.

---

### Canonical Failure Signal

> 
> **HTML where JSON is expected is never incidental.**

This indicates authorization failure, middleware interception, or pipeline misuse.

AI must stop deeper inspection immediately when this signal is detected.

---

### Required Diagnostic Order

AI must follow this sequence:

1. Validate response type
2. Validate HTTP status
3. Validate authorization and permissions
4. Validate middleware execution
5. Only then inspect application logic

Skipping steps invalidates the analysis.

---

## AI Decision Timeline (Optional but Recommended)

AI tools are stateless. Architectural learning is not.

The **AI Decision Timeline*- captures resolved, non-trivial AI-assisted decisions so they are not rediscovered repeatedly.

---

### When to Create a Timeline Entry

Create an entry when:

- AI produced plausible but invalid output
- A framework invariant was rediscovered
- A fix required multiple iterations
- The outcome should influence future AI behavior

Do **not*- create entries for trivial fixes.

---

### Ownership and Authority

Timeline entries are:

- Human-owned
- Human-approved
- Written after resolution

AI may summarize **only when explicitly instructed**.

---

### Structure and Location

Timeline entries live under:

```
/docs/ai-timeline/
```

Format:

```
YYYY-MM-DD-short-description.md
```

Each entry includes:

- Context
- What went wrong
- Why it was wrong
- How it was fixed
- What rule or prompt was updated

---

## Governance Rule Evolution

Governance rules are not static, but they are **not mutable by opinion**.

All new rules MUST originate from one of the following sources:

1. A canonical Oqtane framework constraint
2. An accepted Governance Rule Proposal (GRP)

Rules MUST NOT be added:
- Based on preference
- Based on AI suggestion
- Based on “best practice” reasoning

If a rule does not trace back to a GRP or framework invariant, it is invalid.

AI systems MUST defer rule creation and instead recommend a Governance Rule Proposal when new constraints appear necessary.

---

## Final Enforcement Statement

- AI governance is **not advisory**
- Convenience never outweighs correctness
- Framework signals override inferred intent
- Code that violates boundaries is invalid, even if it works

AI exists to **reduce effort**, not **reduce discipline**.

---
