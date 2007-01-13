BEGIN;

-- ----------------------------------------------------------------------------

-- don't need to remove bbcode from the common types

-- drop the Forum tables
\i /usr/share/zaapt/store/Pg/drop_forum.sql

-- ----------------------------------------------------------------------------

UPDATE property SET value = 8 WHERE key = 'Patch Level';

COMMIT;
