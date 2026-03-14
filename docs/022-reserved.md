# 022 - Reserved: Module Settings and Site Configuration

> **Status: Planned**
>
> This chapter is **reserved** for future content on module settings and site configuration patterns.

---

## Intended Coverage

When written, this chapter will cover:

- The Oqtane `ISetting` pattern and how modules expose configurable settings
- How settings are stored, retrieved, and invalidated per tenant
- The difference between module settings, site settings, and user settings
- How AI tools commonly mishandle configuration (inventing custom config systems,
  using `appsettings.json` incorrectly, or constructing settings outside the framework model)
- Governance rules for settings that affect behavior vs. settings that affect presentation

---

## Why This Gap Exists

The settings system is a frequently-used extension point in Oqtane modules, and one where
AI tools readily default to `IConfiguration` or `appsettings.json` patterns that
are unavailable or incorrect inside module code.

Until this chapter is written, refer to:

- Oqtane framework source for `ISetting`, `SettingRepository`, and `SettingService`
- The canonical module example for the approved consumption pattern

---

> **Do not use this file number** for any other topic.
> When this chapter is written, replace this placeholder entirely.
