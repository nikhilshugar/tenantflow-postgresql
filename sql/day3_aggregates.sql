-- How many tenants exist?
SELECT COUNT(*) FROM tenants;

-- How many active tenants exist?
SELECT COUNT(*) FROM tenants WHERE tenant_status = 'active';

-- How many global user accounts exist?
SELECT COUNT(*) FROM users;

-- How many distinct users belong to at least one tenant?
SELECT COUNT(DISTINCT user_id) FROM memberships;

-- How many projects exist across the system?
SELECT COUNT(*) FROM projects;

-- How many tasks exist across the system?
SELECT COUNT(*) FROM tasks;

-- How many tasks are completed?
SELECT COUNT(*) FROM tasks WHERE task_status = 'completed';

-- What is the earliest non-null project start date?
SELECT MIN(start_date) FROM projects;

-- What is the latest non-null task deadline?
SELECT MAX(due_date) AS Latest_Deadline FROM tasks;

-- How many distinct users are assigned at least one task?
SELECT COUNT(DISTINCT assigned_user_id) AS tasks_per_user FROM tasks;

-- Count every task belonging to tenant 1.
SELECT COUNT(*) FROM tasks WHERE tenant_id = 1;

-- Count completed tasks belonging to tenant 2.
SELECT COUNT(*) FROM tasks WHERE tenant_id = 2 AND task_status = 'completed';

-- Find the latest non-null deadline among tenant 1's tasks.
SELECT MAX(due_date) FROM tasks WHERE tenant_id = 1;

-- Experiment A: Row count versus non-null due dates
-- Run one aggregate query that returns both:
-- The total number of task rows
SELECT COUNT(*) AS total_number_of_tasks FROM tasks;
-- The number of task rows with a non-null due_date
SELECT COUNT(due_date) AS total_tasks_with_due_date FROM tasks;
-- They differ because COUNT(column) ignores the NULL values whereas COUNT(*) includes the NULL values.

-- Experiment B: Assigned tasks versus distinct assignees
-- Compare:
-- The number of non-null assigned_user_id values
SELECT COUNT(assigned_user_id) FROM tasks;
-- The number of distinct non-null assigned_user_id values
SELECT COUNT(DISTINCT assigned_user_id) FROM tasks;
-- The first measures assigned task rows. The second measures different assignees.

-- Experiment C: An empty row set
-- Use a tenant ID that you know does not exist and calculate both:
-- COUNT(*)
-- MIN(due_date)
-- Observe why the count is zero while the minimum is null.
SELECT COUNT(*) FROM tasks WHERE tenant_id = 3;
SELECT MIN(due_date) FROM tasks WHERE tenant_id = 3;
-- The COUNT(*) is 0 because the COUNT(*) includes NULL while counting whereas MIN(due_date) ignores NULL so if all there are is NULL then it will return NULL.

-- Experiment D: Date boundaries
-- Return the earliest and latest non-null task due dates in the same output row. Verify both values against a Day 2 sorted detail query.
SELECT MIN(due_date), MAX(due_date) FROM tasks;
SELECT * FROM tasks ORDER BY due_date ASC;
