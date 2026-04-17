# AI Instruction: Multi-Module Solution

**Instruction Context**: When the user requests to structuring multiple Oqtane modules within a single solution, enabling scalability, separation of concerns, and maintainable growth., you must load and execute this file.

---

## Mandatory Context

Before responding, you MUST:

1. Read `.github/copilot-instructions.md`
2. Read `docs/governance/027-rules-index.md`
3. Read `docs/governance/027x-multi-module-solution-pattern.md`

If any of the above are missing, **STOP and refuse**.

---

## Multi-Module Structure Rules (Non-Negotiable)

You MUST:
- Place each module in its own subfolder under `Client/Modules`.
- Extend the main module's namespace for any new inner module (e.g., if the main module is `AcmeCorp.Module.Inventory`, a new `Reporting` module MUST use `AcmeCorp.Module.Inventory.Reporting`).
- Ensure each module contains a `<ModuleName>ModuleInfo.cs` class with unique identifiers (`Name`, `Description`, etc.).
- Provide a clear UI entry point (e.g., `Index.razor`) for every module.
- Ensure module folder names and `ModuleInfo` identities are strictly unique and do not conflict.
- Create new modules when features represent a distinct UI/functional concern that logically exists independently.

You MUST NOT:
- Combine unrelated features into a single monolithic expansion of an existing module.
- Share a single `ModuleInfo` class across multiple functional areas.
- Create a module directory without independent registration or UI entry point.
- Reuse the overarching solution name for a specific inner module.
- Discard the main module's namespace root when defining an inner module's namespace.

---

## Expected Output
- A distinct `Client/Modules/<ModuleName>/` folder.
- A unique `ModuleInfo` class for independent Oqtane discovery and registration.
- A dedicated UI entry point (`Index.razor`) for the module.
