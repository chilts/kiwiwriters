BEGIN;

-- ----------------------------------------------------------------------------

-- \i /usr/share/zaapt/store/Pg/drop_content.sql
-- \i /usr/share/zaapt/store/Pg/drop_account.sql
-- \i /usr/share/zaapt/store/Pg/drop_zaapt.sql
\i /home/andy/svn/google/zaapt/trunk/store/Pg/drop_content.sql
\i /home/andy/svn/google/zaapt/trunk/store/Pg/drop_account.sql
\i /home/andy/svn/google/zaapt/trunk/store/Pg/drop_zaapt.sql

-- ----------------------------------------------------------------------------

UPDATE property SET value = 2 WHERE key = 'Patch Level';

COMMIT;
