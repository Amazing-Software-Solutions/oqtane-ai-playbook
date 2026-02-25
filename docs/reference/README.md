# Reference Documentation

This folder contains **conceptual reference material only**.

There is no copied or duplicated canonical module in this repository.

---

## Canonical Source of Truth

All architectural validation is performed against the **Oqtane Framework source code**, including:

- Oqtane.Client
- Oqtane.Server
- Oqtane.Shared
- Internal framework modules (e.g. HtmlText)
	- Boilerplate template found at .\Oqtane.Framework\Oqtane.Server\wwwroot\Modules\Templates\External\
- Framework jobs, migrations, validation, and error handling

The framework itself is the **canonical implementation**.

---

## Important

- No example modules are duplicated here
- No framework code is mirrored
- Governance rules must be verifiable against the framework source

If a pattern does not exist in the Oqtane Framework, it must not be enforced.
