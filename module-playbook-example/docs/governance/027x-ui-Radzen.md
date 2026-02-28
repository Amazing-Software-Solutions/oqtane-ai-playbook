# 027x-ui-radzen

Governed Radzen Blazor Integration for Oqtane Modules

## Purpose

This rule defines the authoritative governance contract for integrating Radzen Blazor components into an Oqtane module.

This rule overrides generic Blazor guidance.

Radzen integration must follow this document exactly.

---

## 1. Installation Scope Rule

Radzen must be installed in:

Module.Client project only

It must NOT be installed in:

- Oqtane host project
- Module.Server
- Module.Shared

The module owns its UI framework dependency.

---

## 2. Package Installation

Add explicit package reference in Module.Client:

```xml
<PackageReference Include="Radzen.Blazor" Version="X.Y.Z" />
```

Rules:

- Version must be explicit
- No floating versions
- No implicit transitive dependency reliance
- Lock file must reflect resolved version in obj/project.assets.json

---

## 3. Service Registration Rule

Radzen services must be registered inside Module.Client startup.

Example:

```csharp
using Radzen;

services.AddScoped<DialogService>();
services.AddScoped<NotificationService>();
services.AddScoped<TooltipService>();
services.AddScoped<ContextMenuService>();
```

Do NOT:

- Register Radzen services in host Program.cs
- Modify Oqtane host DI container
- Register services in Server project

Module isolation is mandatory.

---

## 4. Required Providers Rule

Radzen components requiring infrastructure must include providers in module layout.

Example:

```razor
<RadzenDialog />
<RadzenNotification />
<RadzenTooltip />
<RadzenContextMenu />
```

Providers must:

- Be rendered once per module layout
- Not be injected into host layout
- Not pollute global UI surface

---

## 5. Static Web Assets Rule

Radzen static assets must resolve via:

```
_content/Radzen.Blazor/
```

Rules:

- Do not manually copy CSS or JS to host wwwroot
- Do not modify host index.html
- Follow 027x-packaging-and-dependencies.md
- Ensure assets are included in module packaging if producing NuGet

No CDN assumptions.

---

## 6. Host Isolation Rule

Radzen integration must NOT:

- Modify host layout
- Modify host theme
- Override global Bootstrap styles
- Inject global CSS resets

Modules must remain portable and self-contained.

---

## 7. UI Mixing Rule

Radzen must not be mixed with:

- MudBlazor
- Fluent UI
- Bootstrap component libraries
- Any second UI framework

Unless explicitly governed.

AI must not silently merge frameworks.

---

## 8. Runtime Awareness

If runtime detection reveals:

- Another UI framework already active in module
- Host-level Radzen installation
- Conflicting static assets

AI must:

- Report conflict
- Request explicit override
- Refuse silent integration

---

## 9. Packaging Compliance

Radzen dependency must:

- Appear in Module.Client project.assets.json
- Be reflected in nuspec packaging if applicable
- Respect staticwebassets path structure
- Not duplicate host-level resources

---

## 10. AI Enforcement Behavior

When the user requests:

“Add Radzen”

AI must:

1. Add package to Module.Client
2. Register required services in module
3. Add required providers
4. Validate static web assets path
5. Preserve host isolation

No generic Blazor assumptions.

---
