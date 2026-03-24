# 027x - DateTime Handling (Non-Negotiable)

All DateTime values must be persisted in **UTC**.

AI-generated or modified code must never introduce timezone, locale, or context-based transformations into persisted DateTime values.

---

## The Core Rule

> **Persist UTC only.
> Never persist local or context-derived time.**

Any DateTime value influenced by user, environment, or system timezone is invalid for persistence.

---

## Enforcement Scope

This rule applies to:

- Entity creation and updates
- Service layer operations
- API endpoints
- Background jobs and scheduled tasks
- Any code that writes DateTime values

---

## AI Must

- Use `DateTime.UtcNow` for all new timestamps
- Persist DateTime values in UTC only
- Preserve existing UTC values without transformation
- Treat all timezone and locale data as presentation-only

---

## AI Must Not

- Use `DateTime.Now` for persisted values
- Call `.ToLocalTime()` before persistence
- Apply timezone offsets prior to storage
- Use client or browser time for persistence
- Use user timezone preferences when writing data

---

## Reject on Sight

The following patterns are automatic violations:

- `DateTime.Now` used in persistence logic
- `.ToLocalTime()` applied before saving
- Any timezone conversion before storage
- Mixing UTC and local time in persisted fields
- Using environment or server timezone implicitly

---

## Examples

### Invalid - Local System Time

```csharp
entity.CreatedOn=DateTime.Now;
```

---

### Invalid - Context Conversion

```csharp
entity.CreatedOn=utcDate.ToLocalTime();
```

---

### Valid - Canonical UTC

```csharp
entity.CreatedOn=DateTime.UtcNow;
```

---

### Valid - Preserve UTC

```csharp
entity.CreatedOn=utcDate;
```

---

## Validation Heuristic

Before persisting any DateTime value:

- It must represent a single, absolute point in time
- It must be independent of user or environment
- It must not require reverse conversion to be understood

If any of these fail, the implementation must be rejected.

---

## Relationship to Playbook

- Enforces **027.2 DateTime Handling**
- Extends **027.1 Data Integrity Boundaries**
- Operates within **017 Client / Server Responsibility Boundaries**

This rule governs how AI handles time during persistence.

---

## Summary

- Always store DateTime in UTC
- Never persist local or context-derived time
- Reject violations immediately

Time must remain consistent across all users and environments.