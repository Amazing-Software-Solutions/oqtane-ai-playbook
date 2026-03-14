# 007 - Automated Onboarding and Governance Sync

## Purpose

To simplify the setup defined in `005-setup.md` and the adoption process in `006-module-adoption.md`, the playbook provides an automated script:

`sync-governance.ps1`

This PowerShell script ensures that a local Oqtane module solution is correctly configured for AI-governed development.

---

## The Simple Way: Start-Solution.cmd

The simplest way to use the script is via the provided command file:

`oqtane-ai-playbook\module-playbook-example\Start-Solution.cmd`

1.  **Copy this file** to your module's root directory.
2.  **Ensure your solution file** is named the same as your module's folder (e.g., `MyCompany.Module.X.slnx`).
3.  **Run `Start-Solution.cmd`**.

This will automatically run the sync script and open your solution in Visual Studio with governance active.

---

## What the Script Does

The script performs the following critical onboarding and maintenance tasks:

1.  **Framework Grounding**: Locates the local `Oqtane.Framework` source and adds `Oqtane.Client` and `Oqtane.Shared` as project references to your Visual Studio solution.
    - These references are added with `Build="false"` configuration.
    - They provide the "live documentation" required for AI to validate against canonical platform patterns.
2.  **Materialize Governance Files**: Physically creates required per-repo governance files if they are missing:
    - `.github/copilot-instructions.md` (AI behavior entry point)
    - `.github/module-instructions.md` (Module-specific AI hints)
    - `docs/ai-decision-timeline.md` (Binding memory)
    - `docs/deviations.md` (Documented exceptions)
3.  **Solution Visibility**: Adds all individual governance rules (`docs/governance/027x-*.md`) and prompt templates to the Visual Studio solution (`.slnx`).
    - **Note**: Visual Studio requires files to be explicitly referenced in the solution for AI tools (like GitHub Copilot) to "see" them.
4.  **Consistency**: Cleans up any stale or incorrect references to the playbook and ensures all paths are relative and portable.

---

## Location

The script is located in the reference layer:

`module-playbook-example/sync-governance.ps1`

---

## Usage

### Prerequisites

- Your module must use the modern Visual Studio Solution format (`.slnx`).
- The Oqtane Framework and AI Playbook repositories must be siblings in your workspace (as defined in `005-setup.md`).

### Running the Sync

#### Option 1: One-Click (Recommended)
Copy `Start-Solution.cmd` from the playbook to your module root and run it. This script automatically finds your `.slnx`, runs the sync, and opens Visual Studio.

#### Option 2: PowerShell
Open a PowerShell terminal in your module's root directory and run:

```powershell
# Run from the module directory, pointing to the script in the playbook sibling
..\oqtane-ai-playbook\module-playbook-example\sync-governance.ps1 -SolutionPath "."
```

### Parameters

| Parameter | Description |
| --- | --- |
| `-SolutionPath` | **(Mandatory)** Path to your `.slnx` file or the folder containing it. |
| `-DryRun` | Shows what would change without modifying any files. |
| `-Verbose` | Provides detailed output of every file and reference being processed. |

---

## When to Run

- **Initial Onboarding**: When first bringing a module under governance.
- **Rule Updates**: Whenever new governance rules are added to the `oqtane-ai-playbook`.
- **Environment Changes**: If you move your local Oqtane Framework folder.
- **Solution Repairs**: If AI assistant stops referencing the governance files (visibility check).

---

## Why Use the Script?

Manual solution management is error-prone. The `sync-governance.ps1` script ensures that the **Visibility Requirement** (defined in `006-module-adoption.md`) is always met. 

**If the files aren't in the solution, the AI is blind. The script ensures the AI can see.**

---

## Summary

`sync-governance.ps1` is the bridge between the **Playbook** and your **Real Module**. It automates the "tax" of governance setup so you can focus on building correct code.
