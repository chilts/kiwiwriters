-- ----------------------------------------------------------------------------

CREATE SCHEMA profile;

-- table: profile
CREATE TABLE profile.profile (
    account_id      INTEGER NOT NULL REFERENCES account.account PRIMARY KEY,
    age             INTEGER NOT NULL DEFAULT 0,
    location        VARCHAR(255) NOT NULL DEFAULT '',
    website         VARCHAR(255) NOT NULL DEFAULT '',
    favauthors      TEXT NOT NULL DEFAULT '',
    favbooks        TEXT NOT NULL DEFAULT '',
    signature       TEXT NOT NULL DEFAULT '',

    LIKE base       INCLUDING DEFAULTS
);
CREATE TRIGGER profile_updated BEFORE UPDATE ON profile.profile
    FOR EACH ROW EXECUTE PROCEDURE updated();

-- ----------------------------------------------------------------------------
