BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "item_match" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "item_match" (
    "id" bigserial PRIMARY KEY,
    "lostReportId" bigint NOT NULL,
    "foundReportId" bigint NOT NULL,
    "confidenceScore" double precision NOT NULL,
    "textScore" double precision NOT NULL,
    "locationScore" double precision NOT NULL,
    "distanceScore" double precision NOT NULL,
    "timeScore" double precision NOT NULL,
    "categoryScore" double precision NOT NULL,
    "explanation" text NOT NULL,
    "distanceKm" double precision NOT NULL,
    "timeDiffHours" double precision NOT NULL,
    "status" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "item_match_lost_found_idx" ON "item_match" USING btree ("lostReportId", "foundReportId");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "item_report" ADD COLUMN "locationId" bigint;
ALTER TABLE "item_report" ADD COLUMN "locationAreaId" bigint;
CREATE INDEX "item_report_location_idx" ON "item_report" USING btree ("locationId");
--
-- ACTION CREATE TABLE
--
CREATE TABLE "location" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "type" text NOT NULL,
    "address" text,
    "latitude" double precision NOT NULL,
    "longitude" double precision NOT NULL,
    "description" text,
    "logoUrl" text,
    "isActive" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "location_name_idx" ON "location" USING btree ("name");
CREATE INDEX "location_type_idx" ON "location" USING btree ("type");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "location_area" (
    "id" bigserial PRIMARY KEY,
    "locationId" bigint NOT NULL,
    "name" text NOT NULL,
    "latitude" double precision,
    "longitude" double precision,
    "description" text,
    "isActive" boolean NOT NULL
);

-- Indexes
CREATE INDEX "location_area_loc_idx" ON "location_area" USING btree ("locationId");


--
-- MIGRATION VERSION FOR found_it
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('found_it', '20260929184913498', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260929184913498', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
