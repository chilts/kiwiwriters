BEGIN;

-- ----------------------------------------------------------------------------

-- create the Forum tables
\i /usr/share/kiwiwriters/db/zaapt/drop_profile.sql

-- ----------------------------------------------------------------------------

UPDATE property SET value = 8 WHERE key = 'Patch Level';

COMMIT;
