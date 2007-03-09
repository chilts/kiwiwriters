BEGIN;

-- ----------------------------------------------------------------------------

-- drop the Menu
\i /usr/share/zaapt/store/Pg/drop_menu.sql

-- ----------------------------------------------------------------------------

UPDATE property SET value = 10 WHERE key = 'Patch Level';

COMMIT;
