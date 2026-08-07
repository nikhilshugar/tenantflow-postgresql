-- Show the next three dated tasks for tenant 1. Earliest deadline first; exclude tasks without a due date.
SELECT * FROM tasks WHERE tenant_id = 1 AND due_date IS NOT NULL ORDER BY due_date NULLS LAST LIMIT 3;

-- Show every tenant 2 task from most recently created to oldest.
SELECT * FROM tasks WHERE tenant_id = 2 ORDER BY created_at DESC, task_id DESC;

-- Show all projects from most recently created to oldest. Resolve equal timestamps predictably.
SELECT * FROM projects ORDER BY created_at DESC, project_id ASC;

-- Show all users with the most recent login first. Users who never logged in must appear last.
SELECT * FROM users ORDER BY last_login_at DESC NULLS LAST, user_id ASC;

-- Show tenants from newest to oldest. Resolve equal timestamps using the tenant ID.
SELECT * FROM tenants ORDER BY created_at DESC, tenant_id ASC;

-- Show tenant 1 tasks alphabetically by priority, then by earliest due date, with missing due dates last.
SELECT * FROM tasks WHERE tenant_id = 1 ORDER BY priority ASC, due_date ASC NULLS LAST;

-- Show all tasks with assigned tasks first and unassigned tasks last. Within each assignee, show the earliest dated task first and missing due dates last.
SELECT * FROM tasks ORDER BY assigned_user_id NULLS LAST, due_date ASC NULLS LAST, task_id ASC;

-- Display page 2 of tenant 2's tasks using a page size of 3. Order by due date ascending, missing dates last, then task ID ascending.
SELECT * FROM tasks WHERE tenant_id = 2 ORDER BY due_date ASC NULLS LAST, task_id ASC LIMIT 3 OFFSET 3;

-- Arrange projects by tenant and place the newest project first within each tenant. Return every project, not only one per tenant.
SELECT * FROM projects ORDER BY tenant_id ASC, created_at DESC, project_id ASC;

-- Display non-archived projects first and archived projects last. Within each group, show newer projects first.
SELECT * FROM projects ORDER BY (project_status='archived') ASC, created_at DESC, project_id DESC;