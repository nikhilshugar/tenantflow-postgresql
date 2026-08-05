INSERT INTO tenants (tenant_name,tenant_slug,plan_type,tenant_status)
VALUES ('Northstar Labs','northstar-labs','professional','active'),
	   ('Beacon Health','beacon-health','starter','trial');

SELECT * FROM tenants; -- Contains 2 tenants

INSERT INTO users (email,first_name,last_name,user_status)
VALUES ('asha@northstar.example','Asha','Rao','active'),
	   ('liam@northstar.example','Liam','Chen','active'),
	   ('priya@example.com','Priya','Shah','active'),
	   ('mateo@example.com','Mateo','Silva','invited'),
	   ('zoe@beacon.example','Zoe','Brooks','active');

SELECT * FROM users; -- Contains 5 users

INSERT INTO memberships (tenant_id,user_id,role,membership_status,invited_by_user_id)
VALUES (1,1,'owner','active',NULL),
	   (1,2,'admin','active',1),
	   (1,3,'member','active',1),
	   (1,4,'viewer','invited',2),
	   (2,5,'owner','active',NULL),
	   (2,3,'viewer','active',5),
	   (2,4,'member','suspended',5);

SELECT * FROM memberships; -- Contains 7 memberships

INSERT INTO projects (tenant_id,project_name,project_status,created_by_user_id,start_date,due_date)
VALUES (1,'Telemetry Platform','active',1,'2026-07-28','2026-08-20'),
	   (1,'Customer Dashboard','archived',2,'2026-06-01','2026-07-15'),
	   (2,'Appointment System','active',5,'2026-08-01','2026-08-30'),
	   (2,'Data Migration','planned',5,NULL,NULL);

SELECT * FROM projects; -- Contains 4 projects

INSERT INTO tasks (tenant_id,project_id,task_title,task_status,priority,assigned_user_id,created_by_user_id,due_date,completed_at)
VALUES (1,1,'Build Ingestion endpoint','todo','high',2,1,'2026-08-07',NULL),
	   (1,1,'Add Tenant Context','in_progress','urgent',1,1,'2026-08-05',NULL),
	   (1,1,'Write Setup Code','completed','medium',3,2,'2026-08-02',CURRENT_TIMESTAMP),
	   (1,2,'Review Old Mockups','backlog','low',NULL,2,NULL,NULL),
	   (1,2,'Remove legacy widget','blocked','high',2,2,'2026-08-01',NULL),
	   (2,3,'Design Appointment Schema','in_progress','high',5,5,'2026-08-10',NULL),
	   (2,4,'Prepare migration mapping','todo','urgent',3,5,'2026-08-06',NULL),
	   (2,3,'Complete QA checklist','completed','low',5,5,'2026-08-03',CURRENT_TIMESTAMP),
	   (2,3,'Define retry handling','backlog','medium',NULL,5,NULL,NULL),
	   (2,4,'Schedule stakeholder review','todo','medium',5,5,'2026-08-15',NULL);

SELECT * FROM tasks; -- Contains 10 tasks