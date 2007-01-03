BEGIN;

-- ----------------------------------------------------------------------------

-- drop the Blog schema
\i /usr/share/zaapt/store/Pg/drop_blog.sql

-- ----------------------------------------------------------------------------

UPDATE property SET value = 5 WHERE key = 'Patch Level';

COMMIT;
