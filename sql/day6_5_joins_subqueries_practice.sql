-- A1
-- Return all memberships with tenant ID, user ID, user email, role, and membership status.
SELECT m.tenant_id, m.user_id, u.email, m.role, m.membership_status FROM memberships AS m 
LEFT JOIN users AS u
ON m.user_id = u.user_id
ORDER BY m.user_id ASC;
-- A2
-- Return every task with task ID, assigned-user ID, and assigned-user email. Unassigned tasks must remain.
SELECT tsk.task_id, tsk.assigned_user_id, u.email FROM tasks AS tsk
LEFT JOIN users AS u
ON tsk.assigned_user_id = u.user_id
ORDER BY tsk.task_id ASC;
-- A3
-- Return only tasks that have a valid assigned user, together with user email.
SELECT * FROM tasks AS tsk
INNER JOIN users AS u
ON tsk.assigned_user_id = u.user_id
ORDER BY tsk.task_id ASC;
-- A4
-- Return every project with task information when available. Zero-task projects must remain.
SELECT * FROM projects AS p
LEFT JOIN tasks AS tsk
ON p.project_id = tsk.project_id
ORDER BY p.project_id ASC;
-- A5
-- Return tenant 1 tasks with project name and assigned-user email when available. Every tenant 1 task must remain.
SELECT tsk.task_id, p.project_name, u.email FROM tasks AS tsk
LEFT JOIN projects AS p
ON tsk.project_id = p.project_id
LEFT JOIN users AS u
ON tsk.assigned_user_id = u.user_id
WHERE tsk.tenant_id = 1
ORDER BY tsk.task_id ASC;

-----------------------------------------------------------------------------------------------------------------------------------------------------
-- B1
-- Return tasks with the earliest deadline.
SELECT * FROM tasks AS tsk WHERE due_date = (SELECT MIN(due_date) FROM tasks AS tsk);
-- B2
-- Return tasks with the latest deadline.
SELECT * FROM tasks AS tsk WHERE due_date = (SELECT MAX(due_date) FROM tasks AS tsk);
-- B3
-- Return user rows for users who belong to tenant 2. Do not use a join.
SELECT * FROM users AS u WHERE user_id IN (SELECT m.user_id FROM memberships AS m WHERE m.tenant_id = 2) ORDER BY u.user_id ASC;
-- B4
-- Return users who belong to at least one tenant using a set-membership approach.
SELECT * FROM users AS u WHERE u.user_id IN (SELECT m.user_id FROM memberships AS m) ORDER BY u.user_id ASC;
-- B5
-- Return projects that have at least one task using existence logic.
SELECT * FROM projects AS p WHERE EXISTS (SELECT 1 FROM tasks AS tsk WHERE tsk.project_id = p.project_id) ORDER BY p.project_id ASC;
-- B6
-- Return projects with no tasks using absence logic.
SELECT * FROM projects AS p WHERE NOT EXISTS (SELECT 1 FROM tasks AS tsk WHERE tsk.project_id = p.project_id) ORDER BY p.project_id ASC;
-- B7
-- Return users with at least one active membership using existence logic.
SELECT * FROM users AS u WHERE EXISTS (SELECT 1 FROM memberships AS m WHERE u.user_id = m.user_id AND m.membership_status = 'active') ORDER BY u.user_id ASC;
-- B8
-- Return users with no active memberships using absence logic.
SELECT * FROM users AS u WHERE NOT EXISTS (SELECT 1 FROM memberships AS m WHERE u.user_id = m.user_id AND m.membership_status = 'active') ORDER BY u.user_id ASC;

-----------------------------------------------------------------------------------------------------------------------------------------------------
-- C1
-- Return tenant 1 users together with their membership role.
SELECT u.user_id, m.role FROM users AS u 
INNER JOIN memberships AS m
ON u.user_id = m.user_id
WHERE m.tenant_id = 1
ORDER BY u.user_id ASC;
-- C2
-- Return user rows for users who have an active membership in tenant 1. Final output needs only user information.
SELECT * FROM users AS u WHERE u.user_id IN (SELECT m.user_id FROM memberships AS m WHERE m.membership_status = 'active' AND m.tenant_id = 1) ORDER BY u.user_id ASC;
-- C3
-- Return every project and its task count, including projects with zero tasks.
SELECT p.project_id, p.project_name, COUNT(tsk.task_id) AS task_count FROM projects AS p
LEFT JOIN tasks AS tsk
ON p.project_id = tsk.project_id
GROUP BY p.project_id
ORDER BY p.project_id ASC;
-- C4
-- Return project rows for projects that have at least one active task. Final output needs only project information.
SELECT * FROM projects AS p WHERE EXISTS (SELECT 1 FROM tasks AS tsk WHERE tsk.project_id = p.project_id AND tsk.task_status <> 'completed') ORDER BY p.project_id ASC; 
-- C5
-- Return tasks whose task ID is greater than the average task ID.
SELECT * FROM tasks AS tsk WHERE tsk.task_id > (SELECT AVG(tsk.task_id) FROM tasks AS tsk) ORDER BY tsk.task_id ASC;
-- C6
-- Return every task with assigned-user information when available. Explain why `EXISTS` alone would not provide the requested user columns.
SELECT tsk.task_id, tsk.assigned_user_id, u.email, u.first_name, u.last_name FROM tasks AS tsk
LEFT JOIN users AS u
ON tsk.assigned_user_id = u.user_id
ORDER BY tsk.task_id ASC;
-- EXISTS would not be enough because it would have not helped us get the information about the columns from the users table.
-- C7
-- Return users who belong to at least one tenant that has an active project. Use a subquery-based approach.
SELECT * FROM users AS u WHERE EXISTS (SELECT 1 FROM memberships AS m WHERE m.user_id = u.user_id AND EXISTS (SELECT 1 FROM projects AS p WHERE p.tenant_id = m.tenant_id AND p.project_status = 'active')) ORDER BY u.user_id ASC;
-- C8
-- Return tenants with no active projects.
SELECT * FROM tenants AS t WHERE NOT EXISTS (SELECT 1 FROM projects AS p WHERE p.tenant_id = t.tenant_id AND p.project_status = 'active') ORDER BY t.tenant_id ASC;