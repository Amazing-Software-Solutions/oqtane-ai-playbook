# 027x - Data Integrity Boundaries (Non-Negotiable)

All persisted data must remain **canonical and context-independent**.

AI-generated or modified code must not introduce context-dependent values into persistence under any circumstances.

---

## The Core Rule

> **Persist canonical data only.
> Never persist values influenced by context.**

If a stored value can vary based on user, locale, or request context, the implementation is invalid.

---

## Enforcement Scope

This rule applies to:

-   Entity creation and updates
-   Service layer persistence
-   API endpoints
-   Background jobs and scheduled tasks
-   Any code path that writes data

---

## AI Must

-   Persist only invariant, canonical values
-   Ensure stored data has identical meaning across all users
-   Separate transformation logic from persistence logic
-   Treat all user, locale, and request context as non-authoritative for storage

---

## AI Must Not

-   Persist localized or formatted values
-   Apply timezone or culture transformations before storage
-   Use user preferences to influence stored data
-   Use request or environment context when writing data
-   Collapse presentation logic into persistence logic

---

## Reject on Sight

The following patterns are automatic violations and must be rejected:

-   `.ToLocalTime()` used before persistence
-   `.ToString()` with formatting used for stored values
-   Culture or localization APIs in persistence logic
-   Accessing user or site settings during data writes
-   Persisting values that differ depending on the executing user

---

## Examples

### Invalid - Context Leakage (Time)

```csharp
entity.CreatedOn = utcDate.ToLocalTime();
```

---

### Invalid - Context Leakage (Culture)

```csharp
entity.Price = price.ToString("C");
```
---

### Invalid - Context Leakage (User Preference)

```csharp
entity.Distance\=ConvertToMiles(distanceKm, userPreference);
```

---

### Valid - Canonical Persistence

```csharp
entity.CreatedOn = utcDate;
entity.Price = price;
entity.DistanceKm = distanceKm;
```

---

## Validation Heuristic

Before persisting any value, the following must be true:

-   The value is identical regardless of user
-   The value is independent of locale or formatting
-   The value does not depend on request context

If any of these fail, the implementation must be rejected.

---

## Relationship to Playbook

-   Enforces **027.1 Data Integrity Boundaries**
-   Operates within **017 Client / Server Responsibility Boundaries**

This rule defines **what AI is allowed to write**, not where logic executes.

---

## Summary

-   Store invariant data only
-   Never persist context-dependent values
-   Reject violations immediately

Data integrity is non-negotiable.