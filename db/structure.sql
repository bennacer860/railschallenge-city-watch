CREATE TABLE "schema_migrations" ("version" varchar NOT NULL);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
CREATE TABLE "responders" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "emergency_code" integer, "type" varchar, "name" varchar, "capacity" integer, "on_duty" boolean, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
INSERT INTO schema_migrations (version) VALUES ('20150623234225');

