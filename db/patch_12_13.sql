BEGIN;

-- ----------------------------------------------------------------------------

\i /usr/share/zaapt/store/Pg/create_friend.sql

-- ----------------------------------------------------------------------------

UPDATE property SET value = 13 WHERE key = 'Patch Level';

COMMIT;
