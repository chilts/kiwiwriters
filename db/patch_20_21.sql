BEGIN;

-- ----------------------------------------------------------------------------

-- table: token
CREATE SEQUENCE account.token_id_seq;
CREATE TABLE account.token (
    id              INTEGER NOT NULL DEFAULT nextval('account.token_id_seq'::TEXT) PRIMARY KEY,
    account_id      INTEGER NOT NULL REFERENCES account.account,
    code            VARCHAR(32) NOT NULL,

    UNIQUE(code),
    LIKE base       INCLUDING DEFAULTS
);
CREATE TRIGGER token_updated BEFORE UPDATE ON account.token
    FOR EACH ROW EXECUTE PROCEDURE updated();

-- ----------------------------------------------------------------------------

UPDATE property SET value = 21 WHERE key = 'Patch Level';

COMMIT;
