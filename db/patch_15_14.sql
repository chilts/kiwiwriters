BEGIN;

-- ----------------------------------------------------------------------------

-- remove the challenge.timezone table and sequence
DROP TABLE challenge.timezone;
DROP SEQUENCE challenge.timezone_id_seq;

-- alter the challenge.event to have the times WITH time zone again
-- for start
ALTER TABLE challenge.event ADD COLUMN tmp_startts TIMESTAMP WITH TIME ZONE;
UPDATE challenge.event SET tmp_startts = startts;
ALTER TABLE challenge.event DROP COLUMN startts;
ALTER TABLE challenge.event ADD COLUMN startts TIMESTAMP WITH TIME ZONE;
UPDATE challenge.event SET startts = tmp_startts;
ALTER TABLE challenge.event ALTER COLUMN startts SET NOT NULL;
ALTER TABLE challenge.event DROP COLUMN tmp_startts;

-- for end
ALTER TABLE challenge.event ADD COLUMN tmp_endts TIMESTAMP WITH TIME ZONE;
UPDATE challenge.event SET tmp_endts = endts;
ALTER TABLE challenge.event DROP COLUMN endts;
ALTER TABLE challenge.event ADD COLUMN endts TIMESTAMP WITH TIME ZONE;
UPDATE challenge.event SET endts = tmp_endts;
ALTER TABLE challenge.event ALTER COLUMN endts SET NOT NULL;
ALTER TABLE challenge.event DROP COLUMN tmp_endts;

-- ----------------------------------------------------------------------------

UPDATE property SET value = 14 WHERE key = 'Patch Level';

COMMIT;
