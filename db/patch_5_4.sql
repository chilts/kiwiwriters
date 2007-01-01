BEGIN;

-- ----------------------------------------------------------------------------

-- reverse the patch
\i /usr/share/zaapt/store/Pg/drop_faq.sql
\i /usr/share/zaapt/store/Pg/drop_common.sql

-- ----------------------------------------------------------------------------

UPDATE property SET value = 4 WHERE key = 'Patch Level';

COMMIT;
