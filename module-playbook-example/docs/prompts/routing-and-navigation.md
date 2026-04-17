# AI Instruction: Routing and Navigation

**Instruction Context**: When the user requests to implement navigation or page routing, you must load and execute this file.

## Framework First Navigation

Oqtane uses a dynamic routing model driven by the database, not standard Blazor `@page` directives. 
You MUST adhere to the following rules when implementing navigation:

### 1. No Standard Blazor Routing
- Do NOT use the `@page "/some/route"` directive in components.
- Do NOT use `<a href="/some/route">` with hardcoded URL paths.
- Do NOT use `NavigationManager.NavigateTo("/some/route")` with hardcoded strings.

### 2. Use PageState for Current Context
Always extract contextual routing information from the inherited `PageState` object in your `ModuleBase` components:
- `PageState.Page.Path` (The current page URL)
- `PageState.QueryString` (The current query string parameters)

### 3. Use ActionLink for Component Navigation
When navigating between components within the same module, always prefer the built-in `ActionLink` component:
```html
<ActionLink Action="Edit" Parameters="@($"id={item.Id}")" ResourceKey="EditItem" />
```

### 4. Use NavigateUrl for Programmatic Navigation
When you must use `NavigationManager` in C#, use the `NavigateUrl` extension method to safely construct the path:
```csharp
NavigationManager.NavigateTo(NavigateUrl(PageState.Page.Path, "Edit", $"id={item.Id}"));
```

Failure to follow these rules will break the module when installed on different pages or domains within an Oqtane tenant.
