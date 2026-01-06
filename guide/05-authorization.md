# 05 — Authorization: Roles, Permissions, and Enforcement

Authorization is one of the most misunderstood areas of Oqtane module development.

It is also one of the most dangerous places for AI-generated code to be *plausible but wrong*.

This chapter defines the **correct mental model**, **hard rules**, and **enforcement boundaries** for authorization in Oqtane modules.

---

## The Core Distinction (Non-Negotiable)

Oqtane’s authorization model is built on a strict separation:

- **Roles answer _who_ a user is**
- **Permissions answer _what_ a user is allowed to do**

These are not interchangeable.

Confusing them leads directly to fragile, insecure modules.

---

## Roles: Identity Grouping Only

Roles in Oqtane are:

- Soft-coded
- Data-driven
- Configurable by administrators
- Subject to change at runtime

A user may belong to:
- Zero roles
- One role
- Many roles

Roles:

- Have **no behavior**
- Enforce **nothing**
- Carry **no guarantees**

The only system roles with special meaning are:
- Host
- Admin
- Registered Users

All other roles are configuration, not contracts.

---

## Permissions: Enforceable Rules

Permissions are the **only enforceable authorization mechanism** in Oqtane.

Permissions:

- Represent allowed actions (View, Edit, Admin, etc.)
- Are evaluated at runtime
- May be granted to one or more roles
- Are additive (no deny logic)

A user’s effective access is the **union of permissions** granted by all assigned roles.

---

## The Correct Mental Model

Think of authorization this way:

- **Roles are labels**
- **Permissions are locks**

A role by itself does nothing.

Only when a role is mapped to permissions does it have meaning.

---

## Runtime Enforcement Boundary

Authorization enforcement belongs **exclusively** to the Server.

### Server Responsibilities

Server-side code must:
- Enforce permissions
- Assume all client input is untrusted
- Treat authorization as mandatory, not optional

Authorization may be enforced via:
- Oqtane permission APIs
- Permission attributes
- Explicit permission checks against module state

---

### Client Responsibilities

Client-side code:
- May reflect permissions for UI purposes
- Must never enforce authorization
- Must never grant access

Client logic is advisory only.

It can hide buttons — it cannot protect data.

---

## Forbidden Patterns (Reject Immediately)

The following patterns must **never** appear in module code:

- Checking role names directly
- Using `User.IsInRole(...)` for authorization
- Granting or denying access based on stored role names
- Assuming role stability
- Implementing custom deny logic

These patterns are fragile and violate Oqtane’s security model.

---

## Why Role-Based Checks Are Dangerous

Role-based checks fail because:

- Roles are configurable
- Administrators can rename or repurpose roles
- Roles can be reassigned without code changes
- Custom roles have no guaranteed meaning

Code that checks role names embeds assumptions that the system explicitly does not guarantee.

---

## Permission Assignment Is Configuration, Not Code

Mapping roles to permissions is:
- An administrative concern
- A configuration concern
- A runtime concern

It is **not** a coding concern.

Code defines:
- Which permissions exist
- Where they are enforced

Administrators decide:
- Which roles receive which permissions

---

## Additive Authorization Model

Oqtane permissions are additive.

This means:
- There is no explicit deny
- Permissions accumulate
- More roles can only grant more access

Code must not attempt to:
- Subtract permissions
- Implement negative rules
- Simulate deny behavior

---

## AI Failure Modes in Authorization

Without governance, AI frequently generates:

- Role-based authorization checks
- Mixed role and permission logic
- Client-side authorization enforcement
- Hard-coded role assumptions

These failures are subtle and often missed in review.

The playbook exists to prevent them.

---

## Rejection Rules (Non-Negotiable)

Reject any authorization-related change if:

- Role names are checked in code
- `User.IsInRole` is used
- Authorization is enforced in Client code
- Permissions are bypassed or optional
- Role names are persisted for enforcement
- Deny logic is implemented

Security correctness is more important than convenience.

---

## Why This Matters

Authorization mistakes:

- Rarely fail loudly
- Often pass tests
- Can survive for years
- Are difficult to audit retroactively

A permission-first model provides:
- Flexibility
- Safety
- Administrative control
- Predictable behavior

---

## What Comes Next

With services and authorization established, the next critical layer is **data evolution**.

Oqtane’s migration model differs significantly from standard EF Core usage, and AI tools frequently get it wrong.

The next chapter focuses on:

> **Database Migrations: startup execution, versioning, and multi-database safety**
