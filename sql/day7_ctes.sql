-- C1
WITH active_projects AS(
SELECT * FROM projects WHERE project_status = 'active'
)
SELECT * FROM active_projects ORDER BY project_id ASC;

-- C2
WITH tenant1_tasks AS(
SELECT * FROM tasks WHERE tenant_id = 1
)
SELECT * FROM tenant1_tasks ORDER BY task_id ASC;

-- C3
WITH incomplete_tasks AS(
SELECT * FROM tasks WHERE task_status <> 'completed'
)
SELECT * FROM incomplete_tasks WHERE tenant_id = 1 ORDER BY task_id ASC;

-- C4
WITH active_memberships AS(
SELECT m.tenant_id,m.user_id,m.role FROM memberships AS m WHERE m.membership_status = 'active'
)
SELECT m.tenant_id,m.user_id,u.email,m.role FROM active_memberships AS m
INNER JOIN users AS u
ON m.user_id = u.user_id
ORDER BY m.tenant_id ASC, m.user_id ASC;

-- C5
WITH number_of_tasks AS(
SELECT tsk.project_id, COUNT(*) AS task_count FROM tasks AS tsk
GROUP BY tsk.project_id
)
SELECT * FROM number_of_tasks AS tsk ORDER BY tsk.project_id;

-- C6
WITH task_count AS(
SELECT project_id, COUNT(*) AS tasks_count FROM tasks GROUP BY project_id
)
SELECT * FROM task_count WHERE tasks_count >= 2;

-- C7 & C8
WITH task_count AS (
    SELECT
        p.project_id,
        COUNT(tsk.task_id) AS tasks_count
    FROM projects AS p
    LEFT JOIN tasks AS tsk
        ON p.project_id = tsk.project_id
    GROUP BY p.project_id
)
SELECT
    p.project_id,
    p.project_name,
    tc.tasks_count
FROM projects AS p
INNER JOIN task_count AS tc
    ON p.project_id = tc.project_id
ORDER BY p.project_id ASC;

-- C9
WITH active_projects AS(
SELECT p.tenant_id, COUNT(*) AS active_projects FROM projects AS p WHERE p.project_status = 'active'
GROUP BY p.tenant_id
)
SELECT * FROM active_projects AS p ORDER BY p.tenant_id ASC;

-- C10
WITH active_projects AS(
SELECT p.tenant_id, COUNT(*) AS tenant_active_projects FROM projects AS p
WHERE p.project_status = 'active'
GROUP BY p.tenant_id
)
SELECT p.tenant_id,t.tenant_slug, p.tenant_active_projects FROM active_projects AS p
INNER JOIN tenants AS t
ON t.tenant_id = p.tenant_id
ORDER BY t.tenant_id ASC;

-- M1
WITH active_memberships AS(
SELECT * FROM memberships AS m WHERE m.membership_status = 'active'
),
active_projects AS(
SELECT * FROM projects AS p WHERE p.project_status = 'active'
)
SELECT * FROM active_projects;

-- M2
WITH tenant1_tasks AS(
SELECT * FROM tasks AS tsk WHERE tsk.tenant_id = 1
),
tenant1_incomplete_tasks AS(
SELECT * FROM tenant1_tasks AS tsk WHERE tsk.task_status <> 'completed'
)
SELECT * FROM tenant1_incomplete_tasks AS tsk ORDER BY tsk.task_id ASC;