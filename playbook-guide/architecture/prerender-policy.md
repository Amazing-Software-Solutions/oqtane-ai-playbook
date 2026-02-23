# Prerender Policy

IModuleControl.Prerender changes the architecture conversation.

Prerender is not just hosting behavior.
It is a module level architectural decision.

In many cases, the cleanest solution to duplicate execution
is opting out of prerender entirely.

Use prerender when:

- The module benefits from meaningful server rendered output.
- SEO or perceived performance matters.

Disable prerender when:

- Execution duplication causes state issues.
- The module is interactive and state heavy.

Treat prerender as a policy decision.
Not a default assumption.