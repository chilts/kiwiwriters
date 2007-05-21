BEGIN;

-- ----------------------------------------------------------------------------

\i /usr/share/zaapt/store/Pg/drop_message.sql

-- ----------------------------------------------------------------------------

UPDATE property SET value = 13 WHERE key = 'Patch Level';

COMMIT;
