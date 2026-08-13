-- Across the system, return membership rows together with the corresponding user's information. For this first join only, SELECT * is allowed.
SELECT * FROM memberships AS m
INNER JOIN users AS u ON m.user_id = u.user_id;

-- Rewrite the membership/user join using aliases. Return tenant_id, the membership's user_id, user email, membership role, and membership status. 
-- Sort by tenant ID, then user ID.
SELECT m.tenant_id, m.user_id, u.email, m.role, m.membership_status
FROM memberships AS m
INNER JOIN users AS u
ON m.user_id = u.user_id
ORDER BY m.tenant_id ASC, m.user_id ASC;

-- Across the system, return each project with useful tenant information. 
-- Include the project ID, tenant ID, and tenant slug plus one useful project-status column. 
-- Sort by project ID.
SELECT p.project_id, t.tenant_id, t.tenant_slug, p.project_status
FROM projects as p
LEFT JOIN tenants as t
ON p.tenant_id = t.tenant_id
ORDER BY p.project_id ASC;

-- Return tenant 1 membership rows with corresponding user information.
-- Include tenant ID, user ID, user email, membership role, and membership status. Sort by user ID.
SELECT m.tenant_id, m.user_id, u.email, m.role, m.membership_status
FROM memberships AS m
INNER JOIN users AS u
ON m.user_id = u.user_id
WHERE m.tenant_id = 1
ORDER BY m.user_id;

-- Return only active membership rows for tenant 1 together with corresponding user information.
SELECT m.user_id, m.role, m.membership_status, u.email, u.first_name, u.last_name
FROM memberships AS m
INNER JOIN users AS u
ON m.user_id = u.user_id
WHERE m.membership_status = 'active' AND m.tenant_id = 1
ORDER BY m.user_id;

-- Using INNER JOIN, return task rows that have a matching assigned user. Include task ID, assigned-user ID, and user email. Sort by task ID.
SELECT tsk.task_id, tsk.assigned_user_id, u.email 
FROM tasks AS tsk
INNER JOIN users AS u
ON tsk.assigned_user_id = u.user_id
ORDER BY tsk.task_id ASC;

-- Return every task together with assigned-user information when available. 
-- Unassigned tasks must remain. Include task ID, assigned-user ID, and user email. Sort by task ID.
SELECT tsk.task_id, tsk.assigned_user_id, u.email
FROM tasks AS tsk
LEFT JOIN users AS u
ON tsk.assigned_user_id = u.user_id
ORDER BY tsk.task_id ASC;

-- Return tenant, membership, and user information in one result. 
-- Include tenant ID, tenant slug, user ID, user email, role, and membership status. 
-- Sort by tenant ID, then user ID.
SELECT t.tenant_id, t.tenant_slug, u.user_id, u.email, m.role, m.membership_status
FROM tenants AS t
INNER JOIN memberships AS m
ON t.tenant_id = m.tenant_id
INNER JOIN users AS u
ON m.user_id = u.user_id
ORDER BY t.tenant_id ASC, u.user_id ASC;

-- Return each task together with useful information about its project. 
-- Include task ID, task tenant ID, project ID, and one project-status column. 
-- Sort by task ID.
SELECT tsk.task_id, tsk.tenant_id, tsk.project_id, p.project_status
FROM tasks AS tsk
INNER JOIN projects AS p
ON tsk.project_id = p.project_id
ORDER BY tsk.task_id ASC;

-- Return tenant 1's tasks together with project information and assigned-user email when available. 
-- Every tenant 1 task must remain, including an unassigned task. 
-- Sort by due date ascending with null deadlines last, then task ID ascending.
SELECT tsk.tenant_id, tsk.task_id, tsk.project_id, p.project_name, u.email
FROM tasks AS tsk
LEFT JOIN projects AS p
ON tsk.project_id = p.project_id
LEFT JOIN users AS u
ON tsk.assigned_user_id = u.user_id
WHERE tsk.tenant_id = 1
ORDER BY tsk.due_date ASC NULLS LAST, tsk.task_id ASC;