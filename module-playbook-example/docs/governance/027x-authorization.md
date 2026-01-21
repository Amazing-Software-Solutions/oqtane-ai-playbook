# 027x – Authorization Rules

## Scope

Applies to permissions, access control, and security enforcement.

---

### Primary Rule (Updated)

**Permission-based authorization is mandatory for all module features and business logic.**

Authorization must:

- Be enforced on the **server**
- Use Oqtane’s **permission and entity-based mechanisms**
- Represent **feature-level access**, not user classification

Permissions must:

- Be defined in `ModuleDefinition`
- Be checked using Oqtane’s permission APIs
- Be scoped to the relevant entity (module, page, resource)

---

### System Role Usage (Strictly Bounded)

Direct role checks are **forbidden**, **except** for the **canonical Oqtane system roles**, and **only** when required by Oqtane framework infrastructure or APIs.

```
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

System roles:

- Are framework-defined and stable
- Exist for **infrastructure, bootstrapping, and framework visibility**
- May be referenced **only when a permission-based alternative does not exist**

They **must not** be used to:

- Implement feature authorization
- Gate business logic
- Replace permission checks
- Encode access rules beyond framework intent

---

### Explicitly Forbidden (Unchanged, but clarified)

- Custom role names
- Application-defined roles
- Role-based feature gating
- Mixing role checks and permission checks for the same concern
- Assuming role checks are equivalent to permissions

---

### Correct Usage (Expanded)

**Allowed**

- ✔ Permission-based checks for all features
- ✔ Entity-scoped permission enforcement in controllers
- ✔ Framework-required role checks (e.g., Admin/Host for infrastructure paths)
- ✔ Visibility rules defined by Oqtane itself

**Forbidden**

- ❌ Feature access controlled by roles
- ❌ Business logic branching on roles
- ❌ Authorization inside repositories or data layers
- ❌ Client-side role enforcement without server validation

---

### Rejection Criteria (Updated)

Reject output if code:

- Uses roles where permissions are applicable
- Introduces custom or application-defined roles
- Mixes role and permission checks for the same feature
- Implements business logic based on roles
- Assumes authorization intent without explicit permission context

---

## 3. Decision Table — *“Is a Role Check Allowed Here?”*

| Context | Role Check Allowed? | Reason |
| --- | --- | --- |
| Framework bootstrapping | ✅ Yes | Required by Oqtane infrastructure |
| Admin/Host access to system UI | ✅ Yes | Canonical framework behavior |
| Feature access (View/Edit/etc.) | ❌ No | Must use permissions |
| Business logic branching | ❌ No | Roles are not business rules |
| API controller action | ❌ No | Requires entity permission check |
| Client-side UI visibility | ⚠️ Advisory only | Must mirror server permission |
| Repository / service layer | ❌ No | Authorization does not belong here |

---

## 4. AI Refusal Message Template (Authorization Ambiguity)

**Authorization context is unclear.**
I cannot determine whether this logic requires permission-based authorization or a framework-mandated system role check.

Oqtane governance forbids inventing or assuming authorization behavior.
 
Please specify:
 
- The entity being secured
- The intended permission (View/Edit/etc.)
- Whether this is a framework-level or feature-level concern
 