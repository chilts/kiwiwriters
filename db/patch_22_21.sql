BEGIN;

-- ----------------------------------------------------------------------------

-- remove any settings this model has
DELETE FROM zaapt.setting WHERE model_id IN (SELECT id FROM zaapt.model WHERE name = 'account');

-- reverse the account.email tables
DROP TABLE account.info;
DROP SEQUENCE account.info_id_seq;
DROP TABLE account.recipient;
DROP SEQUENCE account.recipient_id_seq;
DROP TABLE account.email;
DROP SEQUENCE account.email_id_seq;

-- and put the never-used email ones back
-- table: email
CREATE SEQUENCE email.email_id_seq;
CREATE TABLE email.email (
    id              INTEGER NOT NULL DEFAULT nextval('email.email_id_seq'::TEXT) PRIMARY KEY,
    subject         TEXT NOT NULL,
    text            TEXT NOT NULL,
    html            TEXT NOT NULL,
    type_id         INTEGER NOT NULL REFERENCES common.type,

    LIKE base       INCLUDING DEFAULTS
);
CREATE TRIGGER email_updated BEFORE UPDATE ON email.email
    FOR EACH ROW EXECUTE PROCEDURE updated();

-- table: recipient
CREATE SEQUENCE email.recipient_id_seq;
CREATE TABLE email.recipient (
    id              INTEGER NOT NULL DEFAULT nextval('email.recipient_id_seq'::TEXT) PRIMARY KEY,
    email_id        INTEGER NOT NULL REFERENCES email.email,
    account_id      INTEGER NOT NULL REFERENCES account.account,
    issent          BOOLEAN NOT NULL DEFAULT False,
    iserror         BOOLEAN NOT NULL DEFAULT False,
    error           TEXT NOT NULL DEFAULT '',

    LIKE base       INCLUDING DEFAULTS
);
CREATE TRIGGER recipient_updated BEFORE UPDATE ON email.recipient
    FOR EACH ROW EXECUTE PROCEDURE updated();

-- table: info (info about each user: token, rejected)
CREATE SEQUENCE email.info_id_seq;
CREATE TABLE email.info (
    account_id      INTEGER NOT NULL REFERENCES account.account PRIMARY KEY,
    token           VARCHAR(32) NOT NULL,
    sent            INTEGER NOT NULL DEFAULT 0,
    failed          INTEGER NOT NULL DEFAULT 0,

    UNIQUE(token),
    LIKE base       INCLUDING DEFAULTS
);
CREATE TRIGGER info_updated BEFORE UPDATE ON email.info
    FOR EACH ROW EXECUTE PROCEDURE updated();

-- ----------------------------------------------------------------------------

UPDATE property SET value = 21 WHERE key = 'Patch Level';

COMMIT;
