BEGIN;

-- ----------------------------------------------------------------------------

-- create the News tables
\i /usr/share/zaapt/store/Pg/create_news.sql

-- ----------------------------------------------------------------------------

UPDATE property SET value = 7 WHERE key = 'Patch Level';

COMMIT;
