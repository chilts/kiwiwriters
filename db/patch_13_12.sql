BEGIN;

-- ----------------------------------------------------------------------------

\i /usr/share/zaapt/store/Pg/drop_friend.sql

-- ----------------------------------------------------------------------------

UPDATE property SET value = 12 WHERE key = 'Patch Level';

COMMIT;
