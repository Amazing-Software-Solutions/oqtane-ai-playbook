# 033 - Concurrency Control (The ModifiedOn Pattern)

In a multi-user environment, a common challenge is the "Lost Update" anomaly: User A and User B open the same record at the same time. User A saves their changes. User B saves their changes shortly after, silently overwriting User A's work.

To prevent this, we need **Concurrency Control**. 

While the ultimate solution in Entity Framework Core is a dedicated `byte[] RowVersion` column with the `[Timestamp]` attribute, introducing this requires schema changes and migration complexity that might be overkill for simple modules.

This chapter introduces a pragmatic, "good enough" pattern using Oqtane's built-in auditing fields: **The `ModifiedOn` Concurrency Pattern**.

---

## Why Use `ModifiedOn`?

Almost all Oqtane models implement `IAuditable` or manually track `ModifiedOn` (`DateTime`).

- **No Schema Changes:** You don't need to add a new `RowVersion` column to your database tables.
- **Readable:** It uses existing data that is easy to log and display to the user.
- **Easy Upgrade Path:** If the module eventually requires strict, sub-millisecond concurrency control, you can simply replace the `ModifiedOn` check with a newly added `RowVersion` field. The architectural pattern remains identical.
- **Not Infallible, But Decent:** While `DateTime` precision means two updates occurring in the exact same tick could theoretically bypass the check, it is more than sufficient for standard human-speed UI interactions.

---

## The Pattern

### 1. The Server-Side Check (Repository or Service)

When updating a record, the server must compare the `ModifiedOn` timestamp provided by the client with the current `ModifiedOn` timestamp in the database.

If they differ, it means another user has modified the record since the client loaded it.

```csharp
public Item UpdateItem(Item item)
{
    using var db = _dbContextFactory.CreateDbContext();
    
    // Retrieve the CURRENT state of the record from the database
    // Use AsNoTracking to avoid colliding with the item we want to update
    var currentRecord = db.Item.AsNoTracking().FirstOrDefault(i => i.ItemId == item.ItemId);
    
    if (currentRecord != null)
    {
        // 🚨 CONCURRENCY CHECK
        // If the client's timestamp doesn't match the database timestamp, reject the update.
        // Be sure to handle potential precision losses depending on your database provider by allowing a small variance, 
        // or by ensuring the client returns the EXACT value it received.
        if (currentRecord.ModifiedOn != item.ModifiedOn)
        {
            // Throw a specific exception or return null/error indicator
            throw new InvalidOperationException("Concurrency conflict: The record has been modified by another user.");
        }
    }

    db.Entry(item).State = EntityState.Modified;
    
    // Update the timestamp to the current time for the next operation
    item.ModifiedOn = DateTime.UtcNow; 
    
    db.SaveChanges();
    return item;
}
```

*Note: Depending on your database provider (e.g., SQL Server vs. SQLite), `DateTime` precision can sometimes be truncated when saved. Ensure that the API serialization and the database mapping preserve enough precision for accurate equality checks, or use a string-formatted strict comparison.*

### 2. The Client-Side Handling (Blazor)

The Blazor UI must retain the original `ModifiedOn` value when it loads the record, pass it unmodified to the server during the update, and cleanly handle the concurrency error if it occurs.

```html
@if (!string.IsNullOrEmpty(ErrorMessage))
{
    <div class="alert alert-warning">@ErrorMessage</div>
}
```

```csharp
private Item _item;
private string ErrorMessage;

protected override async Task OnParametersSetAsync()
{
    // Load the item - the ModifiedOn timestamp is loaded here
    _item = await ItemService.GetItemAsync(ItemId);
}

private async Task SaveItem()
{
    try
    {
        // _item.ModifiedOn is passed back exactly as it was received
        await ItemService.UpdateItemAsync(_item);
        NavigationManager.NavigateTo("...");
    }
    catch (Exception ex)
    {
        // Handle the concurrency error gracefully in the UI
        ErrorMessage = "This record was updated by another user while you were editing it. Please refresh and try again.";
    }
}
```

---

## Upgrading to `RowVersion`

If your data requirements become extremely strict, the upgrade path is frictionless:

1. **Add `RowVersion`**: Add a `byte[] RowVersion` property to your Oqtane model.
2. **Migration**: Create a migration to add this column to the table (`rowversion` in SQL Server).
3. **Change the Check**: Replace `currentRecord.ModifiedOn != item.ModifiedOn` with `currentRecord.RowVersion != item.RowVersion` (using `SequenceEqual`).
4. **Entity Framework**: Alternatively, annotate the property with `[Timestamp]` and let EF Core throw a `DbUpdateConcurrencyException` automatically.

The UI logic and error handling remain functionally identical. By implementing the `ModifiedOn` check early, you establish the necessary user-experience workflows for concurrent edits without over-engineering your initial database schema.
