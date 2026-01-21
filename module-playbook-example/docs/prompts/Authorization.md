# Authorization Prompt (Oqtane Module)

## Purpose

Use this prompt when **creating or modifying authorization logic** in an Oqtane module

(controllers, APIs, services, or UI authorization checks).

This prompt enforces **canonical Oqtane authorization architecture** and prevents

invented, legacy, or unsafe security patterns.

---

## Mandatory Context

Before responding, you MUST:

1. Read `.github/copilot-instructions.md`
2. Read `docs/governance/027-rules-index.md`
3. Read `docs/governance/027x-authorization.md`
4. Check `docs/ai-decision-timeline.md` for prior authorization decisions

If any of the above are missing or not visible, **STOP and refuse**.

---

## Authorization Rules (Non-Negotiable)

You MUST:

- Enforce authorization **server-side**
- Prefer **permission-based authorization** for modules
- Use **entity-scoped permissions** where applicable
- Use dynamic policies in the format:

    ```
    EntityName:PermissionName:Roles
    ```
- Validate entity access using canonical helpers (e.g. `IsAuthorizedEntityId`)
- Respect Oqtane’s hybrid model:

    - Permission-based authorization is **preferred**
    - Role checks are **allowed only in explicitly permitted scenarios**
- Follow all constraints defined in `027x-authorization.md`

You MUST NOT:

- Invent authorization logic
- Assume permission context when it is unclear
- Use deprecated static policies unless explicitly allowed
- Bypass entity authorization checks
- Perform security decisions solely on the client

Client-side authorization is **advisory only**.

---

## Role Check Guardrail

Before using a role check, you MUST answer:

- Is this an internal framework scenario?
- Is this Host/Admin infrastructure logic?
- Is this a documented exception in `027x-authorization.md`?

If **any answer is unclear**, you MUST refuse.

---

## AI Refusal Rule

If authorization intent, scope, or entity context is ambiguous, respond with:

> 
> 
> **Authorization Refusal**
> 
> The authorization requirements are unclear or incomplete.
> 
> Oqtane enforces a hybrid authorization model with strict rules.
> 
> Please clarify:
> 
> - Entity being secured
> - Required permission(s)
> - Whether this is an allowed role-based exception
> 
> 
> 
> No authorization logic has been generated to avoid a security violation.
> 

---

## Expected Output

- Explicit authorization attributes or checks
- Clear justification for permission vs role usage
- Entity-scoped validation where applicable
- No deprecated or invented patterns

If correct authorization cannot be determined, **REFUSE and propose a rule update**.