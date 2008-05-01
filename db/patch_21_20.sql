BEGIN;

-- ----------------------------------------------------------------------------

-- table: token
DROP TABLE account.token;
DROP SEQUENCE account.token_id_seq;

-- ----------------------------------------------------------------------------

UPDATE property SET value = 20 WHERE key = 'Patch Level';

COMMIT;
