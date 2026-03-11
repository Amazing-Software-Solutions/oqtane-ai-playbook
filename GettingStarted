# Oqtane AI Playbook

![Oqtane AI Playbook Logo](Oqtane-AI-Playbook-Logo.png)

## Setup and Integration Guide

This guide explains how to integrate the **Oqtane AI Playbook** into your existing Oqtane development environment so that AI tools such as GitHub Copilot can follow the Playbook governance rules when generating code.

---

# 1. Clone the Oqtane AI Playbook

Clone the **Oqtane AI Playbook** repository into the same root development directory where your Oqtane modules are located.

Example development structure before cloning:

```
\Source
├─ Oqtane.Framework
├─ MyCompany.Module.MyModule1
├─ MyCompany.Module.MyModule2
└─ MyCompany.Module.MyModule3
```

After cloning the Playbook:

```
\Source
├─ Oqtane.Framework
├─ oqtane-ai-playbook
├─ MyCompany.Module.MyModule1
├─ MyCompany.Module.MyModule2
└─ MyCompany.Module.MyModule3
```

The Playbook should sit **alongside your modules**, not inside them.

---

# 2. Prepare Your Solution

To enable AI tooling integration, your Visual Studio solution must be saved as a **`.slnx` solution file**.

If your solution is currently `.sln`, save a copy as:

YourSolution.slnx

The `.slnx` format allows AI tooling to better discover workspace resources.

---

# 3. Add the Playbook Starter Script

Copy the starter script from the Playbook example project:

`
.\oqtane-ai-playbook\module-playbook-example\Start-Solution.cmd
`

Place this file in the **root of your development folder**:

`\Source\Oqtane\Start-Solution.cmd`

---

# 4. Launch the Playbook Enabled Solution

Double click:

Start-Solution.cmd

This script will:

- Open the Visual Studio solution
- Register the Playbook example resources
- Expose governance rules to AI tools
- Ensure Copilot can discover the Playbook guidance

The **module-playbook-example** project acts as a **reference implementation** and demonstrates how Playbook governed modules should be structured.

Note that this example project may evolve over time as the Playbook grows.

---

# 5. Verify Copilot Recognizes the Playbook

After Visual Studio loads, confirm that GitHub Copilot can see the Playbook rules.

In Copilot Chat, run the following prompt:

What governance rules from the Oqtane AI Playbook are available in this workspace?

Copilot should reference Playbook rules such as:

- Runtime Awareness
- Migrations
- Packaging and Dependencies
- UI Governance
- Scheduled Jobs and Site Tasks

If these rules appear in the response, the Playbook has been successfully integrated.

---

# 6. Next Steps

Once the Playbook is active, you can begin prompting AI using Playbook aware instructions such as:

Create a new Oqtane module following the Oqtane AI Playbook governance rules.

or

Implement a migration following rule **027x-migrations.md**

This ensures generated code follows **deterministic architecture patterns** defined by the Playbook.