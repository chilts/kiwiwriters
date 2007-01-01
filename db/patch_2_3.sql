BEGIN;

-- ----------------------------------------------------------------------------

-- create the Zaapt tables
\i /usr/share/zaapt/store/Pg/create_zaapt.sql
\i /usr/share/zaapt/store/Pg/create_account.sql
\i /usr/share/zaapt/store/Pg/create_content.sql

-- ----------------------------------------------------------------------------

-- allow using Phliky as the page markup
INSERT INTO content.type(name) VALUES('phliky');

-- ----------------------------------------------------------------------------

UPDATE property SET value = 3 WHERE key = 'Patch Level';

COMMIT;
