BEGIN;

-- ----------------------------------------------------------------------------

\i /usr/share/kiwiwriters/db/zaapt/create_challenge.sql

-- ----------------------------------------------------------------------------

UPDATE property SET value = 12 WHERE key = 'Patch Level';

COMMIT;
