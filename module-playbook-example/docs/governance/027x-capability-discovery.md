# 027x - Capability Discovery (Non-Negotiable)

AI MUST exhaustively evaluate existing Oqtane and module capabilities before creating new functionality.

This rule exists to prevent duplication, architectural drift, and misalignment with the Oqtane framework.

---

## The Core Rule

> **Discover first.
> Reuse when possible.
> Create only when necessary.**

If functionality already exists, it MUST be used.

---

## Mandatory Discovery Order

If AI introduces new functionality without completing this discovery process, the output MUST be rejected.
Before introducing any new code, AI MUST evaluate:

### 1. Base Classes

-   `ModuleBase`
-   `ServerServiceBase`
-   Oqtane controller patterns

AI MUST check for:

-   Built-in behaviors
-   Existing lifecycle handling
-   Logging and messaging support
-   State integration

---

### 2. State and Shared Models

-   `ModuleState`
-   `PageState`
-   `SiteState`
-   Existing Models

State objects MUST be used as the source of truth for UI-related data.
AI MUST NOT introduce new state structures if equivalent data already exists.

---

### 3. Framework Services

AI MUST evaluate existing Oqtane services including:

-   Authorization and permissions
-   Logging
-   Navigation
-   Localization
-   File and storage handling

Existing services MUST be used instead of custom implementations.

---

### 4. Existing Module Patterns

AI MUST review:

-   Boilerplate module template
-   Built-in modules (for example HtmlText, Admin)
-   Established service and repository patterns

Patterns already used in the framework MUST be followed.

---

### 5. Current Project Implementation

AI MUST inspect:

-   Registered services
-   Existing repositories
-   Existing domain models and entities
-   Previously implemented features

Duplicate implementations MUST NOT be introduced.

---

## Prohibited Behavior

AI MUST NOT:

-   Recreate functionality provided by base classes
-   Introduce duplicate state containers
-   Bypassing state objects by calling services directly from the client when state is available
-   Replace Oqtane services with custom abstractions
-   Create parallel logging, authorization, or navigation systems
-   Duplicate DTOs or models that already exist
-   Introduce new patterns that bypass established framework behavior

---

## Required Justification for New Functionality

If AI determines that new functionality is required, it MUST:

-   Confirm that no existing capability satisfies the requirement
-   Identify what was evaluated
-   Explain why reuse is not possible
-   Align the new implementation with Oqtane patterns

Absence of explicit justification is considered a violation.

---

## Common Failure Patterns (Reject on Sight)

The following patterns indicate a violation:

-   Creating custom logging abstractions
-   Replacing `ModuleState`,`PageState`,`SiteState` with alternative state handling
-   Writing services that duplicate `ServerServiceBase`
-   Implementing custom authorization logic
-   Introducing duplicate DTOs in Shared
-   Ignoring existing service registrations

---

## Enforcement Outcome

If an existing capability satisfies the requirement:

-   AI MUST reuse it
-   AI MUST NOT extend it unnecessarily
-   AI MUST NOT wrap it without clear justification

---

## Relationship to Other Rules

-   Must be evaluated before runtime awareness to ensure correct environment evaluation
-   Supports canonical validation by enforcing framework alignment
-   Reinforces client and server responsibility boundaries
-   Protects data integrity by preventing parallel implementations

---

## Summary

-   Oqtane already provides most required functionality
-   Duplication is a governance failure, not an optimization
-   Discovery is mandatory, not optional

If AI creates before it discovers, the output MUST be rejected.