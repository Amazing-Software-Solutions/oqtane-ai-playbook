# 027x - Structure and Boundary Rules

## Scope

Applies to all module structure, layering, and boundaries.

---

## Enforced Rules

- Client and Server projects are strictly separated
- No cross-boundary dependencies
- No shared runtime logic between Client and Server
- No `@page` routing inside modules

---

**Rule: Service-Mediated Server Access (Mandatory)**

In an Oqtane module, **all server-side data access MUST be mediated through module services**.

Specifically:

- The **Client Service*- (`[ModuleName]Service`) MUST call the module **Server Controller**
- The **Server Controller*- MUST delegate all domain operations to the **Server Service**
- The **Server Service*- (`[ModuleName]ServerService`) is the **only layer allowed to access repositories**
- **Controllers MUST NOT access repositories directly**

This enforces Oqtane's canonical flow:

```
Client UI
  → Client Service
    → Server Controller
      → Server Service
        → Repository
```

### Explicit Prohibitions

The AI MUST reject any implementation where:

- A controller injects or references a repository
- A controller contains data-access logic
- A controller bypasses the server service layer
- Client code references repositories directly
- Repository calls are made outside a server service

### Rationale

This rule exists to:

- Preserve separation of concerns
- Keep controllers thin and transport-focused
- Centralize domain behavior in server services
- Maintain parity with Oqtane framework modules
- Prevent AI from "shortcutting" architecture

If a required server service does not exist, the AI MUST propose creating one rather than bypassing the layer.


## Service Mediation Boundary (Mandatory)

All server-side operations MUST be mediated through module services.

Boundaries are strictly enforced as follows:

- Controllers are transport-only
- Controllers delegate to Server Services
- Server Services contain domain orchestration
- Repositories are accessed only by Server Services

Controllers MUST NOT:
- Access repositories
- Contain business or domain logic
- Orchestrate persistence operations

Reject any change that collapses or bypasses this boundary.

---

## Rejection Criteria

Reject if code:

- Blurs client/server boundaries
- Introduces routing into modules
- Assumes control over application structure


