BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "app_notification" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "type" text NOT NULL,
    "title" text NOT NULL,
    "body" text NOT NULL,
    "relatedMatchId" bigint,
    "relatedReportId" bigint,
    "isRead" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "app_notification_user_idx" ON "app_notification" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "app_user" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "name" text NOT NULL,
    "email" text NOT NULL,
    "phoneNumber" text,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "app_user_email_idx" ON "app_user" USING btree ("email");
CREATE UNIQUE INDEX "app_user_user_id_idx" ON "app_user" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "item_match" (
    "id" bigserial PRIMARY KEY,
    "lostReportId" bigint NOT NULL,
    "foundReportId" bigint NOT NULL,
    "confidenceScore" double precision NOT NULL,
    "textScore" double precision NOT NULL,
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
-- ACTION CREATE TABLE
--
CREATE TABLE "item_report" (
    "id" bigserial PRIMARY KEY,
    "userId" text NOT NULL,
    "userName" text NOT NULL,
    "userEmail" text NOT NULL,
    "reportType" text NOT NULL,
    "title" text NOT NULL,
    "description" text NOT NULL,
    "category" text NOT NULL,
    "latitude" double precision NOT NULL,
    "longitude" double precision NOT NULL,
    "locationLabel" text NOT NULL,
    "eventTime" timestamp without time zone NOT NULL,
    "imageUrl" text,
    "status" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "item_report_type_idx" ON "item_report" USING btree ("reportType");
CREATE INDEX "item_report_status_idx" ON "item_report" USING btree ("status");
CREATE INDEX "item_report_category_idx" ON "item_report" USING btree ("category");
CREATE INDEX "item_report_user_id_idx" ON "item_report" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "item_verification" (
    "id" bigserial PRIMARY KEY,
    "reportId" bigint NOT NULL,
    "question" text NOT NULL,
    "answerHash" text NOT NULL,
    "attemptCount" bigint NOT NULL,
    "maxAttempts" bigint NOT NULL,
    "isVerified" boolean NOT NULL,
    "verifiedByUserId" text,
    "verifiedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "verification_report_idx" ON "item_verification" USING btree ("reportId");


--
-- MIGRATION VERSION FOR found_it
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('found_it', '20260928185724530', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260928185724530', "timestamp" = now();

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
