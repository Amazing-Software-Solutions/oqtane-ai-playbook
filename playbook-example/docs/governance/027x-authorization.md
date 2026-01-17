# 027x – Authorization Rules

## Scope

Applies to permissions, access control, and security enforcement.

---

## Primary Rule

**Permission-based authorization is mandatory for all module features.**

Permissions must:
- Be defined in `ModuleDefinition`
- Be enforced via Oqtane permission checks
- Represent feature-level access

---

## System Role Exception (Strictly Bounded)

Role-based authorization is **forbidden**, **except*- for the following **Oqtane system roles**:

```csharp
namespace Oqtane.Shared {
    public class RoleNames {
        public const string Everyone = "All Users";
        public const string Host = "Host Users";
        public const string Admin = "Administrators";
        public const string Registered = "Registered Users";
        public const string Unauthenticated = "Unauthenticated Users";
    }
}
```
These roles:

- Are framework-defined
- Are stable, canonical, and globally understood
- May be referenced **only when required by Oqtane APIs or infrastructure**

They must **not*- be used to:

- Implement feature-level authorization
- Replace permissions
- Encode business logic

---

## Explicitly Forbidden

- Custom role names
- Application-defined roles
- Role-based feature gating
- Mixing roles and permissions for the same concern

---

## Correct Usage

- ✔ Infrastructure checks

- ✔ Framework-required conditions

- ✔ Bootstrapping or visibility rules defined by Oqtane itself

- ❌ Feature authorization

- ❌ Business logic decisions

- ❌ Access control inside repositories or services

---

## Rejection Criteria

Reject if code:

- Introduces custom role names
- Uses roles instead of permissions for features
- Encodes business logic using roles
- Uses system roles where permissions are appropriate

