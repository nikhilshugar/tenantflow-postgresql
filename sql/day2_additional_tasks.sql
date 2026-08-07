INSERT INTO tasks (tenant_id,project_id,task_title,task_status,priority,assigned_user_id,created_by_user_id,due_date,completed_at,created_at,updated_at)
VALUES (1,1,'Validate metric payload','todo','medium',3,1,'2026-08-09',NULL,'2026-08-01 09:15:00-04','2026-08-01 09:15:00-04'),
	   (1,2,'Archive dashboard exports','completed','low',2,2,'2026-07-30','2026-07-30 17:00:00-04','2026-07-25 10:00:00-04','2026-07-25 10:00:00-04'),
	   (2,3,'Document reminder workflow','todo','high',5,5,NULL,NULL,'2026-08-04 13:30:00-04','2026-08-04 13:30:00-04'),
	   (2,4,'Verify legacy identifiers','blocked','urgent',NULL,5,'2026-08-08',NULL,'2026-08-05 08:00:00-04','2026-08-05 08:00:00-04'),
	   (2,4,'Confirm migration owner','backlog','medium',3,5,'2026-08-12',NULL,'2026-08-02 16:45:00-04','2026-08-02 16:45:00-04');

SELECT * FROM tasks;