BEGIN;

-- ----------------------------------------------------------------------------

-- get rid of the new zaapt model stuff
DROP SCHEMA zaapt CASCADE;

-- drop the new session schema
DROP SCHEMA session CASCADE;

-- replace the old session table
CREATE TABLE session (
    id              CHAR(32) NOT NULL PRIMARY KEY,
    a_session       TEXT,

    LIKE base       INCLUDING DEFAULTS
);
CREATE TRIGGER session_updated BEFORE UPDATE ON session
    FOR EACH ROW EXECUTE PROCEDURE updated();

-- ----------------------------------------------------------------------------

UPDATE property SET value = 17 WHERE key = 'Patch Level';

COMMIT;
