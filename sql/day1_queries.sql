-- Question: Find all active tenants. 
-- Write your query below.
SELECT * FROM tenants WHERE tenant_status = 'active';

-- Question: Find all active users.
-- Write your query below.
SELECT * FROM users WHERE user_status = 'active';

-- Question: Find memberships whose role is owner or admin.
-- Write your query below.
SELECT * FROM memberships WHERE role IN ('owner','admin');

-- Question: Find active projects belonging to tenant 1.
-- Write your query below.
SELECT * FROM projects WHERE tenant_id = 1 AND project_status = 'active';

-- Question: Find high- or urgent-priority tasks belonging to tenant 1.
-- Write your query below.
SELECT * FROM tasks WHERE tenant_id = 1 AND priority IN ('high','urgent');

-- Question: Find incomplete tasks belonging to tenant 2.
-- Write your query below.
SELECT * FROM tasks WHERE tenant_id = 2 AND task_status NOT IN ('completed');

-- Question: Find unassigned tasks belonging to tenant 1.
-- Write your query below.
SELECT * FROM tasks WHERE tenant_id = 1 AND assigned_user_id IS NULL;

-- Question: Find tasks belonging to tenant 2 that have a due date.
-- Write your query below.
SELECT * FROM tasks WHERE tenant_id = 2 AND due_date IS NOT NULL;

-- Question: Find tenant 1 tasks due from August 4 through August 10, inclusive.
-- Write your query below.
SELECT * FROM tasks WHERE tenant_id = 1 AND due_date BETWEEN '2026-08-04' AND '2026-08-10'; -- Both the endpoints are included while using BETWEEN.

-- Question: Find project names containing the exact word text Platform.
-- Write your query below.
SELECT * FROM projects WHERE project_name LIKE '%Platform%';

-- Question: Duplicate the northstar-labs slug. Which constraint rejects it?
-- Write your query below.
INSERT INTO tenants (tenant_name,tenant_slug,plan_type,tenant_status)
VALUES ('Northstar Labs','northstar-labs','professional','active');
-- Answer: The UNIQUES constraint is violated.

-- Question: Use manager as a membership role. Which constraint rejects it?
-- Write your query below.
INSERT INTO memberships (tenant_id,user_id,role,membership_status,invited_by_user_id)
VALUES (1,1,'manager','active',NULL);
-- Answer: The CHECK constraint is violated.

-- Question: Use critical as a task priority. Which constraint rejects it?
-- Write your query below.
INSERT INTO tasks (tenant_id,project_id,task_title,task_status,priority,assigned_user_id,created_by_user_id,due_date,completed_at)
VALUES (1,1,'Build Ingestion endpoint','todo','critical',2,1,'2026-08-07',NULL);
-- Answer: The tasks_priority_check constraint is violated.

-- Question: Reference a tenant ID that does not exist. Which constraint rejects it?
-- Write your query below.
INSERT INTO memberships (tenant_id,user_id,role,membership_status,invited_by_user_id)
VALUES (99,1,'owner','active',NULL);
-- Answer: The Foreign Key constraint is violated.