BEGIN;

-- ----------------------------------------------------------------------------

DROP TABLE challenge.info;

-- ----------------------------------------------------------------------------

UPDATE property SET value = 15 WHERE key = 'Patch Level';

COMMIT;
