# 027x-ui-blazorbootstrap

Governed Blazor Bootstrap Integration for Oqtane Modules

## Purpose

This rule defines the authoritative governance contract for integrating Blazor Bootstrap into an Oqtane module.

This rule overrides generic Blazor advice.

Blazor Bootstrap integration must follow this document exactly. ([Blazor Bootstrap](https://github.com/vikramlearning/blazorbootstrap))

---

## 1. Installation Scope Rule

Blazor Bootstrap must be installed in:

👉 Module.Client project only

It must **not** be installed in:

- Oqtane host project
- Server project

The module owns its UI framework dependency.

---

## 2. Package Installation

Add the primary NuGet package in Module.Client:

Follow the 027x-packaging-and-dependencies.md to ensure that the package is properly installed and configured.

```xml
<PackageReference Include="Blazor.Bootstrap" Version="3.3.1" />
```

Wait, versions must be explicit, not floating.

---

## 3. Service Registration Rule

Blazor Bootstrap services must be registered in Module.Client Startup class or ClientStartup.cs.

Example:

```csharp
using BlazorBootstrap;

services.AddBlazorBootstrap();
```

**Do Not**:

- Register services in Oqtane host Program.cs
- Register services in Server project

---

## 4. Required Provider Rule

Blazor Bootstrap components require provider wrappers in layout.

Place these in your layout (e.g., in `MainLayout.razor`):

```razor
<Preload />
<Toasts class="p-3" messages="messages" auto-hide="true" delay="6000" placement="ToastsPlacement.TopRight" />
```

Providers must be rendered once per module render surface.

---

## 5. Static Web Assets Rule

Blazor Bootstrap includes script and CSS assets.

These must comply with:

➡ 027x-packaging-and-dependencies.md

Static assets must resolve through:

```
_content/Blazor.Bootstrap/
```

No direct copying into host wwwroot.

Do not assume CDN fallback.

---

## 6. Host Isolation Rule

Blazor Bootstrap configuration must **not modify**:

- Host Program.cs
- Host index.html
- Core Oqtane layout outside the module

Host pollution is forbidden unless explicitly governed.

---

## 7. UI Consistency Rule

Do not mix Blazor Bootstrap components with:

- Fluent UI Blazor
- MudBlazor
- Radzen
- Other UI frameworks
Within the same surface unless explicitly governed.

UI framework mixing creates unpredictable styling and behavior.

---

## 8. Runtime Awareness

If runtime or existing UI frameworks are detected:

AI must:

- Report conflicts
- Not merge frameworks silently
- Require explicit override

---

## 9. Packaging Compliance

Blazor Bootstrap dependency must be reflected in:

- Module.Client project.assets.json
- Nuspec packaging (if producing a module NuGet)
- Static web assets inclusion according to packaging rules

---

## 10. AI Enforcement Behavior

When the user requests:

> 
> “Add Blazor Bootstrap”

AI must:

1. Add package to Module.Client
2. Register Blazor Bootstrap services
3. Add required providers
4. Ensure static web assets are compliant
5. Respect host isolation

No assumptions. No generic Blazor defaults.
