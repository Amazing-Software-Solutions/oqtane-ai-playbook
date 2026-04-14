# 027x-ui-mudblazor

Governed MudBlazor Integration for Oqtane Modules

## Purpose

This rule defines the authoritative governance contract for integrating MudBlazor into an Oqtane module.

This rule overrides generic Blazor advice.

MudBlazor integration must follow this document exactly.

---

# 1. Installation Scope Rule

MudBlazor must be installed in:

Module.Client project only

It must NOT be installed in:

- Oqtane host project
- Oqtane core framework
- Server project

The module owns its UI framework dependency.

---

# 2. Package Installation

Add the NuGet package to Module.Client:

MudBlazor

The version must be explicitly defined.

No floating versions.

---

# 3. Service Registration Rule

MudBlazor services must be registered in:

Module.Client Startup class or ClientStartup.cs

Example:

```csharp
using MudBlazor.Services;

services.AddMudServices();
```

Do NOT:

- Register services in Oqtane host Program.cs
- Register services in Server project
- Register dynamically at runtime

Service registration belongs to the module.

---

# 4. Required Provider Rule

The following providers must exist in the module layout:

```razor
<MudThemeProvider />
<MudPopoverProvider />
<MudDialogProvider />
<MudSnackbarProvider />
```

They must be rendered once per module render surface.

If missing, the module is considered misconfigured.

---

# 5. Static Web Assets Rule

MudBlazor static web assets must follow:

027x-packaging-and-dependencies.md

Assets must resolve through:

\_content/MudBlazor/

No direct file copying into host.

No manual CSS duplication.

Packaging rule governs physical deployment.

---

# 6. Host Isolation Rule

MudBlazor integration must NOT modify:

- Oqtane host Program.cs
- Global index.html
- Core Oqtane layout
- Global Bootstrap configuration

Modules must remain portable.

Host pollution is forbidden.

---

# 7. UI Consistency Rule

Do not mix MudBlazor components with:

- Bootstrap UI components
- Radzen components
- Other UI frameworks

Within the same render surface unless explicitly governed.

UI fragmentation is not allowed.

---

# 8. Runtime Awareness

If runtime detection indicates conflicting UI frameworks are already registered, the AI must:

- Notify
- Require explicit override
- Not auto-mix frameworks

UI framework conflicts must be deliberate, never accidental.

---

# 9. Packaging Compliance

MudBlazor dependency must be reflected in:

- project.assets.json
- nuspec packaging if required
- static web asset inclusion

Packaging must comply with 027x-packaging-and-dependencies.md.

---

# 10. AI Enforcement Behavior

When user requests:

“Add MudBlazor”

AI must:

1. Add package to Module.Client
2. Register services in ClientStartup
3. Add required providers
4. Validate packaging compliance
5. Refuse host modification

No alternative interpretations.

---