BEGIN;

-- ----------------------------------------------------------------------------
-- session stuff for when we need it

CREATE TABLE session (
    id              CHAR(32) NOT NULL PRIMARY KEY,
    a_session       TEXT,

    LIKE base       INCLUDING DEFAULTS
);
CREATE TRIGGER session_updated BEFORE UPDATE ON session
    FOR EACH ROW EXECUTE PROCEDURE updated();

-- ----------------------------------------------------------------------------

UPDATE property SET value = 4 WHERE key = 'Patch Level';

COMMIT;
