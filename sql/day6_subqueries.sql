-- 19. Core Query 1 — Earliest deadline row
-- Return the task row or rows whose `due_date` equals the earliest non-null task deadline across the system.
-- Requirements:
-- - Use a scalar subquery
-- - Use `MIN(due_date)` inside the subquery
-- - Return useful task columns
-- - Sort by task ID if multiple rows share the same earliest deadline
-- Before writing SQL, answer:
-- What is the inner question? -- It is to find what is the min(due_date)
-- What single value does the inner query return? -- MIN(due_date) is the single value
-- What does the outer query compare against that value? -- due_date which is equal to the min(due_date)
SELECT * FROM tasks WHERE due_date = (SELECT MIN(due_date) FROM tasks) ORDER BY task_id;

-- 20. Core Query 2 — Latest task deadline row
-- Return the task row or rows whose `due_date` equals the latest non-null task deadline across the system.
-- Requirements:
-- - Use a scalar subquery
-- - Use `MAX(due_date)`
-- - Return useful task columns
-- - Sort by task ID
-- This is intentionally similar to Query 1.
-- The goal is to reinforce the pattern.
SELECT * FROM tasks WHERE due_date = (SELECT MAX(due_date) FROM tasks) ORDER BY task_id;

-- 21. Core Query 3 — Tenant 1 users using `IN`
-- Return user rows for users who belong to tenant 1.
-- Requirements:
-- - Outer query starts from `users`
-- - Use `IN (subquery)`
-- - Inner query reads from `memberships`
-- - Inner query returns user IDs for tenant 1
-- - Sort by user ID
-- Do **not** use a join in this exercise.
-- Before writing:
-- What values must the inner query produce? -- It should produce the user_ids that belong to tenant 1
-- What outer column must be checked against those values? -- The inner query values should be compared with the user_ids of the users table.
SELECT * FROM users WHERE user_id IN (SELECT user_id FROM memberships WHERE tenant_id = 1) ORDER BY user_id ASC;

-- 22. Core Query 4 — Users belonging to any tenant
-- Return user rows for users who have at least one membership row.
-- Requirements:
-- - Outer query starts from `users`
-- - Use `IN (subquery)`
-- - Inner query reads from `memberships`
-- - Think about duplicate membership user IDs
-- You may use an earlier concept if needed, but first ask:
-- > Does duplicate membership data change the correctness of `IN` membership testing? -- I am not sure. Even though the inner query returned 7 rows, the outer query did not repeat.  
-- Do not add `DISTINCT` automatically.
-- Reason first.
SELECT * FROM users AS u WHERE user_id IN (SELECT user_id FROM memberships AS m) ORDER BY user_id ASC;

-- 23. Core Query 5 — Projects that have at least one task
-- Return projects that have at least one matching task.
-- Requirements:
-- - Outer query starts from `projects`
-- - Use `EXISTS`
-- - Inner query reads from `tasks`
-- - Correlate task project ID with the current project row
-- - Sort by project ID
-- Before writing:
-- For one project row, what must exist? -- the project_id in the projects should match with the project_id in tasks
SELECT * FROM projects AS p WHERE EXISTS (SELECT 1 FROM tasks AS tsk WHERE tsk.project_id = p.project_id) ORDER BY p.project_id ASC;

-- 24. Core Query 6 — Projects with no tasks
-- Return projects that do not have any matching task rows.
-- Requirements:
-- - Outer query starts from `projects`
-- - Use `NOT EXISTS`
-- - Inner query reads from `tasks`
-- - Correlate by project ID
-- - Sort by project ID
-- Do not use `LEFT JOIN` for this exercise.
-- The goal is specifically to learn `NOT EXISTS`.
SELECT * FROM projects AS p WHERE NOT EXISTS (SELECT 1 FROM tasks AS tsk WHERE tsk.project_id = p.project_id) ORDER BY p.project_id ASC;

-- 25. Core Query 7 — Users with at least one active membership
-- Return users who have at least one active membership row.
-- Requirements:
-- - Outer query starts from `users`
-- - Use `EXISTS`
-- - Inner query reads from `memberships`
-- - Correlate by user ID
-- - Filter active membership rows inside the existence test
-- - Sort by user ID
-- Before writing, distinguish:
-- Correlation condition:
-- Inner membership-status condition:
SELECT * FROM users AS u WHERE EXISTS (SELECT user_id FROM memberships AS m WHERE m.user_id = u.user_id AND m.membership_status = 'active') ORDER BY u.user_id;

-- 26. Core Query 8 — Tenant 1 users with an active membership
-- Return users who have an active membership in tenant 1.
-- Requirements:
-- - Outer query starts from `users`
-- - Use `EXISTS`
-- - Inner query reads from `memberships`
-- - Correlate membership user ID with the outer user
-- - Restrict the inner membership rows to tenant 1
-- - Restrict the inner membership rows to active
-- - Sort by user ID
-- This should feel like a more specific version of Query 7.
SELECT * FROM users AS u WHERE EXISTS(SELECT m.user_id FROM memberships AS m WHERE u.user_id = m.user_id AND m.membership_status = 'active' AND m.tenant_id = 1) ORDER BY u.user_id;

-- 27. Core Query 9 — Tenants with at least one active project
-- Return tenants that have at least one active project.
-- Requirements:
-- - Outer query starts from `tenants`
-- - Use `EXISTS`
-- - Inner query reads from `projects`
-- - Correlate by tenant ID
-- - Filter active projects inside the subquery
-- - Sort by tenant ID
-- Before writing:
-- What does one outer row represent? -- tenant information
-- What must exist for that tenant? -- project should be actove
SELECT * FROM tenants AS t WHERE EXISTS (SELECT p.tenant_id FROM projects AS p WHERE p.tenant_id = t.tenant_id AND p.project_status = 'active') ORDER BY t.tenant_id ASC;

-- 28. Core Query 10 — Tenants with no active projects
-- Return tenants that have no active projects.
-- Requirements:
-- - Outer query starts from `tenants`
-- - Use `NOT EXISTS`
-- - Inner query reads from `projects`
-- - Correlate by tenant ID
-- - Define “active project” inside the subquery
-- - Sort by tenant ID
-- Be careful:
-- The requirement is not:
-- tenant with no projects
-- It is:
-- tenant with no active projects
-- A tenant could still have archived or completed projects and satisfy the requirement.
SELECT * FROM tenants AS t WHERE NOT EXISTS (SELECT p.tenant_id FROM projects AS p WHERE p.tenant_id = t.tenant_id AND p.project_status = 'active') ORDER BY t.tenant_id ASC;