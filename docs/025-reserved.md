# 025 - Reserved: Performance and Resource Boundaries

> **Status: Planned**
>
> This chapter is **reserved** for future content on performance and resource boundaries within module code.

---

## Intended Coverage

When written, this chapter will cover:

- What "expensive" means in an Oqtane module context (vs. a standard ASP.NET app)
- Required pagination for unbounded queries
- `async`/`await` discipline - avoiding blocking calls in Blazor components
- Memory and connection lifecycle in a multi-tenant host
- What AI tools commonly generate that creates resource risk:
  - Synchronous HTTP calls
  - Missing `CancellationToken` propagation
  - Loading entire tables without filters
  - Blazor `OnInitializedAsync` patterns that block rendering
- Hard rules vs. guidance in this space (most performance concerns are guidance;
  a small number - like blocking the render thread - are hard rules)

---

## Why This Gap Exists

The conclusion (`100-conclusion.md`) explicitly lists "Performance boundaries" as
a planned addition. This slot reserves the number and provides interim pointers.

Until this chapter is written, refer to:

- `013-scheduled-jobs.md` - "Long-running blocking work" as a forbidden pattern
- Standard ASP.NET Core performance guidance for async patterns (external)

---

> **Do not use this file number** for any other topic.
> When this chapter is written, replace this placeholder entirely.
