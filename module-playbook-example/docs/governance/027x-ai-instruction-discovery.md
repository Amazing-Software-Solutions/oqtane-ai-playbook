# 027x — AI Instruction Discovery

## Description

This rule defines how AI assistants must discover and apply authoritative
instruction files within an Oqtane module solution.

AI behavior must be governed by file-backed instructions, not assumed defaults
or conversational memory.

---

## Rule Statement

When generating or modifying code in an Oqtane module solution, the AI MUST:

1. Look for `.github/copilot-instructions.md` at the solution or module root
2. Treat this file as authoritative behavioral guidance
3. Apply its instructions before generating or modifying any code

If the file exists, its contents MUST override generic AI defaults.

---

## Instruction Extension Model

The canonical instruction file MAY reference additional instruction files
(e.g. module-specific instructions).

AI MUST follow this chain of references explicitly and in order.

AI MUST NOT:
- Ignore `.github/copilot-instructions.md`
- Invent instructions not backed by files
- Assume instructions from previous conversations
- Replace or rewrite instruction files unless explicitly asked

---

## Refusal Conditions

The AI MUST refuse to proceed if:

- `.github/copilot-instructions.md` exists but cannot be read
- Referenced instruction files are missing or ambiguous
- Conflicting instruction files are discovered without precedence defined

### Required Refusal Message

> I cannot proceed because authoritative AI instructions exist in
> `.github/copilot-instructions.md`, but they could not be resolved safely.
> Please confirm the instruction structure or resolve the ambiguity.

---

## Rationale

Different AI assistants use different memory and instruction mechanisms.
File-backed instruction discovery ensures:

- Deterministic behavior
- Tool-agnostic governance
- Repeatable results across AI assistant tools

This rule prevents accidental bypass of established governance.

---

## Summary

AI behavior must be driven by **discovered instructions**, not remembered ones.

If `.github/copilot-instructions.md` exists, it is mandatory.
