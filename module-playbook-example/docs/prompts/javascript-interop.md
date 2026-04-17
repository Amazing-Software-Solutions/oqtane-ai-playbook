# AI Instruction: JavaScript Interop & Static Resources

**Instruction Context**: When the user requests to add custom JavaScript or CSS resources, you must load and execute this file.

## JavaScript Governance

Oqtane is a Blazor-first framework. You MUST exhaust all Blazor/C# capabilities before resorting to JavaScript. If JavaScript is absolutely unavoidable, you must follow these rules.

### 1. Resource Registration
Do NOT inject `<script>` or `<link>` tags directly into your `.razor` components.
All custom scripts and stylesheets must be registered via the `IModule` interface in your `ModuleInfo.cs` file using the `Resources` property.

```csharp
public List<Resource> Resources => new List<Resource>
{
    new Resource { ResourceType = ResourceType.Stylesheet, Url = "~/Module.css" },
    new Resource { ResourceType = ResourceType.Script, Url = "~/interop.js" }
};
```

### 2. Oqtane IInterop Interface
Do NOT inject and use `IJSRuntime` directly for basic DOM manipulation or interop if Oqtane provides a wrapper.
Oqtane provides an `IInterop` service (injectable via `[Inject] protected IInterop Interop { get; set; }`) which should be preferred for framework-level JS invocations (e.g., `Interop.IncludeLink`, `Interop.IncludeScript`, etc.).

### 3. Safe JS Invocation
If you must use `IJSRuntime` for custom module-specific logic:
- Ensure it is only invoked during or after `OnAfterRenderAsync(true)`.
- Never invoke JS in `OnInitialized` or `OnParametersSet` because the DOM does not exist yet (especially in Blazor Server mode).
- Handle `JSException` and `TaskCanceledException` gracefully, as clients may disconnect during the invocation.

### 4. Module Isolation
Wrap your custom JavaScript functions in an IIFE (Immediately Invoked Function Expression) or a module-specific namespace to prevent polluting the global `window` object and colliding with other Oqtane modules.
