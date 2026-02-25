# Change Log

# Release 1.1.0
## What's Changed
* Add Oqtane AI Playbook logo and README by @leigh-pointer in https://github.com/leigh-pointer/oqtane-ai-playbook/pull/12
* Inital readable guidance by @leigh-pointer in https://github.com/leigh-pointer/oqtane-ai-playbook/pull/13
* Expand migration governance and versioning guide by @leigh-pointer in https://github.com/leigh-pointer/oqtane-ai-playbook/pull/14
* Clarify migration execution and governance by @leigh-pointer in https://github.com/leigh-pointer/oqtane-ai-playbook/pull/15
* Add table naming governance to migrations doc by @leigh-pointer in https://github.com/leigh-pointer/oqtane-ai-playbook/pull/17
* Add Oqtane Client/Shared project references by @leigh-pointer in https://github.com/leigh-pointer/oqtane-ai-playbook/pull/18
* Clarify and tighten database migration governance by @leigh-pointer in https://github.com/leigh-pointer/oqtane-ai-playbook/pull/19
* Update docs and remove example VERSION file by @leigh-pointer in https://github.com/leigh-pointer/oqtane-ai-playbook/pull/20
* Add boilerplate template path to docs by @leigh-pointer in https://github.com/leigh-pointer/oqtane-ai-playbook/pull/22


**Full Changelog**: https://github.com/leigh-pointer/oqtane-ai-playbook/compare/1.0.1...1.1.0

# Release 1.0.1

This release updates the Migration area of the Module Playbook example.

## What's Changed
* Add changelog and version files; ignore *.bak by @leigh-pointer in https://github.com/leigh-pointer/oqtane-ai-playbook/pull/8
* Add migration versioning and RevisionNumber rules Upate for #7 by @leigh-pointer in https://github.com/leigh-pointer/oqtane-ai-playbook/pull/9


### Updated [027x migrations](module-playbook-example/docs/governance/027x-migrations.md)

Enhance migration governance doc with strict versioning and enforcement guidance. Adds an AI enforcement warning and new Rule 3 (Version Increment Strategy) that clarifies the 8-digit MMmmPPbb format, default behavior to only increment the build segment, strict increasing requirement, and rejection conditions. Adds Rule 4 (Mandatory RevisionNumber Update) requiring ModuleInfo.cs RevisionNumber to match the latest migration as an 8-digit, comma-separated, no-space string (example: "01,00,00,04" for migration 01000004). Includes examples, rationale, and failure cases to ensure migrations are executed and schema stays in sync.

**Full Changelog**: https://github.com/leigh-pointer/oqtane-ai-playbook/compare/1.0.0...1.0.1

