# 027x-ui-framework-template.md

Canonical UI Framework Governance Template

This template must be copied and renamed for each new UI framework integration.

Example:

027x-ui-radzen.md
027x-ui-fluent.md
027x-ui-syncfusion.md

---

# 1. Installation Scope

Framework must be installed in:

Module.Client

Unless explicitly documented otherwise.

---

# 2. Package Declaration

- Explicit version required
- No floating versions
- No transitive assumptions
- Must be declared in Module.Client

---

# 3. Service Registration

Services must be registered in:

ClientStartup.cs

Not in host.
Not in server.

If framework requires host-level services, this must be explicitly justified.

---

# 4. Required Providers or Root Components

If framework requires:

- Theme providers
- Root wrappers
- Script initialization
- JS interop bootstrap

They must be declared in module layout.

---

# 5. Static Web Asset Handling

All static web assets must comply with:

027x-packaging-and-dependencies.md

Asset path convention must follow:

\_content//

Never copy directly into host wwwroot.

---

# 6. Host Modification Rule

Host modification is forbidden unless:

- Framework is designated as global host-level dependency
- Governance explicitly allows it

Otherwise modules remain self-contained.

---

# 7. UI Isolation Rule

Framework must not be mixed with other UI frameworks in the same render surface unless explicitly governed.

---

# 8. Runtime Awareness

AI must:

- Detect existing UI frameworks
- Avoid silent conflicts
- Require explicit override to mix frameworks

---

# 9. Packaging Verification

AI must validate:

- project.assets.json includes dependency
- static web assets resolve correctly
- nuspec includes required files

---

# 10. AI Response Pattern

When user says:

“Add ”

AI must:

1. Install package
2. Register services
3. Add providers
4. Validate packaging
5. Preserve host isolation

No assumptions.
No generic Blazor defaults.

---