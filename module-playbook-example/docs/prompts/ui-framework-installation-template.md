# Canonical Prompt: Self Contained UI Framework Installation

You are operating under the Oqtane AI Playbook governance.

Framework to install: `<UI_FRAMEWORK_NAME>`

Context:

* This is an Oqtane module.
* You are NOT allowed to modify any Oqtane framework project.
* You must NOT modify Oqtane.Server, Oqtane.Client, or any host project.
* The module must be fully self contained.
* Follow:
    - 027x-runtime-awareness
    - 027x-packaging-and-dependencies
    - 027x-ui-governance-architecture
    - 027x-ui-validation
    - The framework specific 027x-ui rule if it exists

Objective:

Install and configure `<UI_FRAMEWORK_NAME>` so the module works independently when packaged and installed into a clean Oqtane site.

Hard Requirements:

1. No framework modification.
2. All static web assets must live inside the module.
3. No runtime 404 errors for `_content/<UI_FRAMEWORK_NAME>/...`
4. No assumptions about host level registration.
5. Module must remain portable and package safe.

---

## Execution Steps (Mandatory)

### Step 1 – Add Package

1. Add the correct NuGet package to the appropriate module project.
2. Do not add to Oqtane projects.

---

### Step 2 – Runtime Asset Inspection

Inspect:

Client\obj\project.assets.json
Server\obj\project.assets.json

Detect whether the package exposes static web assets.

If static web assets exist, determine their canonical `_content` path.

---

### Step 3 – Static Web Assets Extraction Rule

If the package contains static web assets:

Extract them from the NuGet cache into:

.<ModuleName>\Server\wwwroot_content<UI_FRAMEWORK_NAME>\

Rules:

* Preserve exact folder structure
* Match staticwebassets manifest
* Do not invent custom folder names
* Do not place in Oqtane.Server
* Do not flatten directories

The `_content` convention must remain intact.

---

### Step 4 – Service Registration

If the framework requires DI registration:

Register services inside the module startup only.

Do not register services in Oqtane.Server or host.

If the framework is client side only, register appropriately within module boundaries.

---

### Step 5 – CSS and Script Resolution

Ensure CSS and JS references resolve using:

/_content/<UI_FRAMEWORK_NAME>/...

Do not reference local module relative paths.
Do not use custom static routes.

---

### Step 6 – Packaging Compliance

Update the module nuspec so that:

* All unpacked static assets are included
* No external runtime dependency is required
* Module installs cleanly on a fresh Oqtane site

---

### Step 7 – Runtime and Packaging Compliance (Mandatory)

Per 027x-packaging-and-dependencies.md:

1. Update debug.cmd to copy DLL
2. Update .nuspec to include DLL
3. Update ModuleInfo.cs Dependencies
4. Verify CopyLocalLockFileAssemblies=true

### Step 8 – Verification Checklist (Mandatory Output)

Provide verification output confirming:

* No Oqtane framework project modified
* Static assets present in module Server wwwroot
* _content path correct
* No duplicate service registrations
* Module builds
* No 404 errors at runtime
* Packaging includes static files

---

## Abort Conditions

If you attempt to:

* Modify Oqtane.Server
* Modify Oqtane.Client
* Require host configuration
* Assume host level CSS or JS injection

You must stop and explain why it violates governance.

---