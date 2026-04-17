# AI Instruction: REST API Controller Construction

**Instruction Context**: When the user requests to create or modify a Web API Controller, you must load and execute this file.

## Web API Construction Rules

When generating a Web API Controller for an Oqtane module, you MUST adhere to the following framework conventions. Do NOT generate standard, isolated ASP.NET Core controllers.

### 1. Base Class
Controllers MUST inherit from `ModuleControllerBase` (located in `Oqtane.Server.Controllers`).
```csharp
public class MyEntityController : ModuleControllerBase
```

### 2. Routing Convention
Controllers MUST use the standard Oqtane routing attribute format:
```csharp
[Route("api/[controller]")]
```
Do not use `[Route("api/MyModule/MyEntity")]` or custom prefixes unless explicitly requested.

### 3. Security and Antiforgery
Every controller MUST include the antiforgery validation filter to prevent CSRF attacks on API endpoints used by the Blazor client:
```csharp
[ServiceFilter(typeof(AutoValidateAntiforgeryTokenAttribute))]
public class MyEntityController : ModuleControllerBase
```
Additionally, ensure `[Authorize]` attributes are applied per the `027x-authorization` rules.

### 4. Dependency Injection
Use constructor injection for your module services, repositories, and the `ILogManager`. Do NOT inject `HttpContext` directly unless absolutely necessary; use the base class properties if possible.

### 5. Logging and Error Handling
Catch exceptions within controller methods, log them using `_logger.Log()`, and return standard `IActionResult` responses (e.g., `BadRequest()`, `NotFound()`, `StatusCode(500)`). Do NOT leak domain exceptions or raw stack traces to the client.
