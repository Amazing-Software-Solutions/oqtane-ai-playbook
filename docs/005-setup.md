# Oqtane Development Environment Setup

## Purpose

This document defines the **canonical local development layout** for Oqtane-based development when using the Oqtane AI Playbook.

This structure is assumed throughout the playbook and is treated as **non-negotiable context** for AI-assisted development.

>**If this setup is not followed, the guarantees and rules in this playbook do not apply.**

---

## Canonical Development Root

All development is performed under a single root folder:

```
D:\Oqtane Development\
```

This root folder :
- Is **not** a Git repository  
- Exists purely as a local workspace boundary  
- Contains multiple independent repositories as siblings  

Each child folder manages its own source control independently.

---

## Oqtane Framework Setup

### Step 1 — Download the Oqtane Framework

Download the Oqtane Framework source distribution.

### Step 2 — Extract the Framework

Extract the framework to:

```
D:\Oqtane Development\Oqtane.Framework
```

### Expected Structure

Inside the framework folder you must see:

```
Oqtane.Framework/
├── Oqtane.Client
├── Oqtane.Server
├── Oqtane.Shared
├── Oqtane.Infrastructure
├── Oqtane.Package
└── solution and build files
```

This folder represents the **framework source**.

### Important Constraints

- The framework folder is **not governed** by this playbook
- Framework source is **not modified** to accommodate AI tools
- AI governance rules apply **only to custom modules**
- The framework is treated as an external, authoritative dependency

The playbook constrains **your code**, not the framework.

---

## Oqtane AI Playbook Placement

### Step 3 — Clone the Playbook

Clone the Oqtane AI Playbook into the same root:

```
D:\Oqtane Development\Oqtane-AI-Playbook
```

### Resulting Layout

```
D:\Oqtane Development\
├── Oqtane.Framework
└── Oqtane-AI-Playbook
```

### Role of the Playbook

The Oqtane AI Playbook:

- Is the **authoritative governance source**
- Defines architectural rules, constraints, and rejection criteria
- Anchors AI behavior across all modules
- Is **referenced**, not copied, by individual solutions or modules
- Evolves independently of any single project

The playbook exists **outside** modules to remain neutral, stable, and enforceable.

---

## Verification Checklist

Before proceeding to module creation or adoption, verify:

- [ ] `Oqtane.Framework` builds successfully
- [ ] `Oqtane-AI-Playbook` is cloned and readable
- [ ] Both exist as sibling folders under the same root
- [ ] No framework files were modified during setup

If any item fails, **stop**.

All subsequent documents assume this environment.


---

## Summary

- One development root
- Framework and playbook are siblings
- Governance is external, explicit, and versioned
- AI constraints are established **before** writing module code

This layout is the foundation for **safe, predictable, AI-assisted Oqtane development**.