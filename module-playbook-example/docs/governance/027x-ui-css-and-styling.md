### Rule: UI CSS and Styling in Oqtane (Mandatory)

#### ⚠️ AI WARNING – READ BEFORE GENERATING ANY CSS

Oqtane **does not support ASP.NET Core Blazor CSS isolation**.

Do **NOT*-  generate:

-  `.razor.css` files
-  Scoped / component-isolated CSS
-  Instructions that rely on Blazor CSS isolation

All module styling **must*-  follow the Oqtane styling model described below.

---

### Background

Oqtane is a Blazor-first, server-driven framework with a deliberately minimal JavaScript and CSS footprint.

The platform does **not*-  implement ASP.NET Core Blazor CSS isolation and does not load or scope component-level `.razor.css` files.

AI tools frequently assume CSS isolation because it is common in generic Blazor samples.

That assumption is **incorrect*-  for Oqtane and leads to styles that silently fail at runtime.

---

### Required Pattern

All module-specific CSS **must**:

-  Be placed in a single `Module.css` file
-  Reside in the **Server project**
-  Live under `wwwroot`
-  Be explicitly commented


**Required comment format**

```
/-  
  Module: ExampleModule
  Component: ExampleComponent.razor
  Purpose: Layout and visual styling for example view
*/
```

This ensures:

-  Predictable loading
-  Clear ownership
-  Long-term maintainability

---

### Prohibited Patterns

The following are **not allowed*-  in Oqtane modules:

-  `.razor.css` files
-  CSS isolation or scoped styling
-  Assumptions about automatic style bundling
-  Component-local CSS files

If an AI-generated solution includes any of the above, it **must be rewritten**.

---

### Enforcement Criteria

Any solution (human or AI) that:

-  Introduces `.razor.css`
-  Mentions “CSS isolation”
-  Relies on scoped component styles

**Fails governance review*-  and must be corrected before acceptance.

---

### Guidance for AI-Generated Output

When styling is required:

1. Prefer existing framework styles (Bootstrap, MudBlazor, Radzen)
2. Implement custom styles in `Module.css`
3. Keep selectors explicit and well-scoped via class naming
4. Comment all non-trivial styling

AI must assume that **CSS isolation is unavailable*-  unless explicitly told otherwise. 