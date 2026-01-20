# Canonical Framework Rule (Enforced)

The Oqtane Framework is the canonical source of truth
for all module patterns and behaviors.

## Canonical Scope

Authoritative implementations include:
- Oqtane.Client
- Oqtane.Server
- Oqtane.Shared
- Template modules included with Oqtane
- Template themes included with Oqtane
- Internal framework modules (e.g. HTMLText, Jobs)

These define:
- Repository patterns
- Save/update logic
- Permission enforcement
- UI validation
- Error handling
- Scheduled jobs
- Migration patterns

## Enforcement Rules

- AI must prefer Oqtane framework patterns over external examples
- AI must not invent patterns not present in the framework
- If behavior is unclear, inspect internal modules first
- External modules must conform to framework patterns

## Prohibited Behavior

- Inventing alternative architectures
- Replacing framework patterns with abstractions
- Introducing non-Oqtane background execution models
- Reinterpreting framework conventions

If a proposed implementation deviates from framework behavior,
**reject the change**.
