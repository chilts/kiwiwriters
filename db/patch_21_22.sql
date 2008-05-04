BEGIN;

-- ----------------------------------------------------------------------------

-- remove the old email schema
DROP SCHEMA email CASCADE;

-- table: email
CREATE SEQUENCE account.email_id_seq;
CREATE TABLE account.email (
    id              INTEGER NOT NULL DEFAULT nextval('account.email_id_seq'::TEXT) PRIMARY KEY,
    subject         TEXT NOT NULL,
    text            TEXT NOT NULL,
    html            TEXT NOT NULL,
    type_id         INTEGER NOT NULL REFERENCES common.type,
    isbulk          BOOLEAN NOT NULL,

    LIKE base       INCLUDING DEFAULTS
);
CREATE TRIGGER email_updated BEFORE UPDATE ON account.email
    FOR EACH ROW EXECUTE PROCEDURE updated();

-- table: recipient
CREATE SEQUENCE account.recipient_id_seq;
CREATE TABLE account.recipient (
    id              INTEGER NOT NULL DEFAULT nextval('account.recipient_id_seq'::TEXT) PRIMARY KEY,
    email_id        INTEGER NOT NULL REFERENCES account.email,
    account_id      INTEGER NOT NULL REFERENCES account.account,
    issent          BOOLEAN NOT NULL DEFAULT False,
    iserror         BOOLEAN NOT NULL DEFAULT False,
    error           TEXT NOT NULL DEFAULT '',

    LIKE base       INCLUDING DEFAULTS
);
CREATE TRIGGER recipient_updated BEFORE UPDATE ON account.recipient
    FOR EACH ROW EXECUTE PROCEDURE updated();

-- table: info (info about each user: token, rejected)
CREATE SEQUENCE account.info_id_seq;
CREATE TABLE account.info (
    account_id      INTEGER NOT NULL REFERENCES account.account PRIMARY KEY,
    token           VARCHAR(32) NOT NULL,
    sent            INTEGER NOT NULL DEFAULT 0,
    failed          INTEGER NOT NULL DEFAULT 0,

    UNIQUE(token),
    LIKE base       INCLUDING DEFAULTS
);
CREATE TRIGGER info_updated BEFORE UPDATE ON account.info
    FOR EACH ROW EXECUTE PROCEDURE updated();

-- finally, add a setting for the 'account' model
INSERT INTO
    zaapt.setting(model_id, name, value)
VALUES (
    (SELECT id FROM zaapt.model WHERE name = 'account'),
    'location',
    ''
);        

-- ----------------------------------------------------------------------------

UPDATE property SET value = 22 WHERE key = 'Patch Level';

COMMIT;
