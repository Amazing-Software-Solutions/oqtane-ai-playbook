# 027x Site Tasks

## Purpose

This rule governs the use of Site Tasks introduced in Oqtane 10.1.

Site Tasks are the correct mechanism for ad hoc, user initiated, asynchronous workloads that must not block the UI thread.

This rule prevents misuse of Scheduled Jobs for non recurring work and enforces alignment with framework capabilities.

* * *

# 1. Version Gate (Runtime Aware Governance)

Site Tasks are available only in Oqtane 10.1 or greater.

Before generating any implementation:

AI must verify the framework version by either:

• Inspecting `Oqtane.Shared.Shared.Constants.Version`
or
• Inspecting the database version metadata

If Version &lt; 10.1.0:

• Do not generate ISiteTask implementations
• Fall back to Scheduled Job guidance
• Explicitly inform the user that Site Tasks require Oqtane 10.1+

If Version &gt;= 10.1.0:

• Site Tasks are permitted
• Scheduled Job polling patterns must be rejected when Site Tasks are more appropriate

This is mandatory.

* * *

# 2. When to Use Site Tasks

Use Site Tasks when:

• Work is triggered by a user action
• The task must execute asynchronously
• The UI must not block
• The task is not recurring
• No polling is required

Examples:

• Export generation initiated by a user
• Large file processing
• Data synchronization triggered from UI
• Report building

* * *

# 3. When NOT to Use Site Tasks

Do not use Site Tasks when:

• The task is recurring
• It is time based
• It must execute independently of user interaction
• It represents maintenance or housekeeping

In these cases, use Scheduled Jobs.

* * *

# 4. Architectural Decision Enforcement

If a user asks for:

“Create a background job”
“Create async processing”
“Create long running task”

AI must:

1. Determine whether the workload is recurring or user triggered
2. Check Oqtane version
3. Suggest Site Task if more appropriate

If Site Task is better:

AI must explicitly state:

“This is an ad hoc workload. In Oqtane 10.1+ the correct architectural pattern is ISiteTask rather than a Scheduled Job.”

Silent substitution is not allowed.
Justification is required.

* * *

# 5. Anti Patterns (Reject)

Reject implementations that:

• Create Scheduled Jobs to poll for user initiated work
• Implement custom background queues
• Use while loops or timers to simulate task processing
• Bypass the Site Task API in Oqtane 10.1+

Framework infrastructure must not be reimplemented.

* * *

# 6. Execution Model

Site Tasks:

• Are registered via the SiteTask API
• Execute asynchronously in the background
• Are processed centrally by Oqtane
• Must not block UI rendering

Modules must not:

• Spawn unmanaged threads
• Use Task.Run without integration
• Create unmanaged background services

All execution must align with framework lifecycle.

* * *

# 7. Governance Summary

Recurring workload → Scheduled Job
User triggered async workload → Site Task

Framework capability determines architecture.

This rule enforces runtime aware governance.

AI must align module architecture with the actual framework version, not assumptions.

* * *

