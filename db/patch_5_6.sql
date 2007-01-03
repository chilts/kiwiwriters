BEGIN;

-- ----------------------------------------------------------------------------

-- create the Blog tables
\i /usr/share/zaapt/store/Pg/create_blog.sql

-- ----------------------------------------------------------------------------

UPDATE property SET value = 6 WHERE key = 'Patch Level';

COMMIT;
