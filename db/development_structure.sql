CREATE TABLE "activity_log_entries" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "project_id" integer, "user_id" integer, "description" varchar(255) NOT NULL, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "card_states" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "list_index" integer DEFAULT 1, "key" varchar(255) NOT NULL, "name" varchar(255) NOT NULL, "project_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "card_types" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "cards" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(255), "description" text, "status" varchar(255), "project_id" integer, "release_id" integer, "created_at" datetime, "updated_at" datetime, "point_estimate" integer DEFAULT 0, "card_type_id" integer DEFAULT 1, "release_position" integer, "card_state_id" integer, "iteration_id" integer);
CREATE TABLE "iterations" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "start_date" date NOT NULL, "duration_in_weeks" integer DEFAULT 1, "created_at" datetime, "updated_at" datetime, "release_id" integer, "points_left_frozen" integer DEFAULT 0, "points_completed_frozen" integer DEFAULT 0);
CREATE TABLE "project_assignments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "project_id" integer);
CREATE TABLE "projects" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime, "updated_at" datetime, "current_release_id" integer);
CREATE TABLE "releases" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "description" text, "project_id" integer, "created_at" datetime, "updated_at" datetime, "current_iteration_id" integer);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "task_states" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "created_at" datetime, "updated_at" datetime);
CREATE TABLE "tasks" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "estimate" integer DEFAULT 0, "task_state_id" integer NOT NULL, "card_id" integer, "user_id" integer, "created_at" datetime, "updated_at" datetime);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "login" varchar(40), "name" varchar(100) DEFAULT '', "email" varchar(100), "crypted_password" varchar(40), "salt" varchar(40), "created_at" datetime, "updated_at" datetime, "remember_token" varchar(40), "remember_token_expires_at" datetime, "activation_code" varchar(40), "activated_at" datetime, "admin" boolean);
CREATE UNIQUE INDEX "index_users_on_login" ON "users" ("login");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20080621180603');

INSERT INTO schema_migrations (version) VALUES ('20080621195732');

INSERT INTO schema_migrations (version) VALUES ('20080621200740');

INSERT INTO schema_migrations (version) VALUES ('20080622184030');

INSERT INTO schema_migrations (version) VALUES ('20080629205427');

INSERT INTO schema_migrations (version) VALUES ('20080713070357');

INSERT INTO schema_migrations (version) VALUES ('20080713105259');

INSERT INTO schema_migrations (version) VALUES ('20080713162657');

INSERT INTO schema_migrations (version) VALUES ('20080806030251');

INSERT INTO schema_migrations (version) VALUES ('20080806062853');

INSERT INTO schema_migrations (version) VALUES ('20080808184250');

INSERT INTO schema_migrations (version) VALUES ('20080809044528');

INSERT INTO schema_migrations (version) VALUES ('20080809113332');

INSERT INTO schema_migrations (version) VALUES ('20080809141015');

INSERT INTO schema_migrations (version) VALUES ('20080821033640');

INSERT INTO schema_migrations (version) VALUES ('20081111044733');

INSERT INTO schema_migrations (version) VALUES ('20081117090838');

INSERT INTO schema_migrations (version) VALUES ('20081204065726');

INSERT INTO schema_migrations (version) VALUES ('20090304173429');

INSERT INTO schema_migrations (version) VALUES ('20090304173500');