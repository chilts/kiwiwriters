BEGIN;

-- ----------------------------------------------------------------------------

-- drop the News schema
\i /usr/share/zaapt/store/Pg/drop_news.sql

-- ----------------------------------------------------------------------------

UPDATE property SET value = 6 WHERE key = 'Patch Level';

COMMIT;
