 # 01 — The Problem: Why AI Struggles With Oqtane Module Development

Oqtane is a **framework-driven platform** with strong architectural opinions, implicit conventions, and runtime behaviors that are not always obvious from surface-level code.

Modern AI coding tools (GitHub AI assistant, ChatGPT, etc.) excel at generating **plausible .NET code**, but they consistently struggle when those tools are applied directly to Oqtane module development without additional guidance.

This chapter explains **why** that happens.

---

## The Symptoms Developers Experience

Developers using AI tools with Oqtane often report the same issues:

- Generated modules that compile but fail at runtime
- Incorrect use of routing, authorization, or dependency injection
- Background services used where Scheduled Jobs are required
- Role-based authorization checks instead of permission-based checks
- Entity Framework migrations that ignore Oqtane’s startup migration model
- Multi-tenant behavior accidentally broken
- Code that “looks right” but violates core Oqtane assumptions

These failures are rarely obvious at first glance.

They surface later as:
- Subtle bugs
- Security issues
- Upgrade failures
- Data corruption
- Non-deterministic behavior across tenants

---

## Why This Is Not an “AI Problem”

The issue is **not** that AI tools are bad at C# or .NET.

They are actually very good at:
- Language syntax
- Common ASP.NET patterns
- Generic architectural advice
- Popular framework conventions

The issue is that **Oqtane is not a generic ASP.NET application**.

It is a platform with:
- A specific execution model
- A multi-tenant runtime
- Opinionated authorization rules
- A custom module lifecycle
- A startup-driven migration system
- Framework-owned background execution

Most of these rules are:
- Implicit
- Distributed across the codebase
- Learned through experience rather than documentation

AI cannot infer these reliably.

---

## The “Plausible but Wrong” Failure Mode

The most dangerous AI output is not code that fails to compile.

It is code that:
- Looks reasonable
- Matches common ASP.NET practices
- Passes superficial review
- Violates Oqtane’s internal contracts

Examples include:
- Using `@page` routing inside module components
- Implementing `BackgroundService` instead of `HostedServiceBase`
- Checking `User.IsInRole(...)` for authorization
- Running migrations manually instead of via startup
- Storing tenant-specific state statically

None of these are obviously “wrong” outside of Oqtane.

Inside Oqtane, they are architectural faults.

---

## Why Prompts and “Better Questions” Don’t Solve This

A common reaction is to try:
- More detailed prompts
- Longer explanations
- Step-by-step instructions to the AI
- Repeated corrections

This does not scale.

Why?

Because the problem is not missing information — it is **missing constraints**.

Without hard boundaries, AI will:
- Default to mainstream patterns
- Optimize for general correctness
- Fill gaps with assumptions

This leads to confident, consistent, and repeatable mistakes.

---

## Oqtane’s Reality: Rules Without Guardrails

Oqtane has many non-negotiable rules, for example:

- Roles describe *who* a user is; permissions describe *what* they can do
- Authorization must be permission-based
- Modules do not own routing
- Scheduled Jobs are framework-managed
- Migrations run at startup, not on demand
- Multi-database support is mandatory
- Tenant isolation is assumed everywhere

These rules are real, but they are not always enforced by the compiler.

AI tools have no way of discovering them unless they are explicitly encoded.

---

## The Cost of Ignoring This Problem

Left unaddressed, AI-assisted development can lead to:

- Fragile modules
- Inconsistent patterns across the ecosystem
- Increased maintenance burden
- Higher support costs
- Erosion of trust in third-party modules
- Developers blaming Oqtane for issues caused by misuse

None of this benefits the community.

---

## The Core Insight

AI tools do not fail because they lack intelligence.

They fail because **they are unconstrained**.

Frameworks like Oqtane require:
- Explicit rules
- Structural authority
- Clear rejection criteria
- A shared mental model

Without those, AI will always guess.

---

## What This Guide Is About

This guide is not about:
- Making AI smarter
- Teaching AI Oqtane internals
- Replacing documentation
- Enforcing personal preferences

It is about:
- Encoding real Oqtane constraints
- Making architectural rules explicit
- Turning AI into a predictable collaborator
- Improving robustness of module development
- Protecting both developers and the ecosystem

The next chapter introduces the key idea that makes this possible.

> **AI needs governance, not better prompts.**
