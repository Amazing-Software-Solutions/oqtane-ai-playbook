# AI Instruction: Search Indexing Integration

**Instruction Context**: When the user requests to make the module searchable or implement ISearchable, you must load and execute this file.

## Implementing ISearchable

To integrate an Oqtane module with the core search engine, the module's manager class must implement the `ISearchable` interface.

### 1. Interface Implementation
Your manager class (e.g., `MyModuleManager`) must implement `ISearchable` and provide the `HasSearchIndex()` method.
```csharp
public bool HasSearchIndex() => true;
```

### 2. SearchDocument Mapping
You must implement `GetSearchDocumentsAsync()`. This method retrieves the module's domain entities and maps them to `SearchDocument` objects.
```csharp
public async Task<List<SearchDocument>> GetSearchDocumentsAsync(int siteId, string entityName, string aliasName, string indexName)
```

### 3. Required Fields
When mapping your entities to a `SearchDocument`, ensure the following are correctly populated:
- `SiteId`, `PageId`, `ModuleId` (Required for routing search results)
- `EntityName` (The name of your domain model)
- `EntityId` (The primary key of the record)
- `Title` (A concise, human-readable title for the result)
- `Description` (The searchable body content)
- `Url` (The route to view the item, use `NavigateUrl()` patterns if applicable)
- `Permissions` (A delimited string of Role IDs that can view this document, usually derived from the module's view permissions)

### 4. Performance Considerations
- Do NOT perform N+1 queries inside `GetSearchDocumentsAsync`.
- Retrieve all necessary records in bulk.
- Avoid large object allocations where possible, as this method is called by a background job for indexing.
