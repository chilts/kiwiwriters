BEGIN;

-- ----------------------------------------------------------------------------

-- create the Forum tables
\i /usr/share/zaapt/store/Pg/create_forum.sql

-- add BBCode as a common type
INSERT INTO common.type(name) VALUES('bbcode');

-- ----------------------------------------------------------------------------

UPDATE property SET value = 8 WHERE key = 'Patch Level';

COMMIT;
