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

---

## Mandatory Requirements

If an external NuGet package is introduced, the AI **MUST**:

### 1. Runtime Deployment

Ensure the package assemblies are copied to the Oqtane Server runtime bin.

This typically requires:

- Updating `debug.cmd` (or equivalent build/deploy script)
- Copying the required DLLs into:
Oqtane.Server\bin\Debug<target-framework>\


If this step is omitted, the module **will compile but fail at runtime**.


---

### 2. Module Packaging (.nuspec)

Update the module `.nuspec` file to include the dependency so that:

- The package is included when the module is packaged
- The dependency is available in deployed environments

Failure to update the `.nuspec` will result in:
- Broken packaged modules
- Missing dependencies after deployment

---

### 3. Project File Update (.csproj)

- Ensure the project file `.csproj` includes the appropriate <PackageReference>` entry for the new package.		
- The PropertyGroup contains the CopyLocalLockFileAssemblies set to true, 
ensuring that all referenced assemblies are copied to the output directory during build time.

---

### 4. Explicit Explanation

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
5. **Core Module First**: Always list the main Doquetain module dependency first

### Dependency Updates
When updating third-party dependencies:
1. Update project references
2. Update nuspec dependency versions
2. The dependency files must be copied to the Oqtane Server bin in the files section of the nuspec
3. Update ModuleInfo.cs Dependencies string
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