## 027x – JavaScript Usage


### Status

**Mandatory**

### Applies To

* AI-assisted development
* Module scaffolding
* UI behavior implementation
* Client-side interactivity
* Code generation (Copilot, Claude, Amazon Q, etc.)

* * *

### Rule Statement

Oqtane is a **Blazor-first framework** with an intentionally minimal JavaScript footprint (~1.6%).

**JavaScript must NOT be introduced unless a Blazor-based C# solution is demonstrably insufficient.**

AI-generated JavaScript is **opt-in, not default**.

* * *

### What This Rule Enforces

Before JavaScript is added, the following must be true:

* ✅ The requirement **cannot be reasonably implemented** using:

    * Blazor components
    * C# event handling
    * Render fragments
    * Built-in browser abstractions
* ✅ The JavaScript use case is **clearly justified**
* ✅ The JavaScript is:

    * Minimal
    * Isolated
    * Explicitly scoped
    * Documented
* ✅ The interop boundary is well-defined and stable

* * *

### What This Rule Prohibits

AI **must not** introduce JavaScript for:

* DOM manipulation achievable via Blazor
* UI state management
* Form validation
* Event handling
* Animations achievable with CSS
* Convenience or familiarity reasons (“JS is quicker”)

* * *

### Why This Rule Exists

* Oqtane’s strength is **C#-centric, strongly-typed UI architecture**
* Excess JavaScript:

    * Increases security surface area
    * Introduces maintainability risk
    * Breaks architectural consistency
    * Undermines Blazor’s value proposition
* AI tools naturally overproduce JavaScript unless constrained

This rule exists to **protect the platform**, not restrict innovation.

* * *

### Acceptable JavaScript Examples

JavaScript is acceptable when:

* A **browser-only API** is required (Clipboard, ResizeObserver, etc.)
* No Blazor abstraction exists
* Performance or compatibility demands it
* The JS code is treated as **infrastructure**, not logic

* * *

## ⚠️ Mandatory AI Warning Block (Pre-JavaScript)

> 
> 
> **STOP — JavaScript Governance Check**
> 
> 
> You are working within the Oqtane framework.
> 
> 
> Oqtane is a Blazor-first platform with an intentionally minimal JavaScript footprint (~1.6%).
> 
> 
> **Do NOT generate JavaScript by default.**
> 
> 
> Before producing any JavaScript, you must:
> 
> 1. Confirm that the requirement cannot be met using Blazor and C#
> 2. Justify why JavaScript is necessary
> 3. Ensure the JavaScript is minimal, isolated, and documented
> 
> 
> 
> If a Blazor-based solution is viable, **JavaScript generation is not permitted**.
> 
> 
> Prefer C# and Blazor patterns unless explicitly instructed otherwise.