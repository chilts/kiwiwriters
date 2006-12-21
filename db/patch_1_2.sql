BEGIN;

-- ----------------------------------------------------------------------------
-- aggregates

CREATE FUNCTION append_text(TEXT, TEXT)
RETURNS TEXT AS '
    SELECT CASE WHEN $1 = '''' THEN
        $2
    ELSE
        $1 || '', '' || $2
    END;'
LANGUAGE 'sql' IMMUTABLE STRICT;

CREATE AGGREGATE list (
    BASETYPE = TEXT,
    SFUNC    = append_text,
    STYPE    = TEXT,
    INITCOND = ''
);

-- ----------------------------------------------------------------------------

UPDATE property SET value = 2 WHERE key = 'Patch Level';

COMMIT;
