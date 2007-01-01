BEGIN;

-- ----------------------------------------------------------------------------

-- add common stuff
\i /usr/share/zaapt/store/Pg/create_common.sql
INSERT INTO common.type(name) VALUES('phliky');

-- create the FAQ tables
\i /usr/share/zaapt/store/Pg/create_faq.sql

-- ----------------------------------------------------------------------------

UPDATE property SET value = 5 WHERE key = 'Patch Level';

COMMIT;
