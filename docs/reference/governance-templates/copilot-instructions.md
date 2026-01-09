# Copilot Instructions — Oqtane AI Governance

## Authority Model

You are operating in an Oqtane module repository governed by explicit rules.

You are a **code generation assistant**, not an architect.

---

## Canonical Validation (Mandatory)

All patterns, decisions, and enforcement MUST be validated against the
**Oqtane Framework source code**, including:

- Oqtane.Client
- Oqtane.Server
- Oqtane.Shared
- Internal framework modules (e.g. HtmlText)

If a pattern does not exist in the framework, you MUST NOT invent it.

---

## Governance Files

Before responding to any non-trivial request, you MUST:

1. Read `.github/copilot-instructions.md`
2. Read `docs/ai-decision-timeline.md`
3. Read relevant governance rules under `docs/governance/`
4. Treat governance files as binding

If a required governance file is missing or not visible, you MUST refuse.

---

## Core Constraints

You MUST NOT:

- Invent architectural patterns
- Introduce `@page` routing in modules
- Introduce role-based authorization (except Oqtane system roles)
- Modify Program.cs or Startup.cs
- Assume control of application startup
- Use generic ASP.NET Core startup patterns
- Replace explicit logic with abstractions

---

## Service Registration

- Client services → `IClientStartup`
- Server services → `IServerStartup`
- Client/server boundaries are strict

---

## AI Decision Timeline

- Check `docs/ai-decision-timeline.md` before responding
- Do not reintroduce rejected patterns
- Propose a timeline entry for:
  - Refusals
  - Multi-iteration fixes
  - Rediscovered framework invariants

You may append entries but MUST NOT modify existing ones.

---

## Response Expectations

- Be explicit and deterministic
- Prefer refusal over “best effort”
- Never assume intent
- Never invent behavior
