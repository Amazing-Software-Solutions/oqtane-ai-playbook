# 027x – Structure and Boundary Rules

## Scope

Applies to all module structure, layering, and boundaries.

---

## Enforced Rules

- Client and Server projects are strictly separated
- No cross-boundary dependencies
- No shared runtime logic between Client and Server
- No `@page` routing inside modules

---

## Rejection Criteria

Reject if code:

- Blurs client/server boundaries
- Introduces routing into modules
- Assumes control over application structure
