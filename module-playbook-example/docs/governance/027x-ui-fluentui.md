# 027x-ui-fluentui

Governed Fluent UI Blazor Integration for Oqtane Modules

## Purpose

This rule defines the authoritative governance contract for integrating Fluent UI Blazor into an Oqtane module.

This rule overrides generic Blazor advice.

Fluent UI integration must follow this document exactly. ([Fluent UI Blazor](https://fluentui-blazor.azurewebsites.net/?utm_source=chatgpt.com "Fluent UI Blazor Demo site"))

---

## 1. Installation Scope Rule

Fluent UI Blazor must be installed in:

👉 Module.Client project only

It must **not*- be installed in:

- Oqtane host project
- Server project

The module owns its UI framework dependency.

---

## 2. Package Installation

Add the primary NuGet package in Module.Client:

```xml
<PackageReference Include="Microsoft.FluentUI.AspNetCore.Components" Version="4.13.2" />
```

Optional additional packages **only if needed**:

```xml
<PackageReference Include="Microsoft.FluentUI.AspNetCore.Components.Icons" Version="4.x.x" />
<PackageReference Include="Microsoft.FluentUI.AspNetCore.Components.Emoji" Version="4.x.x" />
```

Versions must be explicit, not floating. ([NuGet](https://www.nuget.org/packages/Microsoft.FluentUI.AspNetCore.Components?utm_source=chatgpt.com "NuGet Gallery | Microsoft.FluentUI.AspNetCore.Components 4.13.2"))

---

## 3. Service Registration Rule

Fluent UI services must be registered in Module.Client Startup class or ClientStartup.cs.

Example:

```csharp
using Microsoft.FluentUI.AspNetCore.Components;

services.AddFluentUIComponents();
```

**Do Not**:

- Register services in Oqtane host Program.cs
- Register services in Server project

---

## 4. Required Provider Rule

Fluent UI Blazor components require provider wrappers in layout.

Place these in your layout (e.g., in `MainLayout.razor`):

```razor
<FluentToastProvider />
<FluentDialogProvider />
<FluentTooltipProvider />
<FluentMessageBarProvider />
<FluentMenuProvider />
```

If using v5 and above, a single consolidated provider may be available such as `<FluentProviders />`. ([Zenn](https://zenn.dev/tomokusaba/articles/29e7615e6ff4ae?utm_source=chatgpt.com "Fluent UI Blazor v5 RC1がリリース！v4からの進化と新機能を徹底解説"))

Providers must be rendered once per module render surface.

---

## 5. Static Web Assets Rule

Fluent UI includes script and CSS assets.

These must comply with:

➡ 027x-packaging-and-dependencies.md

Static assets must resolve through:

```
_content/Microsoft.FluentUI.AspNetCore.Components/
```

No direct copying into host wwwroot.

Do not assume CDN fallback.

---

## 6. Host Isolation Rule

Fluent UI configuration must **not modify**:

- Host Program.cs
- Host index.html
- Core Oqtane layout outside the module

Host pollution is forbidden unless explicitly governed.

---

## 7. UI Consistency Rule

Do not mix Fluent UI components with:

- Bootstrap UI
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

Fluent UI dependency must be reflected in:

- Module.Client project.assets.json
- Nuspec packaging (if producing a module NuGet)
- Static web assets inclusion according to packaging rules

---

## 10. AI Enforcement Behavior

When the user requests:

> 
> “Add Fluent UI Blazor”

AI must:

1. Add package to Module.Client
2. Register Fluent UI services
3. Add required providers
4. Ensure static web assets are compliant
5. Respect host isolation

No assumptions. No generic Blazor defaults.

---

### Known Issue: Fluent UI Blazor 4.14 + .NET SDK 10 Incompatibility

**Status:** BLOCKED (as of 2024)

**Versions Affected:**
- Fluent UI Blazor: 4.14.x
- .NET SDK: 10.0.x
- Oqtane: All versions with module extraction pattern

**Problem:**
Component JS files required at runtime cause BLAZOR106 build errors in SDK 10.
No suppression method works reliably.

**Recommendation:**
**Wait for Fluent UI Blazor 5.0** which is expected to address .NET 10 compatibility.

**Workaround (Not Recommended):**
Manual post-build file management with complex automation scripts.

**Alternative:**
Use MudBlazor 9.x which doesn't have this specific issue, or use Oqtane's built-in controls.
