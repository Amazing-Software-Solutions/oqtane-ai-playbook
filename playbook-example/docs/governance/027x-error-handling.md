# Oqtane Error Handling Rules (Enforced)

These rules govern **all error handling** in Oqtane modules.

Error handling exists to:
- Preserve system stability
- Surface actionable diagnostics
- Prevent silent failures

Errors must be **explicit, logged, and intentional**.

---

## Rule 1: No Silent Failures

Errors must never be swallowed.

**Reject if:**
- Exceptions are caught and ignored
- Failures do not surface any signal

---

## Rule 2: Explicit Try/Catch Boundaries

Use try/catch blocks only when:

- You can handle the failure meaningfully
- You can add context
- You can return a controlled response

**Reject catch blocks that only suppress errors.**

---

## Rule 3: Logging Is Mandatory for Failures

All non-trivial failures must be logged.

Logs must include:
- Context
- Exception details
- Action being performed

**Reject unlogged failures.**

---

## Rule 4: Client vs Server Error Separation

- Client code handles:
  - UX-safe error presentation
- Server code handles:
  - Logging
  - Diagnostics
  - Enforcement

**Reject server exceptions leaking raw details to the client.**

---

## Rule 5: Transport Validation First

When debugging failures, validate in this order:

1. Transport correctness (JSON vs HTML)
2. HTTP status code
3. Authorization / middleware
4. Application logic

**Reject jumping directly to business logic analysis.**

---

## Rule 6: Predictable Error Responses

Error responses must be:
- Deterministic
- Structured
- Consistent

**Reject inconsistent or ad-hoc error formats.**

---

## Rule 7: No Framework Suppression

Framework-level exceptions must not be:
- Suppressed
- Replaced
- Masked

**Reject attempts to “handle around” framework failures.**

---

## Error Handling Checklist

An implementation is valid only if:

- Errors are never silent
- Failures are logged with context
- Client and server responsibilities are separated
- Transport issues are validated first

If any check fails, **reject the change**.

---

This rule set exists to prevent hidden failures and diagnostic blind spots.
