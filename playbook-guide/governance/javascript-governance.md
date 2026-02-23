# JavaScript Governance

Oqtane is a modern Blazor framework.
JavaScript usage should be minimal.

AI tends to introduce JavaScript by default.
This is usually unnecessary.

Before generating JavaScript:

1. Confirm it cannot be implemented in C# Blazor.
2. Confirm it aligns with existing interop patterns.
3. Confirm it does not introduce framework drift.

JavaScript is opt in.
Not default.