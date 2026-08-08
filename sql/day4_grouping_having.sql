-- Across the system, return one row per task_status. Show task_status and the number of task rows. Sort by task count descending, then status ascending.
SELECT task_status,
	   COUNT(*) AS task_count
FROM tasks
GROUP BY task_status
ORDER BY task_count DESC, task_status ASC;

-- Across the system, return one row per priority. Show priority and the number of task rows. Sort priorities alphabetically.
SELECT priority,
	   COUNT(*) AS task_count
FROM tasks
GROUP BY priority
ORDER BY priority ASC;

-- Across the system, return one row per project_status. Show project_status and the number of project rows. 
-- Sort by project count descending, then status ascending.
SELECT project_status,
	   COUNT(*) AS project_count
FROM projects
GROUP BY project_status
ORDER BY project_count DESC, project_status ASC;

-- Across the system, return one row per tenant_id from memberships. Show tenant_id and the number of membership rows. Sort by tenant ID ascending.
SELECT tenant_id,
	   COUNT(*) AS number_of_rows
FROM memberships
GROUP BY tenant_id
ORDER BY tenant_id ASC;

-- Across the system, return one row per membership role. Show the role and the number of distinct users who have that role in at least one tenant. 
-- Sort by distinct-user count descending, then role ascending.
SELECT role,
	   COUNT(DISTINCT user_id) AS distinct_user
FROM memberships
GROUP BY role
ORDER BY distinct_user DESC, role ASC;

-- Across the system, return one row per task tenant_id. 
-- In the same output row, show the tenant ID, task count, earliest non-null task deadline, and latest non-null task deadline. 
-- Sort by tenant ID ascending.
SELECT tenant_id,
	   COUNT(*) AS task_count,
	   MIN(due_date) AS earliest_deadline,
	   MAX(due_date) AS latest_deadline
FROM tasks
GROUP BY tenant_id
ORDER BY tenant_id ASC;

-- Across the system, return one row per unique combination of task tenant_id and task_status. Show both grouping keys and the task count. 
-- Sort by tenant ID ascending, then status ascending.
SELECT tenant_id,
       task_status,
       COUNT(*) AS task_count
FROM tasks
GROUP BY tenant_id,task_status
ORDER BY tenant_id ASC, task_status ASC;

-- Across the system, return one row per assigned_user_id, including one null group for unassigned tasks. 
-- Show the assignee value and number of task rows. Sort assigned users ascending and place the null group last.
SELECT assigned_user_id,
	   COUNT(*) AS number_of_tasks
FROM tasks
GROUP BY assigned_user_id
ORDER BY assigned_user_id ASC NULLS LAST;

-- Across the system, return only task-status groups containing at least two task rows. Show status and task count. 
-- Sort by count descending, then status ascending.
SELECT task_status,
	   COUNT(*) AS task_count
FROM tasks
GROUP BY task_status
HAVING COUNT(*) >= 2
ORDER BY task_count DESC, task_status ASC;

-- For tenant 1 only, return priority groups containing at least two task rows. 
-- Show priority and task count. Sort by count descending, then priority ascending.
SELECT priority,
	   COUNT(*) AS task_count
FROM tasks
WHERE tenant_id = 1
GROUP BY priority
HAVING COUNT(*) >= 2
ORDER BY task_count DESC, priority ASC;