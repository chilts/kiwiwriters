BEGIN;

-- ----------------------------------------------------------------------------
-- base table

CREATE TABLE base (
    inserted        TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated         TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- functions

CREATE FUNCTION updated() RETURNS trigger as '
   BEGIN
      NEW.updated := CURRENT_TIMESTAMP;
      RETURN NEW;
   END;
' LANGUAGE plpgsql;

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
