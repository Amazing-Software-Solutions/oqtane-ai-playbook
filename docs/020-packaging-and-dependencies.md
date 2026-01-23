# Packaging and External Dependencies in Oqtane Modules

## Overview

Oqtane module development differs from standard .NET application development
when it comes to external dependencies and packaging.

NuGet package restore completes **build-time resolution only**.
Oqtane does not automatically resolve or deploy module dependencies into the
server runtime environment.

This distinction is subtle, frequently missed by AI tooling, and a common source
of runtime failures that are misattributed to Oqtane or Blazor.

---

## Why This Matters

When a package is added to a module project:

- The project may compile successfully
- The application may start
- Runtime failures occur only when the dependency is first used

These failures typically appear as:
- `FileNotFoundException`
- `TypeLoadException`
- Missing assembly errors in the server log

The root cause is almost always the same:
**the dependency DLLs were never deployed to the Oqtane Server runtime bin**.

---

## Deployment Reality

Oqtane modules run inside a hosted server environment.

This means:

- NuGet restore does **not** place assemblies in the runtime bin
- External dependencies must be copied explicitly
- The module `.nuspec` must be updated for packaged deployment

These steps are part of the platform contract, not optional conveniences.

---

## Implications for AI-Governed Development

Generic AI behavior assumes:
- NuGet restore implies runtime availability
- Project references are sufficient
- Packaging is handled automatically

None of these assumptions hold true in Oqtane.

For this reason, the **Module Playbook** enforces a strict rule:
external dependencies may not be added unless runtime deployment and packaging
are handled explicitly.

This protects developers from silent partial success and difficult-to-diagnose
runtime errors.

---

## Where This Is Enforced

This behavior is governed by the following rule in the
**Module-Playbook-Example**:

- `027x-packaging-and-dependencies.md`

The playbook document explains *why*.
The governance rule defines *what must be enforced*.

---

## Key Takeaway

Adding a NuGet package to an Oqtane module is never “just a package add”.

It is a deployment decision, a packaging decision, and a runtime decision —
all of which must be handled explicitly.

Any AI behavior that ignores this reality must be corrected or refused.
