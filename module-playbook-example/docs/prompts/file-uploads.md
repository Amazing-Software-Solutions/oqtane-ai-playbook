# AI Instruction: File Uploads & Media Management

**Instruction Context**: When the user requests to handle file uploads or manage media, you must load and execute this file.

## Oqtane File Management Rules

Standard ASP.NET Core `IFormFile` saving to `wwwroot` is strictly prohibited in Oqtane. You MUST use Oqtane's integrated file management system to ensure tenant isolation, storage quotas, and security.

### 1. Use Core Services
You MUST inject and utilize `IFileService` and `IFolderService` for any media interactions.
```csharp
[Inject] protected IFileService FileService { get; set; }
[Inject] protected IFolderService FolderService { get; set; }
```

### 2. Folder Resolution
Before saving a file, you must resolve or create the appropriate destination folder using `FolderService`. Files belong to Folders, which belong to Sites (Tenants).
```csharp
var folder = await FolderService.GetFolderAsync(PageState.Site.SiteId, "MyModule/Uploads");
```

### 3. Uploading Files
In Blazor components, use the built-in `FileManager` component if possible. If manually processing bytes (e.g., via `InputFile` or API), you must pass the file data to `FileService.UploadFileAsync()`.
- Never write `System.IO.File.WriteAllBytes` directly to `wwwroot`.
- Do not bypass the `IFileService` abstraction.

### 4. File Output
When rendering images or creating links to files, use the `FileUrl()` helper or construct the path using Oqtane's standardized `/api/file/download/X` routing, ensuring permissions are enforced.
