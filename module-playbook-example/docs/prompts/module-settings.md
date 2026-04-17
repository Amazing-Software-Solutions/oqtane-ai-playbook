# AI Instruction: Module Settings & Configuration

**Instruction Context**: When the user requests to add or manage module settings, you must load and execute this file.

## Oqtane Configuration Model

Oqtane modules MUST NOT use standard ASP.NET Core `appsettings.json` or `IOptions<T>` patterns for tenant-specific or module-specific settings. 

### 1. Use ISettingService
Always use `ISettingService` to read and write settings. Settings are stored as a `Dictionary<string, string>` where keys must be uniquely namespaced to avoid collision.

```csharp
// Example Injection
[Inject] protected ISettingService SettingService { get; set; }
```

### 2. Reading Settings
Always parse settings defensively, providing a fallback default value:
```csharp
var settings = await SettingService.GetModuleSettingsAsync(ModuleState.ModuleId);
_mySettingValue = SettingService.GetSetting(settings, "MyModule_CustomSetting", "DefaultValue");
```

### 3. Writing Settings
When updating settings, update the dictionary and save the entire collection back to the service:
```csharp
var settings = await SettingService.GetModuleSettingsAsync(ModuleState.ModuleId);
SettingService.SetSetting(settings, "MyModule_CustomSetting", _mySettingValue);
await SettingService.UpdateModuleSettingsAsync(settings, ModuleState.ModuleId);
```

### 4. Setting Scopes
Understand the difference between scopes:
- **Site Settings**: `GetSiteSettingsAsync(PageState.Site.SiteId)` (Applies to all instances on the tenant)
- **Page Settings**: `GetPageSettingsAsync(PageState.Page.PageId)` (Applies to the specific page)
- **Module Settings**: `GetModuleSettingsAsync(ModuleState.ModuleId)` (Applies to this specific instance of the module on a page)

Do not abstract this logic into custom configuration classes unless explicitly requested by the user.
