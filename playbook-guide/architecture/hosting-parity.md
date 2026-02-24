# Hosting Parity

Oqtane supports both:

- Server mode
- WebAssembly mode

These execution paths must produce identical behavior.

ClientService -> ServerService
ClientService -> Controller -> ServerService

Both must result in the same data and logic execution.

## Why This Matters

Inconsistencies only surface in production.
They are subtle.
They damage trust.

Hosting parity is non negotiable.

## Correct Approach

- Business logic lives in ServerService.
- Controllers only delegate.
- ClientService never contains business logic.
- Test both hosting modes.