BEGIN;

-- ----------------------------------------------------------------------------

DROP AGGREGATE list(TEXT);
DROP FUNCTION append_text(TEXT, TEXT);

-- ----------------------------------------------------------------------------

UPDATE property SET value = 1 WHERE key = 'Patch Level';

COMMIT;
