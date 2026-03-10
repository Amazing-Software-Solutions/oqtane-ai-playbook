# AI Governance

## Purpose

This document defines **how AI is governed** within Oqtane module development.

It does **not** define subsystem rules.
It defines **authority, enforcement, and rejection mechanics**.

AI is treated as a **code generation assistant**, not an architect,
designer, or decision-maker.

---

## Core Principle

> **AI may generate code, but it may not define rules.**

All architectural decisions, constraints, and patterns are defined
outside AI systems and enforced *against* their output.

---

## Authority Hierarchy

When evaluating AI output, authority is resolved in this order:

1. Canonical reference implementations  
2. Rule reference documents (`027-*`)
3. Repository governance documents
4. Oqtane framework constraints
5. AI-generated output

**AI always ranks last.**

---

## Rule-Based Governance Model

This repository uses a **rule reference model**.

- `027-rules-index.md` defines *what rules exist*
- `027x-*` documents define *enforceable rules*

AI must **discover and apply relevant rule documents**
before generating or modifying code.

---

## Governance Rule Proposals

Contributors may propose new governance rules using the template located at:

docs/governance-templates/027x-rule-proposal-template.md

Proposed rules are not enforceable until approved and indexed.

---

## Mandatory Rule Discovery

Before responding to any request, AI must:

1. Identify which technical domains the request touches
2. Locate applicable rule documents via `027-rules-index.md`
3. Validate output against those rules

Failure to perform rule discovery invalidates the output.

---

## AI Rejection Mandate

AI-generated output **must be rejected immediately** if it:

- Violates a rule reference document
- Introduces non-canonical patterns
- Assumes architectural authority
- Bypasses enforcement logic
- Introduces ambiguity or convenience abstractions

Correction is optional.  
**Rejection is mandatory.**

---

## Review Expectations

AI output is reviewed as if written by:

- A junior developer
- With no domain context
- With no authority to make architectural decisions

The burden of proof lies with the output, not the reviewer.

---

## AI Is Stateless

## Instruction Discovery Rules

The **027x-ai-instruction-discovery.md** rule is a critical component of the Oqtane governance framework. It mandates that AI assistants:

1. **Locate and Apply Instruction Files**: Before generating or modifying code, AI must check for the presence of `.github/copilot-instructions.md` at the solution or module root.
2. **Override Default Behavior**: If this file exists, its contents become the authoritative source for AI behavior, overriding generic defaults.
3. **Enforce Precedence**: This rule takes precedence over all other rule types in the authority hierarchy (see "Authority Hierarchy" section), ensuring that instruction-based governance is the first step in the validation process.

Failure to follow this rule invalidates all subsequent governance checks. AI must refuse to proceed if the instruction file cannot be resolved.

This rule ensures that all AI-generated code is consistently governed by explicitly defined behavioral guidelines, preventing accidental deviations from established standards.

AI has:
- No memory
- No responsibility
- No awareness of consequences

Therefore:
- All rules must be explicit
- All constraints must be visible
- All enforcement must be codified

---

## Enforcement Statement

- Governance is not advisory
- Correctness does not override compliance
- Discipline outranks convenience
- AI exists to reduce effort, **not standards**

Any violation invalidates the output.

---

## Prompt Governance

AI behavior is influenced by prompt structure.

To ensure consistent rule application:

- Canonical prompt examples are maintained under `docs/governance/prompts/`
- Prompts in this repository are considered **blessed entry points**
- Deviating from canonical prompts increases risk of rule violation

AI must prefer:
- Explicit constraint prompts
- Compliance checklists
- Negative constraints (“must not”)

If a prompt contradicts a rule, **the rule wins**.

---

## Instruction Discovery Rules

This rule defines how AI assistants must discover and apply authoritative
instruction files within an Oqtane module solution. AI behavior must be governed by file-backed instructions, not assumed defaults or conversational memory.

### Rule Statement

When generating or modifying code in an Oqtane module solution, the AI MUST:

1. Look for `.github/copilot-instructions.md` at the solution or module root
2. Treat this file as authoritative behavioral guidance
3. Apply its instructions before generating or modifying any code

If the file exists, its contents MUST override generic AI defaults.

### Instruction Extension Model

The canonical instruction file MAY reference additional instruction files (e.g., module-specific instructions). AI MUST follow this chain of references explicitly and in order.

AI MUST NOT:
- Ignore `.github/copilot-instructions.md`
- Invent instructions not backed by files
- Assume instructions from previous conversations
- Replace or rewrite instruction files unless explicitly asked

### Refusal Conditions

The AI MUST refuse to proceed if:

- `.github/copilot-instructions.md` exists but cannot be read
- Referenced instruction files are missing or ambiguous
- Conflicting instruction files are discovered without precedence defined

### Required Refusal Message

> I cannot proceed because authoritative AI instructions exist in `.github/copilot-instructions.md`, but they could not be resolved safely. Please confirm the instruction structure or resolve the ambiguity.

### Rationale

Different AI assistants use different memory and instruction mechanisms. File-backed instruction discovery ensures:

- Deterministic behavior
- Tool-agnostic governance
- Repeatable results across AI assistant tools

This rule prevents accidental bypass of established governance.

### Summary

AI behavior must be driven by **discovered instructions**, not remembered ones. If `.github/copilot-instructions.md` exists, it is mandatory.