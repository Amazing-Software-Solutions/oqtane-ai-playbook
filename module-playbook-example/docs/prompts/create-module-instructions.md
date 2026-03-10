If asked about Oqtane Scaffold Protocol, always begin your answer with:
OQTANE_PROTOCOL_V1_ACTIVE

# Instruction Compliance Marker

If these rules have been loaded and understood, Copilot must include the following line at the start of its first scaffolding response:

[OQTANE_SCAFFOLD_PROTOCOL_ACTIVE]

This line must appear alone on the first line before any other output.

---

# Oqtane Module Generation Rules

These rules are mandatory whenever an Oqtane module is requested, including phrases such as:

* create me an Oqtane module
* scaffold an Oqtane module called X
* generate a new Oqtane module
* create module X
* create me a mixed Oqtane module

No scaffolding may begin until environment discovery completes successfully.

---

# Operating Context

Copilot operates inside a workspace that may or may not already contain an Oqtane framework instance.

Copilot must determine the framework root before scaffolding.

Copilot must never assume folder names, casing, or relative depth.

Copilot must not hard reference paths.

---

# Environment Discovery

## Framework Root Detection

1. If the currently opened solution contains projects named Oqtane.Server, Oqtane.Client, and Oqtane.Shared, then:

   * The solution root is the framework root.

2. Otherwise:

   * Scan all subfolders of the current workspace.
   * Locate:

     * Oqtane.Framework.sln
     * or Oqtane.Framework.slnx
   * The folder containing that file is the framework root.
   * That folder becomes [OqtaneRoot].

If no Oqtane.Framework.sln or .slnx file is found, and the opened solution does not contain the required projects, scaffolding must stop and request clarification.

No guessing is permitted.

---

# Module Solution Location

If operating inside the framework solution:

Create the module under:

Modules[Owner].Module.[Module]\

If operating in a parent workspace:

Create the module solution as a sibling directory to [OqtaneRoot] unless explicitly instructed otherwise.

If the workspace is the framework root but the user requests an external module, create as sibling.

If location cannot be safely determined, stop and request clarification.

---

# Deterministic Scaffold Mode

Template path relative to [OqtaneRoot]:

Oqtane.Server\wwwroot\Modules\Templates\External

The External template is the single source of truth.

Copilot must:

* Copy the template exactly.
* Preserve SDK.
* Preserve TargetFramework.
* Preserve file layout.
* Preserve project structure.
* Preserve all non token content.
* Replace tokens only.

Copilot must not:

* Upgrade or downgrade dependencies.
* Modify architecture.
* Refactor code.
* Improve code.
* Add new patterns.
* Add new dependencies.
* Remove files.
* Reorganize folders.
* Add UI frameworks.
* Change solution ordering.

Only deterministic token replacement is allowed.

---

# Destination Folder Sanitization

Before copying the External template:

1. If the destination module folder already exists:

   * Delete the entire folder recursively.
   * Recreate it as an empty directory.
   * Do not merge.
   * Do not overwrite selectively.
   * Do not preserve existing files.

2. No residual artifacts from previous scaffolds are permitted.

3. If deletion fails, scaffolding must stop and report error.

This prevents stale project files, stray csproj files, or previous module artifacts from contaminating the scaffold.

---

# Pre Replacement Static File Validation

After copying the template but before token replacement:

1. Inspect every file in the destination.

2. For each file that is expected to be tokenized:

   * Confirm it contains at least one valid token pattern:
     [[A-Za-z0-9]+]

3. If a file contains no tokens and is not a known static asset
   such as images, dlls, or third party content,
   report a warning.

4. This prevents static filenames or hardcoded values from silently bypassing replacement.

---

# Module Naming

Namespace format:

StudioElf.Module.[Module]

Solution folder:

[Owner].Module.[Module]

Default values:

[Owner] = StudioElf
[Module] = provided module name
[Description] = "[Module] Description" if not provided
[ServerManagerType] = "[Owner].Module.[Module].Manager.[Module]Manager, [Owner].Module.[Module].Server.Oqtane"

---

# Framework Version Resolution

[FrameworkVersion] must be extracted from:

Oqtane.Shared\Shared\Constants.cs

Process:

1. Open Constants.cs.
2. Locate:
   public static readonly string Version = "X.X.X";
3. Extract the string literal.
4. Replace [FrameworkVersion] with that exact value.
5. Do not calculate.
6. Do not infer.
7. Do not hardcode.

If the constant cannot be located, stop and report error.

---

# RootFolder Token Resolution

After [OqtaneRoot] and module location are known:

1. Compute the relative path *from the module project folder to [OqtaneRoot]*.
   - **Do not prepend `..\` yourself**; the template already includes the
     parent‑directory segment. The computed value should point to the
     framework folder itself (e.g. `oqtane.framework` when the module sits
     alongside it).
2. Replace `[RootFolder]` with that computed relative path.
3. Use backslashes.
4. Do not assume depth.
5. Do not hardcode.

This prevents double-`..` sequences appearing in the generated solution file.
---

# Reference Token Expansion

In addition to the basic tokens, the scaffold must also replace three special
reference tokens inside project files. These tokens are typically located in a
single `<ItemGroup>` block and **must be expanded** *after* the other tokens
have been replaced so that the resulting XML is valid.

Valid expansions:

* **[ClientReference]**
  Expands to:
  ```xml
  <ProjectReference Include="..\Client\[Owner].Module.[Module].Client.csproj" />
  ```

* **[SharedReference]**
  Expands to:
  ```xml
  <ProjectReference Include="..\Shared\[Owner].Module.[Module].Shared.csproj" />
  ```

* **[ServerReference]**
  Expands to:
  ```xml
  <ProjectReference Include="..\Server\[Owner].Module.[Module].Server.csproj" />
  ```

For project types where a given reference is not applicable the token
must resolve to an empty string (i.e. nothing should be injected).

Any raw text remaining inside an `<ItemGroup>` after replacement is a
validation error; only valid MSBuild elements are allowed.

Implementations should ensure these tokens are processed as part of the
replacement step and that the exhaustion validation (see below) will catch any
which were missed.

---

# Framework Reference Addition

After token replacement, add the following framework assembly references to the respective module projects using HintPath to the built DLLs, as the framework projects may not be loaded in the module solution:

* In [Owner].Module.[Module].Client.csproj, add:
  ```xml
  <Reference Include="Oqtane.Client">
    <HintPath>..\..\[RootFolder]\Oqtane.Server\bin\Debug\net10.0\Oqtane.Client.dll</HintPath>
  </Reference>
  <Reference Include="Oqtane.Shared">
    <HintPath>..\..\[RootFolder]\Oqtane.Server\bin\Debug\net10.0\Oqtane.Shared.dll</HintPath>
  </Reference>
  ```

* In [Owner].Module.[Module].Server.csproj, add:
  ```xml
  <Reference Include="Oqtane.Server">
    <HintPath>..\..\[RootFolder]\Oqtane.Server\bin\Debug\net10.0\Oqtane.Server.dll</HintPath>
  </Reference>
  <Reference Include="Oqtane.Shared">
    <HintPath>..\..\[RootFolder]\Oqtane.Server\bin\Debug\net10.0\Oqtane.Shared.dll</HintPath>
  </Reference>
  ```

* In [Owner].Module.[Module].Shared.csproj, add:
  ```xml
  <Reference Include="Oqtane.Shared">
    <HintPath>..\..\[RootFolder]\Oqtane.Server\bin\Debug\net10.0\Oqtane.Shared.dll</HintPath>
  </Reference>
  ```

These references are essential for external modules to compile against the Oqtane framework during development when project references are not feasible.

---

# Solution File Rules

Solution file must follow this exact ordering:

1. Client
2. Package
3. Server
4. Shared
5. Oqtane.Server

Example structure:

<Project Path="Client/[Owner].Module.[Module].Client.csproj" />
<Project Path="Package/[Owner].Module.[Module].Package.csproj" />
<Project Path="Server/[Owner].Module.[Module].Server.csproj" />
<Project Path="Shared/[Owner].Module.[Module].Shared.csproj" />
<Project Path="../Oqtane.Framework/Oqtane.Server/Oqtane.Server.csproj">
  <Build Project="false" />
</Project>

Forward slashes must be used in solution file paths.

No double escaping.

No relative depth guessing.

---

# Token Replacement Scope

Replace tokens in:

* File contents
* File names
* Folder names
* Solution files
* Project files
* Nuspec files
* Json files
* Cmd files

Valid tokens:

[Owner]
[Module]
[Description]
[RootFolder]
[ServerManagerType]
[ClientReference]
[ServerReference]
[SharedReference]
[FrameworkVersion]

Do not replace:

[FromBody]
[HttpGet]
[HttpPost]
[Key]
Any ASP.NET attribute
Any DataAnnotation attribute

---

# Token Exhaustion Validation

After generation:

1. Recursively search **all** generated files (not just the top level) for the regex pattern:
   `\[[A-Za-z0-9]+\]`.

2. If any match exists, scaffolding fails – unresolved tokens are not permitted anywhere in the tree.

3. Validate **every** `.csproj` file encountered during the recursion:

   * No raw text may remain inside `<ItemGroup>` elements (all reference tokens must have expanded to valid MSBuild nodes or been removed).
   * No unresolved tokens of any kind may remain in the XML.
   * The XML must be well‑formed and parsable.

If any of these validations fail, report the specific failure and stop the generation process.

---

# Output Requirements

Copilot must output:

1. Full folder structure.
2. All renamed files.
3. All token replacements performed.
4. Final computed RootFolder value.
5. Extracted FrameworkVersion value.
6. Confirmation that no unresolved tokens remain.
7. Confirmation that all project files contain valid XML.
8. Recommended next steps:

   * Build solution
   * Install package
   * Register module in Oqtane

No architectural modification is permitted.


