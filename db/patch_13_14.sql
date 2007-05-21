BEGIN;

-- ----------------------------------------------------------------------------

\i /usr/share/zaapt/store/Pg/create_message.sql

-- ----------------------------------------------------------------------------

UPDATE property SET value = 14 WHERE key = 'Patch Level';

COMMIT;
