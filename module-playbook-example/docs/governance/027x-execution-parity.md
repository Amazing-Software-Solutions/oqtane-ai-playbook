# 027x – Execution Parity Across Hosting Models (Mandatory)

## Status
Mandatory Governance Rule

## Principle

Oqtane modules MUST produce identical functional results in:

- Blazor Server mode
- Blazor WebAssembly mode

The hosting model MUST NOT alter business logic, validation behavior, authorization enforcement, data transformation, or error handling.

Execution path differences are allowed.
Behavioral differences are NOT allowed.

---

## Architectural Context

In Oqtane:

### Server Mode
ClientService → ServerService → Repository

### WebAssembly Mode
ClientService → Controller → ServerService → Repository

The transport path differs.
The business logic MUST NOT.

The ServerService is the single source of truth for module behavior.

---

## Why This Rule Exists

If parity is not enforced, the following risks emerge:

- Subtle production-only bugs
- Hosting-model-specific behavior
- Inconsistent authorization enforcement
- Data inconsistencies
- DTO shape divergence
- Validation drift
- Difficult-to-reproduce tenant issues

Architectural determinism is a core principle of sustainable module design.

A module must behave the same regardless of hosting model.

---

## Mandatory Enforcement Criteria

AI and developers MUST ensure:

1. All business logic resides in ServerService.
2. Controllers contain NO business logic.
3. ClientService contains NO business logic.
4. Controllers only delegate to ServerService.
5. Validation logic resides in ServerService (not duplicated).
6. Authorization checks are enforced in ServerService.
7. DTO shaping and transformations occur in ServerService.
8. Exception behavior is consistent across both execution paths.

---

## Required Verification Step (AI Mandatory)

Before completing implementation involving services or controllers, AI MUST explicitly confirm:

> I confirm that business logic exists only in ServerService and that both execution paths (Server mode and WebAssembly mode) produce identical functional results.

If parity cannot be confirmed, the implementation MUST be refactored.

---

## Prohibited Patterns

❌ Business logic inside Controllers  
❌ Business logic inside ClientService  
❌ Hosting-model-specific conditional logic  
❌ Different validation logic between execution paths  
❌ DTO transformations performed in Controller only  
❌ Authorization checks missing from ServerService  
❌ Silent behavioral differences between Server and WebAssembly modes  

---

## Correct Pattern (Canonical)

ClientService  
→ (Server mode) ServerService  

ClientService  
→ (WebAssembly mode) Controller → ServerService  

ServerService  
→ Repository  

All behavior originates in ServerService.

---

## Governance Impact

This rule enforces:

- Deterministic architecture
- Hosting-model independence
- Production stability
- Reduced defect surface area
- Long-term maintainability
- AI alignment with Oqtane’s architectural intent

Execution parity is non-negotiable.

---

## Related Governance Rules

- 027x-structure-and-boundaries.md
- 027x-repositories.md
- 027x-authorization.md
- 027x-error-handling.md

