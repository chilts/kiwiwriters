BEGIN;

-- ----------------------------------------------------------------------------

\i /usr/share/kiwiwriters/db/zaapt/drop_challenge.sql

-- ----------------------------------------------------------------------------

UPDATE property SET value = 11 WHERE key = 'Patch Level';

COMMIT;
