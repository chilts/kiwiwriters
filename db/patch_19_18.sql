BEGIN;

-- ----------------------------------------------------------------------------

DELETE FROM account.ra;
DELETE FROM account.pa;
DELETE FROM account.role;

-- ----------------------------------------------------------------------------

UPDATE property SET value = 18 WHERE key = 'Patch Level';

COMMIT;
