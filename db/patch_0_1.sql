BEGIN;

-- ----------------------------------------------------------------------------

CREATE TABLE property (
    key   TEXT PRIMARY KEY,
    value TEXT
);

-- ----------------------------------------------------------------------------

INSERT INTO property(key, value) VALUES('Patch Level', 1);

COMMIT;
