CREATE TABLE tenants(
tenant_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
tenant_name TEXT NOT NULL,
tenant_slug TEXT NOT NULL UNIQUE,
plan_type TEXT NOT NULL
	CHECK(plan_type IN ('free','starter','professional','enterprise')),
tenant_status TEXT NOT NULL
	CHECK(tenant_status IN ('active','suspended','trial','cancelled')),
created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users(
user_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
email TEXT NOT NULL UNIQUE,
first_name TEXT NOT NULL,
last_name TEXT NOT NULL,
user_status TEXT NOT NULL
	CHECK(user_status IN ('active','disabled','invited')),
created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
last_login_at TIMESTAMPTZ NULL
);

CREATE TABLE memberships(
tenant_id BIGINT NOT NULL,
user_id BIGINT NOT NULL,
role TEXT NOT NULL
	CHECK(role IN ('owner','admin','viewer','member')),
membership_status TEXT NOT NULL
	CHECK(membership_status IN ('invited','active','suspended','removed')),
joined_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
invited_by_user_id BIGINT NULL,
PRIMARY KEY (tenant_id,user_id),
FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id),
FOREIGN KEY (user_id) REFERENCES users(user_id),
FOREIGN KEY (invited_by_user_id) REFERENCES users(user_id)
);

CREATE TABLE projects(
project_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
tenant_id BIGINT NOT NULL,
project_name TEXT NOT NULL,
project_description TEXT NULL,
project_status TEXT NOT NULL
	CHECK(project_status IN ('planned','active','paused','completed','archived')),
created_by_user_id BIGINT NOT NULL,
start_date DATE NULL,
due_date DATE NULL,
created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
UNIQUE(tenant_id,project_name),
FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id),
FOREIGN KEY (created_by_user_id) REFERENCES users(user_id),
CHECK(due_date IS NULL OR start_date IS NULL OR due_date >= start_date)
);

CREATE TABLE tasks(
task_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
tenant_id BIGINT NOT NULL,
project_id BIGINT NOT NULL,
task_title TEXT NOT NULL,
task_description TEXT NULL,
task_status TEXT NOT NULL
	CHECK(task_status IN ('backlog','todo','in_progress','blocked','completed')),
priority TEXT NOT NULL
	CHECK(priority IN ('low','medium','high','urgent')),
assigned_user_id BIGINT NULL,
created_by_user_id BIGINT NOT NULL,
due_date DATE NULL,
completed_at TIMESTAMPTZ NULL,
created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY(tenant_id) REFERENCES tenants(tenant_id),
FOREIGN KEY(project_id) REFERENCES projects(project_id),
FOREIGN KEY(assigned_user_id) REFERENCES users(user_id),
FOREIGN KEY(created_by_user_id) REFERENCES users(user_id)
);