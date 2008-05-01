BEGIN;

-- ----------------------------------------------------------------------------

DROP SCHEMA email CASCADE;

-- ----------------------------------------------------------------------------

UPDATE property SET value = 19 WHERE key = 'Patch Level';

COMMIT;
