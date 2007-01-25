BEGIN;

-- ----------------------------------------------------------------------------

-- create the Forum tables
\i /usr/share/kiwiwriters/db/zaapt/create_profile.sql

INSERT INTO profile.profile(account_id)
    SELECT id FROM account.account;

-- ----------------------------------------------------------------------------

UPDATE property SET value = 9 WHERE key = 'Patch Level';

COMMIT;
