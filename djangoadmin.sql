/*
django 2.X 버전에서는 oracle 12c 이상 버전만 지원한다.
oracle 11g를 사용하려면 django admin 스키마를 주입해서 사용해야한다.

하위 테이블들에 대한 스키마 생성
AUTH_GROUP
DJANGO_CONTENT_TYPE
AUTH_PERMISSION
AUTH_GROUP_PERMISSIONS
DJANGO_MIGRATIONS
DJANGO_SESSION
AUTH_USER
DJANGO_ADMIN_LOG
AUTH_USER_GROUPS
AUTH_USER_USER_PERMISSIONS
*/


--AUTH_GROUP
CREATE TABLE "AUTH_GROUP"(
    "ID" NUMBER(11,0)  NOT NULL ENABLE,
	"NAME" NVARCHAR2(150),
	PRIMARY KEY ("ID"),
	UNIQUE ("NAME")
);

CREATE SEQUENCE "AUTH_GROUP_SEQ"
    MINVALUE 1
    MAXVALUE 999999999
    START WITH 1
    INCREMENT BY 1
    CACHE 20;

CREATE OR REPLACE TRIGGER "AUTH_GROUP_TR"
BEFORE INSERT ON "AUTH_GROUP"
FOR EACH ROW
WHEN (new."ID" IS NULL) BEGIN
	SELECT "AUTH_GROUP_SEQ".nextval
	INTO :new."ID" FROM dual;
END;

ALTER TRIGGER "AUTH_GROUP_TR" ENABLE;


--DJANGO_CONTENT_TYPE
CREATE TABLE "DJANGO_CONTENT_TYPE"(
    "ID" NUMBER(11,0) NOT NULL ENABLE,
	"APP_LABEL" NVARCHAR2(100),
	"MODEL" NVARCHAR2(100),
	PRIMARY KEY ("ID"),
	CONSTRAINT "DJANGO_CO_APP_LABEL_76BD3D3B_U" UNIQUE ("APP_LABEL", "MODEL")
);

CREATE SEQUENCE "DJANGO_CONTENT_TYPE_SEQ"
    MINVALUE 1
    MAXVALUE 999999999
    START WITH 1
    INCREMENT BY 1
    CACHE 20;

CREATE OR REPLACE TRIGGER "DJANGO_CONTENT_TYPE_TR"
BEFORE INSERT ON "DJANGO_CONTENT_TYPE"
FOR EACH ROW
WHEN (new."ID" IS NULL) BEGIN
	SELECT "DJANGO_CONTENT_TYPE_SEQ".nextval
	INTO :new."ID" FROM dual;
END;

ALTER TRIGGER "DJANGO_CONTENT_TYPE_TR" ENABLE;


--AUTH_PERMISSION
CREATE TABLE "AUTH_PERMISSION"(
    "ID" NUMBER(11,0) NOT NULL ENABLE,
	"NAME" NVARCHAR2(255),
	"CONTENT_TYPE_ID" NUMBER(11,0) NOT NULL ENABLE,
	"CODENAME" NVARCHAR2(100),
	PRIMARY KEY ("ID"),
 	CONSTRAINT "AUTH_PERM_CONTENT_T_01AB375A_U" UNIQUE ("CONTENT_TYPE_ID", "CODENAME"),
    CONSTRAINT "AUTH_PERM_CONTENT_T_2F476E4B_F" FOREIGN KEY ("CONTENT_TYPE_ID")
	    REFERENCES "DJANGO_CONTENT_TYPE" ("ID") DEFERRABLE INITIALLY DEFERRED ENABLE
);

CREATE INDEX "AUTH_PERMI_CONTENT_TY_2F476E4B" ON "AUTH_PERMISSION" ("CONTENT_TYPE_ID");

CREATE SEQUENCE "AUTH_PERMISSION_SEQ"
    MINVALUE 1
    MAXVALUE 999999999
    START WITH 1
    INCREMENT BY 1
    CACHE 20;

CREATE OR REPLACE TRIGGER "AUTH_PERMISSION_TR"
BEFORE INSERT ON "AUTH_PERMISSION"
FOR EACH ROW
WHEN (new."ID" IS NULL) BEGIN
	SELECT "AUTH_PERMISSION_SEQ".nextval
	INTO :new."ID" FROM dual;
END;

ALTER TRIGGER "AUTH_PERMISSION_TR" ENABLE;


--AUTH_GROUP_PERMISSION
CREATE TABLE "AUTH_GROUP_PERMISSIONS"(
	"ID" NUMBER(11,0) NOT NULL ENABLE,
	"GROUP_ID" NUMBER(11,0) NOT NULL ENABLE,
	"PERMISSION_ID" NUMBER(11,0) NOT NULL ENABLE,
	PRIMARY KEY ("ID"),
	CONSTRAINT "AUTH_GROU_GROUP_ID__0CD325B0_U" UNIQUE ("GROUP_ID", "PERMISSION_ID"),
	CONSTRAINT "AUTH_GROU_GROUP_ID_B120CBF9_F" FOREIGN KEY ("GROUP_ID")
	    REFERENCES "AUTH_GROUP" ("ID") DEFERRABLE INITIALLY DEFERRED ENABLE,
	CONSTRAINT "AUTH_GROU_PERMISSIO_84C5C92E_F" FOREIGN KEY ("PERMISSION_ID")
	    REFERENCES "AUTH_PERMISSION" ("ID") DEFERRABLE INITIALLY DEFERRED ENABLE
);

CREATE INDEX "AUTH_GROUP_GROUP_ID_B120CBF9" ON "AUTH_GROUP_PERMISSIONS" ("GROUP_ID");
CREATE INDEX "AUTH_GROUP_PERMISSION_84C5C92E" ON "AUTH_GROUP_PERMISSIONS" ("PERMISSION_ID");

CREATE SEQUENCE "AUTH_GROUP_PERMISSIONS_SEQ" 
    MINVALUE 1 
    MAXVALUE 999999999 
    START WITH 1 
    INCREMENT BY 1 
    CACHE 20;

CREATE OR REPLACE TRIGGER "AUTH_GROUP_PERMISSIONS_TR"
BEFORE INSERT ON "AUTH_GROUP_PERMISSIONS"
FOR EACH ROW
WHEN (new."ID" IS NULL) BEGIN
	SELECT "AUTH_GROUP_PERMISSIONS_SEQ".nextval
	INTO :new."ID" FROM dual;
END;

ALTER TRIGGER "AUTH_GROUP_PERMISSIONS_TR" ENABLE;


--DJANGO_MIGRATIONS
CREATE TABLE "DJANGO_MIGRATIONS"(
	"ID" NUMBER(11,0) NOT NULL ENABLE,
	"APP" NVARCHAR2(255),
	"NAME" NVARCHAR2(255),
	"APPLIED" TIMESTAMP (6) NOT NULL ENABLE,
	PRIMARY KEY ("ID")
);

CREATE SEQUENCE "DJANGO_MIGRATIONS_SEQ" 
    MINVALUE 1 
    MAXVALUE 999999999 
    START WITH 1 
    INCREMENT BY 1 
    CACHE 20;

CREATE OR REPLACE TRIGGER "DJANGO_MIGRATIONS_TR"
BEFORE INSERT ON "DJANGO_MIGRATIONS"
FOR EACH ROW
WHEN (new."ID" IS NULL) BEGIN
	SELECT "DJANGO_MIGRATIONS_SEQ".nextval
	INTO :new."ID" FROM dual;
END;

ALTER TRIGGER "DJANGO_MIGRATIONS_TR" ENABLE;


--DJANGO_SESSION
CREATE TABLE "DJANGO_SESSION"(
    "SESSION_KEY" NVARCHAR2(40) NOT NULL ENABLE,
	"SESSION_DATA" NCLOB,
	"EXPIRE_DATE" TIMESTAMP (6) NOT NULL ENABLE,
	PRIMARY KEY ("SESSION_KEY")
);

CREATE INDEX "DJANGO_SES_EXPIRE_DAT_A5C62663" ON "DJANGO_SESSION" ("EXPIRE_DATE");


--AUTH_USER
CREATE TABLE "AUTH_USER"(
	"ID" NUMBER(11,0) NOT NULL ENABLE,
	"PASSWORD" NVARCHAR2(128),
	"LAST_LOGIN" TIMESTAMP (6),
	"IS_SUPERUSER" NUMBER(1,0) NOT NULL ENABLE,
	"USERNAME" NVARCHAR2(150),
	"FIRST_NAME" NVARCHAR2(30),
	"LAST_NAME" NVARCHAR2(150),
	"EMAIL" NVARCHAR2(254),
	"IS_STAFF" NUMBER(1,0) NOT NULL ENABLE,
	"IS_ACTIVE" NUMBER(1,0) NOT NULL ENABLE,
	"DATE_JOINED" TIMESTAMP (6) NOT NULL ENABLE,
	CHECK ("IS_SUPERUSER" IN (0,1)) ENABLE,
	CHECK ("IS_STAFF" IN (0,1)) ENABLE,
	CHECK ("IS_ACTIVE" IN (0,1)) ENABLE,
	PRIMARY KEY ("ID"),
	UNIQUE ("USERNAME")
);

CREATE SEQUENCE "AUTH_USER_SEQ" 
    MINVALUE 1 
    MAXVALUE 999999999 
    START WITH 1 
    INCREMENT BY 1 
    CACHE 20;

CREATE OR REPLACE TRIGGER "AUTH_USER_TR"
BEFORE INSERT ON "AUTH_USER"
FOR EACH ROW
WHEN (new."ID" IS NULL) BEGIN
	SELECT "AUTH_USER_SEQ".nextval
	INTO :new."ID" FROM dual;
END;

ALTER TRIGGER "AUTH_USER_TR" ENABLE;


--DJANGO_ADMIN_LOG
CREATE TABLE "DJANGO_ADMIN_LOG"(
	"ID" NUMBER(11,0) NOT NULL ENABLE,
	"ACTION_TIME" TIMESTAMP (6) NOT NULL ENABLE,
	"OBJECT_ID" NCLOB,
	"OBJECT_REPR" NVARCHAR2(200),
	"ACTION_FLAG" NUMBER(11,0) NOT NULL ENABLE,
	"CHANGE_MESSAGE" NCLOB,
	"CONTENT_TYPE_ID" NUMBER(11,0),
	"USER_ID" NUMBER(11,0) NOT NULL ENABLE,
	CHECK ("ACTION_FLAG" >= 0) ENABLE,
	PRIMARY KEY ("ID"),
	CONSTRAINT "DJANGO_AD_CONTENT_T_C4BCE8EB_F" FOREIGN KEY ("CONTENT_TYPE_ID")
	    REFERENCES "DJANGO_CONTENT_TYPE" ("ID") DEFERRABLE INITIALLY DEFERRED ENABLE,
	CONSTRAINT "DJANGO_AD_USER_ID_C564EBA6_F" FOREIGN KEY ("USER_ID")
	    REFERENCES "AUTH_USER" ("ID") DEFERRABLE INITIALLY DEFERRED ENABLE
);

CREATE INDEX "DJANGO_ADM_CONTENT_TY_C4BCE8EB" ON "DJANGO_ADMIN_LOG" ("CONTENT_TYPE_ID");
CREATE INDEX "DJANGO_ADM_USER_ID_C564EBA6" ON "DJANGO_ADMIN_LOG" ("USER_ID");

CREATE SEQUENCE "DJANGO_ADMIN_LOG_SEQ" 
    MINVALUE 1 
    MAXVALUE 999999999 
    START WITH 1 
    INCREMENT BY 1 
    CACHE 20;

CREATE OR REPLACE TRIGGER "DJANGO_ADMIN_LOG_TR"
BEFORE INSERT ON "DJANGO_ADMIN_LOG"
FOR EACH ROW
WHEN (new."ID" IS NULL) BEGIN
	SELECT "DJANGO_ADMIN_LOG_SEQ".nextval
	INTO :new."ID" FROM dual;
END;

ALTER TRIGGER "DJANGO_ADMIN_LOG_TR" ENABLE;


--AUTH_USER_GROUPS
CREATE TABLE "AUTH_USER_GROUPS"(
	"ID" NUMBER(11,0) NOT NULL ENABLE,
	"USER_ID" NUMBER(11,0) NOT NULL ENABLE,
	"GROUP_ID" NUMBER(11,0) NOT NULL ENABLE,
	PRIMARY KEY ("ID"),
	CONSTRAINT "AUTH_USER_USER_ID_G_94350C0C_U" UNIQUE ("USER_ID", "GROUP_ID"),
	CONSTRAINT "AUTH_USER_USER_ID_6A12ED8B_F" FOREIGN KEY ("USER_ID")
	    REFERENCES "AUTH_USER" ("ID") DEFERRABLE INITIALLY DEFERRED ENABLE,
	CONSTRAINT "AUTH_USER_GROUP_ID_97559544_F" FOREIGN KEY ("GROUP_ID")
	    REFERENCES "AUTH_GROUP" ("ID") DEFERRABLE INITIALLY DEFERRED ENABLE
);

CREATE INDEX "AUTH_USER__USER_ID_6A12ED8B" ON "AUTH_USER_GROUPS" ("USER_ID");
CREATE INDEX "AUTH_USER__GROUP_ID_97559544" ON "AUTH_USER_GROUPS" ("GROUP_ID");

CREATE SEQUENCE "AUTH_USER_GROUPS_SEQ" 
    MINVALUE 1 
    MAXVALUE 999999999 
    START WITH 1 
    INCREMENT BY 1 
    CACHE 20;

CREATE OR REPLACE TRIGGER "AUTH_USER_GROUPS_TR"
BEFORE INSERT ON "AUTH_USER_GROUPS"
FOR EACH ROW
WHEN (new."ID" IS NULL) BEGIN
	SELECT "AUTH_USER_GROUPS_SEQ".nextval
	INTO :new."ID" FROM dual;
END;

ALTER TRIGGER "AUTH_USER_GROUPS_TR" ENABLE;


--AUTH_USER_USER_PERMISSIONS
CREATE TABLE "AUTH_USER_USER_PERMISSIONS"(
	"ID" NUMBER(11,0)  NOT NULL ENABLE,
	"USER_ID" NUMBER(11,0) NOT NULL ENABLE,
	"PERMISSION_ID" NUMBER(11,0) NOT NULL ENABLE,
	PRIMARY KEY ("ID"),
	CONSTRAINT "AUTH_USER_USER_ID_P_14A6B632_U" UNIQUE ("USER_ID", "PERMISSION_ID"),
	CONSTRAINT "AUTH_USER_USER_ID_A95EAD1B_F" FOREIGN KEY ("USER_ID")
	    REFERENCES "AUTH_USER" ("ID") DEFERRABLE INITIALLY DEFERRED ENABLE,
	CONSTRAINT "AUTH_USER_PERMISSIO_1FBB5F2C_F" FOREIGN KEY ("PERMISSION_ID")
	    REFERENCES "AUTH_PERMISSION" ("ID") DEFERRABLE INITIALLY DEFERRED ENABLE
);

CREATE INDEX "AUTH_USER__USER_ID_A95EAD1B" ON "AUTH_USER_USER_PERMISSIONS" ("USER_ID");
CREATE INDEX "AUTH_USER__PERMISSION_1FBB5F2C" ON "AUTH_USER_USER_PERMISSIONS" ("PERMISSION_ID");

CREATE SEQUENCE "AUTH_USER_USER_PERMISSIONS_SEQ" 
    MINVALUE 1 
    MAXVALUE 999999999 
    START WITH 1 
    INCREMENT BY 1 
    CACHE 20;

CREATE OR REPLACE TRIGGER "AUTH_USER_USER_PERMISSIONS_TR"
BEFORE INSERT ON "AUTH_USER_USER_PERMISSIONS"
FOR EACH ROW
WHEN (new."ID" IS NULL) BEGIN
	SELECT "AUTH_USER_USER_PERMISSIONS_SEQ".nextval
	INTO :new."ID" FROM dual;
END;

ALTER TRIGGER "AUTH_USER_USER_PERMISSIONS_TR" ENABLE;
