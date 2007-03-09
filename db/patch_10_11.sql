BEGIN;

-- ----------------------------------------------------------------------------

-- create the Menu
\i /usr/share/zaapt/store/Pg/create_menu.sql

-- ----------------------------------------------------------------------------

UPDATE property SET value = 11 WHERE key = 'Patch Level';

COMMIT;
