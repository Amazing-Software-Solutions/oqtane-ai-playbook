# 027x - Multi-Module Solution Pattern

## Status
Proposed

## Intent

Define a standardized pattern for structuring **multiple Oqtane modules within a single solution**, enabling scalability, separation of concerns, and maintainable growth.

---

## Rule

An Oqtane module solution **may contain multiple modules**, each located within the `Client/Modules` directory.

Each module MUST:

- Reside in its own subfolder under `Client/Modules`
- Contain a `ModuleInfo` class with unique identifiers
- Be independently discoverable and registrable by Oqtane
- Provide its own UI entry point (e.g. `Index.razor`)

---

## Structure

```plaintext
Client/
 └── Modules/
     ├── Blog/
     │   ├── BlogModuleInfo.cs
     │   ├── Index.razor
     │   └── ...
     └── Archive/
         ├── ArchiveModuleInfo.cs
         ├── Index.razor
         └── ...
```

## Naming Conventions

-   Module folder names MUST be unique within `Client/Modules`
-   `ModuleInfo` class names MUST reflect the module identity
-   Module names MUST NOT conflict with other modules in the solution
-   Avoid reusing the solution name across multiple modules

---

## Registration Requirements

Each module MUST:

-   Define a unique `ModuleInfo` implementation
-   Provide a distinct `Name`, `Description`, and identifiers
-   Ensure Oqtane can discover and register the module independently

---

## When to Create a New Module

A new module SHOULD be created when:

-   The feature represents a distinct UI or functional concern
-   The feature can logically exist independently
-   The feature would otherwise increase complexity in an existing module
-   Separation improves maintainability or clarity

---

## Anti-Patterns

The following are NOT allowed:

-   Combining unrelated features into a single module
-   Sharing a single `ModuleInfo` across multiple functional areas
-   Treating modules as simple folders without independent registration
-   Creating modules without a UI entry point

---

## Design Principles

-   A solution is a **container of modules**, not a single module
-   Modules are **independently deployable units**
-   Composition is preferred over monolithic growth
-   Structure MUST support long-term scalability

---

## Future Considerations

This pattern may be extended to include:

-   Shared services across modules (via Shared project)
-   Cross-module communication patterns
-   Permission and role boundaries per module
-   Routing strategies for multi-module solutions

---

## Summary

This rule enables:

-   Scalable module architecture
-   Clear separation of concerns
-   Predictable structure for AI-assisted development
-   Alignment with Oqtane’s modular design philosophy

The goal is to ensure that as solutions grow, they do so through **composition of modules**, not uncontrolled expansion of a single module.