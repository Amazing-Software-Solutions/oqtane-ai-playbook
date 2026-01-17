# Canonical Validation Rule (Enforced)

## Purpose

This rule defines the **non-negotiable requirement** that all governance rules,
patterns, and constraints must be **verifiable against the Oqtane Framework**.

The Oqtane Framework is the **single source of architectural truth**.

---

## Rule: Canonical Validation Is Mandatory

All governance rules (`027x-*`) MUST:

- Be directly verifiable against implementations in the Oqtane Framework
- Describe patterns that already exist and are proven to work
- Never invent, extrapolate, or generalize beyond framework behavior

If a rule cannot be validated against the Oqtane Framework,
**it must not be enforced**.

---

## Canonical Authority

The canonical reference is the **Oqtane Framework source**, including:

- `Oqtane.Client`
- `Oqtane.Server`
- `Oqtane.Shared`
- Internal framework modules (e.g. HtmlText)
- Framework jobs, migrations, validation, and error handling

This authority covers:

- Structure and file placement
- Client/server boundaries
- Startup and service registration
- Data access and migrations
- Logging, validation, and error handling
- Scheduled jobs and background execution

In all conflicts:

1. Oqtane Framework wins  
2. Governance rules explain and constrain  
3. AI output loses  

---

## AI Enforcement Requirements

Before enforcing or refusing a change, AI MUST:

1. Inspect relevant Oqtane Framework implementations
2. Confirm the pattern exists in the framework
3. Apply the corresponding governance rule

If the canonical pattern cannot be located in the framework:
- AI must refuse to invent behavior
- AI must request clarification or propose a governance rule update

---

## Prohibited Behavior

AI MUST NOT:

- Enforce rules not demonstrably present in the Oqtane Framework
- Substitute generic ASP.NET Core best practices
- Claim architectural authority beyond framework implementations

---

## Enforcement Statement

This rule applies to **all governance rules**.

Violation of this rule invalidates:
- Refusals
- Enforcement decisions
- Architectural claims

No exceptions.
