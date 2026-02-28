# 027x-ui-architecture

UI Governance Architecture Rule

## Purpose

This rule governs ALL UI framework integrations inside the Oqtane AI Playbook.

It sits above:

- 027x-ui-mudblazor.md
- 027x-ui-fluentui.md
- 027x-ui-radzen.md
- Any future UI framework rule

This rule defines architectural principles, not framework specifics.

---

## 1. UI Framework Ownership Principle

A module owns its UI framework.

The host does not.

UI dependencies must remain module-scoped unless explicitly governed.

---

## 2. Single Framework Rule

Each module surface must use one UI framework.

Mixing frameworks within the same render surface is forbidden unless:

- Explicitly approved
- Documented
- Tested for style collision

AI must not combine UI ecosystems silently.

---

## 3. Isolation Over Convenience Rule

Convenience changes to host are prohibited.

Modules must:

- Register their own services
- Include their own providers
- Resolve static assets via \_content
- Avoid modifying host layout

If host modification is required, it must be explicitly requested.

---

## 4. Runtime Awareness Precedence

Before installing or configuring a UI framework, AI must:

1. Detect existing UI frameworks in module
2. Detect host-level global registrations
3. Detect conflicting static web assets

If conflict exists:

AI must stop and request clarification.

---

## 5. Static Web Assets Discipline

All UI frameworks must:

- Respect staticwebassets folder structure
- Follow \_content/{PackageName}
- Not manually copy assets into host wwwroot
- Follow 027x-packaging-and-dependencies.md

---

## 6. Service Registration Boundaries

Service registration belongs to:

Module.Client unless framework explicitly requires otherwise.

Host DI container must remain stable and predictable.

---

## 7. Deterministic Packaging Rule

UI dependencies must be:

- Explicitly versioned
- Reflected in project.assets.json
- Reflected in nuspec packaging
- Portable across environments

No implicit dependency behavior.

---

## 8. AI Behavioral Contract

When user requests a UI framework:

AI must:

1. Apply UI Architecture rule first
2. Then apply framework-specific rule
3. Confirm no conflicts
4. Execute installation steps deterministically

If rule conflict occurs:

AI must ask for override.

---
