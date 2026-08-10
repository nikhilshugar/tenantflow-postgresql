-- Plain-English plan
-- 1. Evidence table: memberships
-- 2. Allowed individual rows (WHERE): membership_status = 'active'
-- 3. One result row represents: The entire system
-- 4. Required output columns: active_member_user_count
-- 5. Calculation inside the selected rows or each group: DISTINCT USERS
-- 6. Completed groups to remove (HAVING): NONE
-- 7. Result ordering: NONE
-- 8. Row limit or offset: NONE

-- Across the system, return one summary row showing the number of distinct users who have at least one active membership. 
-- sName the result active_member_user_count and user_id

SELECT COUNT(DISTINCT user_id) AS active_member_user_count FROM memberships WHERE membership_status = 'active';


-- Plain-English plan
-- 1. Evidence table: tasks
-- 2. Allowed individual rows (WHERE): where tenant_id = 1
-- 3. One result row represents: group by priority
-- 4. Required output columns: priority and task_count
-- 5. Calculation inside the selected rows or each group: 
-- 6. Completed groups to remove (HAVING): task count >= 2
-- 7. Result ordering: Sort by task_count desc, priority asc
-- 8. Row limit or offset: NONE

-- For tenant 1 only, return one row per task priority. Show the priority and task count. Keep only priority groups containing at least two task rows.
-- Sort by task count descending, then priority ascending.

SELECT priority, COUNT(*) AS task_count FROM tasks WHERE tenant_id = 1 GROUP BY priority HAVING COUNT(*) >= 2 ORDER BY task_count DESC, priority ASC;

-- Plain-English plan
-- 1. Evidence table: tasks
-- 2. Allowed individual rows (WHERE): tasks whose task_status is not completed
-- 3. One result row represents: group by tenant_id and status
-- 4. Required output columns: tenant_id, task_status, task_count
-- 5. Calculation inside the selected rows or each group: 
-- 6. Completed groups to remove (HAVING): NONE
-- 7. Result ordering: Sort by tenant_id ASC, task_status desc
-- 8. Row limit or offset: NONE

-- Across the system, consider only tasks whose status is not completed. Return one row per unique tenant-and-status combination. 
-- Show tenant_id, task_status, and task count. Sort by tenant ID ascending, then status ascending.

SELECT tenant_id, task_status, COUNT(*) AS task_count FROM tasks WHERE task_status != 'completed' GROUP BY tenant_id, task_status ORDER BY tenant_id ASC, task_status DESC;

-- Plain-English plan
-- 1. Evidence table: tasks
-- 2. Allowed individual rows (WHERE): where tenant_id is 2 and due_date is not null
-- 3. One result row represents: one task per row
-- 4. Required output columns: task_id, task_title, due_date and priority
-- 5. Calculation inside the selected rows or each group: NONE
-- 6. Completed groups to remove (HAVING): NONE
-- 7. Result ordering: Sort by deadline ASC and task_id ASC
-- 8. Row limit or offset: LIMIT 4

-- For tenant 2 only, return the first four tasks after arranging all tasks having a non-null deadline from earliest deadline to latest. 
-- Show task_id, task_title, due_date, and priority. Use task ID ascending to resolve equal deadlines.

SELECT task_id, task_title, due_date, priority FROM tasks WHERE tenant_id = 2 AND due_date IS NOT NULL ORDER BY due_date ASC, task_id ASC LIMIT 4;

-- Plain-English plan
-- 1. Evidence table: tasks
-- 2. Allowed individual rows (WHERE): NONE
-- 3. One result row represents: one assigned_user_id per row, meaning group by assigned_user_id
-- 4. Required output columns: assigned_user_id and task_count
-- 5. Calculation inside the selected rows or each group: tasks per assigned_user_id
-- 6. Completed groups to remove (HAVING): NONE
-- 7. Result ordering: Sort by task_count DESC and assigned_user_id ASC with NULLS LAST
-- 8. Row limit or offset: NONE

-- Across the system, return one row per assigned_user_id, including one NULL group for unassigned tasks. 
-- Show the assignee value and number of task rows.
-- Sort by task count descending, then assignee ascending, with the null group last.

SELECT assigned_user_id, COUNT(*) AS task_count FROM tasks GROUP BY assigned_user_id ORDER BY task_count DESC, assigned_user_id ASC NULLS LAST;

-- Plain-English plan
-- 1. Evidence table: memberships
-- 2. Allowed individual rows (WHERE): only members with active status
-- 3. One result row represents: one membership role per row 
-- 4. Required output columns: role and number of distinct users for each role
-- 5. Calculation inside the selected rows or each group: count number of distinct users for that role
-- 6. Completed groups to remove (HAVING): number of distinct user greater than or equal to 2
-- 7. Result ordering: distinct_user_count DESC and role ASC
-- 8. Row limit or offset: NONE

-- Across the system, consider only active membership rows. Return one row per membership role and show the number of distinct users having that role. 
-- Keep only roles held by at least two distinct users. 
-- Sort by distinct-user count descending, then role ascending.

SELECT role, COUNT(DISTINCT user_id) AS distinct_user_count FROM memberships WHERE membership_status = 'active' GROUP BY role HAVING COUNT(DISTINCT user_id) >= 2 ORDER BY distinct_user_count DESC, role ASC;

-- Plain-English plan
-- 1. Evidence table: tasks
-- 2. Allowed individual rows (WHERE): only tenant_id = 2
-- 3. One result row represents: one row for each project_id
-- 4. Required output columns: project_id and task_count 
-- 5. Calculation inside the selected rows or each group: count number of tasks for each project_id
-- 6. Completed groups to remove (HAVING): projects having atleast 2 tasks
-- 7. Result ordering: task_count DESC and project_id ASC
-- 8. Row limit or offset: NONE

-- For tenant 2 only, return one row per project_id represented in tasks. 
-- Show the project ID and number of task rows. Keep only project groups having at least two tasks. 
-- Sort by task count descending, then project ID ascending.

SELECT project_id, COUNT(*) AS task_count FROM tasks WHERE tenant_id = 2 GROUP BY project_id HAVING COUNT(*) >= 2 ORDER BY task_count DESC, project_id ASC;

-- Plain-English plan
-- 1. Evidence table: tasks
-- 2. Allowed individual rows (WHERE): NONE
-- 3. One result row represents: one row for each tenant_id
-- 4. Required output columns: tenant_id and task_count 
-- 5. Calculation inside the selected rows or each group: count number of tasks for each tenant_id
-- 6. Completed groups to remove (HAVING): tenant having atleast 4 tasks
-- 7. Result ordering: task_count DESC and tenant_id ASC
-- 8. Row limit or offset: NONE

-- Across the system, return only tenant groups containing at least four task rows. 
-- Show tenant_id and task count. Sort by task count descending, then tenant ID ascending.

SELECT tenant_id, COUNT(*) AS task_count FROM tasks GROUP BY tenant_id HAVING COUNT(*) >= 4 ORDER BY task_count DESC, tenant_id ASC;

--------------------------------------------------------------------------------------------------------------------------------------------

-- Return active tenants whose plan is either starter or professional. Show tenant_id, tenant_name, plan_type, and created_at. 
-- Sort newest tenants first, then tenant ID ascending for equal timestamps.

SELECT tenant_id, tenant_name, plan_type, created_at FROM tenants WHERE tenant_status = 'active' AND plan_type IN ('starter','professional')
ORDER BY created_at DESC, tenant_id ASC;

-- Return users whose status is invited and whose last_login_at is null. Show user_id, email, user_status, and created_at. 
-- Sort by creation time ascending, then user ID ascending. 

SELECT user_id, email, user_status, created_at FROM users WHERE user_status = 'invited' AND last_login_at IS NULL ORDER BY created_at ASC, user_id ASC;

-- For tenant 1 only, return incomplete tasks whose priority is high or urgent and whose deadline is not null. 
-- Show task_id, task_title, task_status, priority, and due_date. Sort by deadline ascending, then task ID ascending.

SELECT task_id, task_title, task_status, priority, due_date FROM tasks WHERE tenant_id = 1 AND task_status <> 'completed' AND priority IN ('high','urgent') AND due_date IS NOT NULL ORDER BY due_date DESC, task_id ASC;

-- Across the system, return projects whose status is planned or active and whose start date falls between 2026-07-01 and 2026-08-31, inclusive. 
-- Show project_id, tenant_id, project_name, project_status, and start_date. Sort by start date ascending, then project ID ascending.

SELECT project_id, tenant_id, project_name, project_status, start_date FROM projects WHERE project_status IN ('planned','active') AND start_date BETWEEN '2026-07-01' AND '2026-08-31' ORDER BY start_date ASC, project_id ASC;

-- Across the system, return the five most recently created task rows. Show task_id, tenant_id, task_title, and created_at. 
-- Sort by creation time descending, then task ID descending.

SELECT task_id, tenant_id, task_title, created_at FROM tasks ORDER BY created_at DESC, task_id DESC LIMIT 5;

-- For tenant 2 only, return page 2 of tasks using a page size of three. Sort by deadline ascending with null deadlines last, then task ID ascending.
-- Show task_id, task_title, due_date, and task_status.

SELECT task_id, task_title, due_date, task_status FROM tasks WHERE tenant_id = 2 ORDER BY due_date ASC NULLS LAST, task_id ASC LIMIT 3 OFFSET 3;

----------------------------------------------------------------------------------------------------------------------------------------------------

-- Plain-English plan
-- 1. Evidence table: tasks
-- 2. Allowed individual rows (WHERE): NONE
-- 3. One result row represents: The entire system
-- 4. Required output columns: task_count, due_date_count, assigned_user_id_count, distinct_assigned_user_id
-- 5. Calculation inside the selected rows or each group: DISTINCT user_id and counting tasks, due_date, assigned_user_id
-- 6. Completed groups to remove (HAVING): NONE
-- 7. Result ordering: NONE
-- 8. Row limit or offset: NONE

-- Across the system, return exactly one summary row showing:
-- -- Total task rows
-- -- Task rows with a non-null deadline
-- -- Task rows with a non-null assignee
-- -- Number of distinct non-null assignees
-- Use clear aliases for all four values.

SELECT COUNT(*) AS task_count, COUNT(due_date) AS due_date_count, COUNT(assigned_user_id) AS assigned_user_id_count, COUNT(DISTINCT assigned_user_id) AS distinct_assigned_user_id FROM tasks;

-- Plain-English plan
-- 1. Evidence table: tasks
-- 2. Allowed individual rows (WHERE): tenant_id = 1
-- 3. One result row represents: the entire system
-- 4. Required output columns: task_count, earliest_due_date and latest_due_date
-- 5. Calculation inside the selected rows or each group: COUNT for tasks, MAX(due_date) for latest and MIN(due_date) for early
-- 6. Completed groups to remove (HAVING): NONE
-- 7. Result ordering: NONE
-- 8. Row limit or offset: NONE

Across the system, return one row per unique project tenant-and-status combination. Show tenant_id, project_status, and project count. Sort by tenant ID ascending, then project count descending, then project status ascending.

-- For tenant 1 only, return exactly one summary row showing the task count, earliest non-null task deadline, and latest non-null task deadline.

SELECT COUNT(*) AS task_count, MIN(due_date) AS earliest_deadline, MAX(due_date) AS latest_deadline FROM tasks WHERE tenant_id = 1;

-- Plain-English plan
-- 1. Evidence table: tasks
-- 2. Allowed individual rows (WHERE): NONE
-- 3. One result row represents: unique tenant_id and status per row
-- 4. Required output columns: tenant_id, project_status and project_count
-- 5. Calculation inside the selected rows or each group: count for the project_count
-- 6. Completed groups to remove (HAVING): NONE
-- 7. Result ordering: tenant_id asc, project count desc, project status asc
-- 8. Row limit or offset: NONE

-- Across the system, return one row per unique project tenant-and-status combination. Show tenant_id, project_status, and project count. 
-- Sort by tenant ID ascending, then project count descending, then project status ascending.

SELECT tenant_id, project_status, COUNT(*) AS project_count FROM projects GROUP BY tenant_id, project_status ORDER BY tenant_id ASC, project_count DESC, project_status ASC;

-- Plain-English plan
-- 1. Evidence table: membership
-- 2. Allowed individual rows (WHERE): membership is active
-- 3. One result row represents: one role per row
-- 4. Required output columns: role and the number of distinct users
-- 5. Calculation inside the selected rows or each group: count for the number of distinct users and distinct
-- 6. Completed groups to remove (HAVING): NONE
-- 7. Result ordering: distinct_user_count desc, role asc
-- 8. Row limit or offset: NONE

-- Across the system, consider only active membership rows. Return one row per role. 
-- Show the role and number of distinct users. Sort by distinct-user count descending, then role ascending.

SELECT role, COUNT(DISTINCT user_id) AS distinct_user_count FROM memberships WHERE membership_status = 'active' GROUP BY role ORDER BY distinct_user_count DESC, role ASC;

-- Plain-English plan
-- 1. Evidence table: membership
-- 2. Allowed individual rows (WHERE): NONE
-- 3. One result row represents: one row per tenant_id
-- 4. Required output columns: tenant_id and the count of membership
-- 5. Calculation inside the selected rows or each group: count for the membership count
-- 6. Completed groups to remove (HAVING): membership_count >= 3
-- 7. Result ordering: membership_count desc, tenant_id asc
-- 8. Row limit or offset: NONE

-- Across the system, return one row per membership tenant_id. Show the tenant ID and membership row count. 
-- Keep only tenant groups containing at least three membership rows. Sort by membership count descending, then tenant ID ascending.

SELECT tenant_id, COUNT(*) AS membership_count FROM memberships GROUP BY tenant_id HAVING COUNT(*) >= 3 ORDER BY membership_count DESC, tenant_id ASC;

-- Plain-English plan
-- 1. Evidence table: tasks
-- 2. Allowed individual rows (WHERE): NONE
-- 3. One result row represents: one row per assigned_user_id
-- 4. Required output columns: assigned_user_id and task_count
-- 5. Calculation inside the selected rows or each group: count all the rows per assigned user id.
-- 6. Completed groups to remove (HAVING): task_count >= 2
-- 7. Result ordering: task_count desc, assigned_user_id asc and NULLS LAST
-- 8. Row limit or offset: NONE

-- Across the system, return one row per assigned_user_id, including the unassigned null group. 
-- Show the assignee value and task count. Keep only assignee groups containing at least two task rows. 
-- Sort by task count descending, then assignee ascending with null last.

SELECT assigned_user_id, COUNT(*) AS task_count FROM tasks GROUP BY assigned_user_id HAVING COUNT(*) >= 2 ORDER BY task_count DESC, assigned_user_id ASC NULLS LAST;

-- Plain-English plan
-- 1. Evidence table: tasks
-- 2. Allowed individual rows (WHERE): where the task_status is not completed.
-- 3. One result row represents: one row per tenant and priority combination
-- 4. Required output columns: tenant_id, priority and task_count
-- 5. Calculation inside the selected rows or each group: count all the rows per tenant and priority combination 
-- 6. Completed groups to remove (HAVING): task_count >= 2
-- 7. Result ordering: tenant_id asc, task_count desc and then priority ascending
-- 8. Row limit or offset: NONE

-- Across the system, consider only tasks whose status is not completed. Return one row per unique tenant-and-priority combination. 
-- Show tenant_id, priority, and task count. Keep only combinations containing at least two task rows. 
-- Sort by tenant ID ascending, task count descending, then priority ascending.

SELECT tenant_id, priority, COUNT(*) AS task_count FROM tasks WHERE task_status <> 'completed' GROUP BY tenant_id, priority HAVING COUNT(*)>=2
ORDER BY tenant_id ASC, task_count DESC, priority ASC;

-- Plain-English plan
-- 1. Evidence table: tasks
-- 2. Allowed individual rows (WHERE): NONE
-- 3. One result row represents: one row per task_status
-- 4. Required output columns: task_status, task_count, count of non null deadlines, earliest due_date and latest due_date per status
-- 5. Calculation inside the selected rows or each group: count all the rows per status, non-null deadlines, earliest and latest due dates
-- 6. Completed groups to remove (HAVING):NONE
-- 7. Result ordering: task_count DESC and task_status ASC
-- 8. Row limit or offset: NONE

-- Across the system, return one row per task_status. Show:
-- task_status
-- Total task rows in that status
-- Number of non-null deadlines in that status
-- Earliest non-null deadline in that status
-- Latest non-null deadline in that status
-- Sort by total task count descending, then task status ascending.

SELECT task_status, COUNT(*) AS task_count, COUNT(due_date) AS deadlines, MIN(due_date) AS earliest_deadline, MAX(due_date) AS latest_deadline
FROM tasks
GROUP BY task_status
ORDER BY task_count DESC, task_status ASC;

----------------------------------------------------------------------------------------------------------------------------------------------------

-- How many distinct task statuses exist across the system?
SELECT COUNT(DISTINCT task_status) FROM tasks;
-- How many tasks exist in each status?
SELECT task_status, COUNT(*) FROM tasks GROUP BY task_status;

-- How many membership rows exist?
SELECT COUNT(*) AS membership_count FROM memberships;
-- How many distinct users belong to at least one tenant?
SELECT COUNT(DISTINCT user_id) AS distinct_users FROM memberships;

-- What is the earliest non-null task deadline?
SELECT MIN(due_date) AS earliest_deadline FROM tasks;
-- Which task row has the earliest non-null deadline?
SELECT * FROM tasks WHERE due_date IS NOT NULL ORDER BY due_date ASC NULLS LAST LIMIT 1;

-- Return tenant 1 task rows whose task_id is at least 3.
SELECT * FROM tasks WHERE tenant_id = 1 AND task_id >= 3;
-- Return tenant groups containing at least three task rows
SELECT tenant_id, COUNT(*) AS task_count FROM tasks GROUP BY tenant_id HAVING COUNT(*)>=3;

-- Count active tasks for each tenant.
SELECT tenant_id, COUNT(*) AS active_task_count FROM tasks WHERE task_status <> 'completed' GROUP BY tenant_id;
-- Return tenant groups that have at least two active tasks.
SELECT tenant_id, COUNT(*) AS active_task_count FROM tasks WHERE task_status <> 'completed' GROUP BY tenant_id HAVING COUNT(*) >= 2;