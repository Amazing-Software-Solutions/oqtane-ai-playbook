# 027x — Packaging and External Dependencies

## Description

This rule governs the use of **external NuGet packages** in Oqtane modules and
defines the mandatory steps required to ensure **runtime correctness** and
**module packaging integrity**.

Oqtane does **not** automatically resolve module package dependencies at runtime.
Failure to handle deployment and packaging explicitly will result in runtime
errors that are difficult to diagnose and undermine trust in AI-generated code.

---

## Rule Statement

When generating or modifying an Oqtane module, the AI **MUST NOT** add an external
NuGet package unless **all required runtime and packaging steps** are handled
explicitly.

Adding a package is considered **incomplete and non-compliant** unless the
deployment and module packaging implications are addressed.

When adding a package the AI **MUST** use the last version of the package available on NuGet.org, unless a specific version is required for compatibility reasons.
The AI **MUST** explain why a specific version is necessary if it does not use the latest version.

---

## Mandatory Requirements

If an external NuGet package is introduced, the AI **MUST**:

### 1 Static Web Assets Handling Rule

#### Purpose

Modules must be self-contained deployable units.

If a dependency introduces static web assets, those assets must be surfaced inside the module’s own Server project.

The AI must never modify Oqtane framework source or internal areas to achieve this.

---

#### Canonical Path Rule

Static web assets must be placed in:

`.<ModuleName>\Server\wwwroot\_content\<PackageName>\`

The folder structure must exactly match the dependency’s staticwebassets manifest.

The _content convention must be preserved exactly.

##### Example

For MudBlazor:

`.\AcMe.Module.AcMeModule\Server\wwwroot\_content\MudBlazor\`

For Fluent UI Blazor:

`.\AcMe.Module.AcMeModule\Server\wwwroot\_content\Microsoft.FluentUI.AspNetCore.Components\`

The package name must match the manifest base path.

---

### Why This Works

When the module is installed:

* Oqtane extracts the module package
* Static assets inside the module Server wwwroot are deployed
* ASP.NET resolves them via:

`/_content/<PackageName>/...`

Because the module mirrors the _content structure exactly, resolution succeeds without touching the host.

#### Governance Requirements

When a package includes static web assets, AI must:

1. Inspect the Client and Server:
   obj\project.assets.json

2. Detect if the package contains staticwebassets.

3. Identify the asset base path (typically `_content/<PackageName>`).

4. Unpack or copy static assets into:

   .<ModuleName>\wwwroot\_content\<PackageName>\

5. Include those assets in the nuspec `<files>` section.

6. Verify that after module installation:

   * CSS loads
   * JS loads
   * No 404 errors occur for `_content/...` paths

---

#### Governance Boundary (Non-Negotiable)

AI MUST NOT:

* Modify Oqtane.Server
* Modify Oqtane.Client
* Inject assets into framework projects
* Assume host-level registration
* Alter framework startup configuration

All UI framework integration must be module-contained.
---

#### Why This Matters

ASP.NET resolves static assets using:

`/_content/<PackageName>/file.js`

If the `_content` structure is not preserved:

* Assets will not resolve
* Components will fail silently
* Styles will not load
* JS interop may break

This is not optional. It is structural.

---

#### Enforcement Clause

If AI adds a dependency that includes static assets and does not:

* Mirror the `_content/<PackageName>` path
* Include files in nuspec
* Validate presence in wwwroot

Then packaging is considered incomplete.

---

#### Mandatory AI Detection Process

When adding a NuGet package:

1. Inspect:  
   Client\obj\project.assets.json  
   Server\obj\project.assets.json  

2. Detect staticwebassets entries.
3. Identify the base path _content/<PackageName>.
4. Mirror that structure inside:
```
  .<ModuleName>\Server\wwwroot\_content<PackageName>\
```
5. Ensure files are included in the nuspec for packaging.
6. Validate no runtime 404 errors for _content/....

If this chain is incomplete, the module is non-compliant with 027 governance.

---


### 2. Runtime Deployment

Ensure the package assemblies are copied to the Oqtane Server runtime bin.
Only copying the package to the project and relying on NuGet restore is insufficient, as Oqtane does not automatically resolve these dependencies at runtime.
Copy the assemblies only from the comsuming project.

This typically requires:

- Updating `debug.cmd` (or equivalent build/deploy script)
- Copying the required DLLs into:
`Oqtane.Server\bin\Debug<target-framework>\`


If this step is omitted, the module **will compile but fail at runtime**.


---

### 3. Module Packaging (.nuspec)

Update the module `.nuspec` file to include the dependency so that:

- The package is included when the module is packaged
- The dependency is available in deployed environments

Failure to update the `.nuspec` will result in:
- Broken packaged modules
- Missing dependencies after deployment

---

### 4. Project File Update (.csproj)

- Ensure the project file `.csproj` includes the appropriate `<PackageReference>` entry for the new package.		
- The PropertyGroup contains the CopyLocalLockFileAssemblies set to true,
ensuring that all referenced assemblies are copied to the output directory during build time.

---

### 5. Explicit Explanation

The AI must clearly explain:

- Why the external package is required
- Why existing Oqtane or .NET functionality is insufficient
- What runtime and packaging changes were made

---

## Preferred Behavior

Before adding any external package, the AI **SHOULD**:

- Check whether Oqtane already provides equivalent functionality
- Prefer built-in Oqtane services, utilities, or patterns
- Minimize external dependencies where possible

---

## Prohibited Behavior

The AI **MUST NOT**:

- Add a NuGet package without addressing runtime deployment
- Assume NuGet restore makes assemblies available at runtime
- Add packages “silently” without explanation
- Modify project files only and omit deployment steps
- Defer packaging updates to the developer without explicit warning

---

## Refusal Conditions

The AI **MUST REFUSE** to proceed if:

- It is unclear how the package should be deployed at runtime
- The required deployment or packaging mechanism is unknown
- The package introduces unclear or unsupported runtime behavior

### Required Refusal Message (Template)

> I cannot add this package safely because Oqtane does not automatically resolve
> module dependencies at runtime.  
> Adding this package would require explicit runtime deployment and `.nuspec`
> updates, and the correct approach is unclear.  
> Please confirm the intended deployment strategy or approve a manual setup.

---

## Oqtane Dependency Management

### ModuleInfo.cs Dependencies
Oqtane requires explicit DLL dependencies in `ModuleInfo.cs` for proper assembly loading and housekeeping:

### Key Principles
1. **No File Extensions**: Dependencies list assembly names without `.dll` extensions
2. **Complete Chain**: Include all transitive dependencies that aren't part of .NET runtime
3. **Comma Separated**: Use comma-separated format for multiple dependencies
4. **No Space Padding**: The name list should not have spaces around commas
5. **Core Module First**: Always list the main module dependency first

### Dependency Updates
When updating third-party dependencies:
1. Update project references
2. Update nuspec dependency versions
2. The dependency files must be copied to the Oqtane Server bin in the files section of the nuspec
3. Update `ModuleInfo.cs` Dependencies string
4. Test package generation and deployment
5. Update provider documentation

---

## Rationale

Oqtane modules operate in a **hosted runtime** where:

- NuGet restore affects build-time only
- Runtime assemblies must be present in the server bin
- Module packaging is explicit and manual

Generic .NET assumptions do not apply.

This rule prevents:
- Runtime `FileNotFoundException` and `TypeLoadException`
- Silent partial success
- Misattribution of errors to Oqtane or AI tooling

---

## Compliance Checklist

A module change involving external packages is compliant only if:

- [ ] Runtime assemblies are copied to the Oqtane Server bin
- [ ] The module `.nuspec` is updated
- [ ] The dependency choice is explained
- [ ] No assumptions are made about automatic resolution

If any item fails, the output is **non-compliant**.

---

## Summary

External dependencies in Oqtane modules are **not free**.

They require:
- Explicit runtime deployment
- Explicit packaging updates
- Explicit explanation

AI output that ignores these realities must be rejected.
