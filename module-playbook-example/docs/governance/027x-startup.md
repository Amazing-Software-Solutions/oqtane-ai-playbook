# 027x – Startup and Service Registration Rules

## Scope

Applies when registering services or modifying startup behavior.

---

## Enforced Rules

- Client services must be registered in `IClientStartup`
- Server services must be registered in `IServerStartup`
- No modification of `Program.cs` or `Startup.cs`
- No global DI changes

---

## Explicitly Forbidden

- Generic ASP.NET Core startup patterns
- Hosted services outside Oqtane-controlled mechanisms

---

## Rejection Criteria

Reject if:

- Services are registered elsewhere
- Global startup is modified
- DI is assumed or bypassed
