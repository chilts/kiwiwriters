BEGIN;

-- ----------------------------------------------------------------------------

-- get the 'base' table and the 'updated' function from zaapt

-- \i /usr/share/zaapt/store/Pg/create_zaapt.sql
-- \i /usr/share/zaapt/store/Pg/create_account.sql
-- \i /usr/share/zaapt/store/Pg/create_content.sql
\i /home/andy/svn/google/zaapt/trunk/store/Pg/create_zaapt.sql
\i /home/andy/svn/google/zaapt/trunk/store/Pg/create_account.sql
\i /home/andy/svn/google/zaapt/trunk/store/Pg/create_content.sql

-- ----------------------------------------------------------------------------

-- allow using Phliky as the page markup
INSERT INTO content.type(name) VALUES('phliky');

-- ----------------------------------------------------------------------------

UPDATE property SET value = 3 WHERE key = 'Patch Level';

COMMIT;
