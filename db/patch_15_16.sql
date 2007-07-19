BEGIN;

-- ----------------------------------------------------------------------------

-- table: challenge.info
CREATE TABLE challenge.info (
    account_id      INTEGER NOT NULL REFERENCES account.account PRIMARY KEY,
    timezone_id     INTEGER NOT NULL REFERENCES challenge.timezone,

    LIKE base       INCLUDING DEFAULTS
);

-- fill the table up with account ids and default to 'Pacific/Auckland' time zone
INSERT INTO challenge.info
    SELECT
        account.id,
        (SELECT id FROM challenge.timezone WHERE name = 'Pacific/Auckland' )
    FROM
        account.account
    ;

-- ----------------------------------------------------------------------------

UPDATE property SET value = 16 WHERE key = 'Patch Level';

COMMIT;
