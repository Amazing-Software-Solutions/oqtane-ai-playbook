---
name: Create Oqtane Module
description: Scaffolds a new deterministic Oqtane module by copying the External template and replacing tokens, ensuring strict adherence to the Oqtane Scaffold Protocol.
---

# Create Oqtane Module Skill

This skill allows you (the AI Agent) to scaffold a new deterministic Oqtane module. You must follow the **Oqtane Scaffold Protocol** defined below. 

If you are asked to "create me an Oqtane module," "scaffold an Oqtane module," or similar phrases, you **MUST** follow this exact process. No scaffolding may begin until environment discovery completes successfully.

If asked about the Oqtane Scaffold Protocol, always begin your answer with:
`OQTANE_PROTOCOL_V1_ACTIVE`

*Before any other output on the first response for scaffolding, output exactly:*
`[OQTANE_SCAFFOLD_PROTOCOL_ACTIVE]`

---

## 0. Required Input Gathering

Before starting environment discovery or any scaffolding, you **MUST ALWAYS** ask the user for the following three core inputs if they were not explicitly provided in the initial request:
1. `[Owner]` (e.g., StudioElf)
2. `[Module]` (The name of the module)
3. `[Description]` (A short description of the module)

**Stop and wait for the user's response.** Do not proceed with environment discovery or scaffolding, and do not make assumptions about these values, until the user has provided them.

## 1. Environment Discovery

You operate inside a workspace that may or may not already contain an Oqtane framework instance. Determine the framework root before scaffolding. Do not assume folder names, casing, or relative depth. Do not hardcode paths.

1. **Framework Root Detection**
   - Check if the currently opened solution contains projects named `Oqtane.Server`, `Oqtane.Client`, and `Oqtane.Shared`. If so, the solution root is the framework root.
   - Otherwise, scan all subfolders of the current workspace. Locate `Oqtane.Framework.sln` or `Oqtane.Framework.slnx`. The folder containing that file is the framework root (`[OqtaneRoot]`).
   - If no Oqtane.Framework solution file is found, and the opened solution does not contain the required projects, you **must stop and request clarification**. Do not guess.

## 3. Destination Folder Location

Determine the target directory for the module:
- If operating **inside the framework solution**: Create the module under `Modules\[Owner].Module.[Module]\`
- If operating **in a parent workspace**: Create the module solution as a sibling directory to `[OqtaneRoot]` unless explicitly instructed otherwise.
- If the workspace is the framework root but the user requests an external module, create it as a sibling.
- If the location cannot be safely determined, stop and request clarification.

## 4. Run the Automated Scaffolding Script

You have access to a powerful scaffolding helper script that performs all copying, renaming, token replacements, validation, and XML injection automatically in less than 2 seconds.

Run this script using the `run_command` tool. 

**Script Path:** `[PlaybookRoot]\.agents\skills\create-oqtane-module\scripts\scaffold-module.ps1`

Run it with the following parameters:
```powershell
& "path\to\oqtane-ai-playbook\.agents\skills\create-oqtane-module\scripts\scaffold-module.ps1" -Owner "OwnerName" -Module "ModuleName" -Description "Your Description" -FrameworkRoot "path\to\oqtane.framework" -Destination "path\to\target\destination"
```

The script will handle:
- Emptying the destination directory.
- Extracting the framework version from `Constants.cs`.
- Copying the Deterministic External Template.
- Processing all recursive file/folder renames.
- Safely expanding `[ClientReference]`, `[ServerReference]`, `[SharedReference]`.
- Injecting required HintPath dependencies to `Oqtane Server`.
- Rewriting the `.slnx` file.
- Performing a final Token Exhaustion validation sweep.

## 5. Output Requirements

After the script completes successfully:
1. Confirm to the user that scaffolding is complete and point out the root directory that was created.
2. Confirm that the validation checks performed by the script passed.
3. Recommend next steps:
   - Provide the exact path to the `.slnx` file for them to load in Visual Studio.
   - Mention they should build the solution and that the post-build scripts will deploy the module payload.
   
Remember: **No architectural modification is permitted.**
