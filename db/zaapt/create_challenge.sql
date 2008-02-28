-- ----------------------------------------------------------------------------

CREATE SCHEMA challenge;

-- table: challenge
CREATE SEQUENCE challenge.challenge_id_seq;
CREATE TABLE challenge.challenge (
    id              INTEGER NOT NULL DEFAULT nextval('challenge.challenge_id_seq'::TEXT) PRIMARY KEY,
    name            TEXT NOT NULL,
    title           TEXT NOT NULL,
    description     TEXT NOT NULL,
    admin_id        INTEGER NOT NULL REFERENCES account.role,
    view_id         INTEGER NOT NULL REFERENCES account.role,

    UNIQUE(name),
    LIKE base       INCLUDING DEFAULTS
);
CREATE TRIGGER challenge_updated BEFORE UPDATE ON challenge.challenge
    FOR EACH ROW EXECUTE PROCEDURE updated();

COMMENT ON COLUMN challenge.challenge.admin_id IS
    'Admin allows this account to delete it';
COMMENT ON COLUMN challenge.challenge.view_id IS
    'View allows this account to see the challenge details';

-- table: category
CREATE SEQUENCE challenge.category_id_seq;
CREATE TABLE challenge.category (
    id              INTEGER NOT NULL DEFAULT nextval('challenge.category_id_seq'::TEXT) PRIMARY KEY,
    title           TEXT NOT NULL,
    description     TEXT NOT NULL,
    isstandard      BOOLEAN NOT NULL DEFAULT False,
    unit            TEXT NOT NULL,
    units           TEXT NOT NULL,

    LIKE base       INCLUDING DEFAULTS
);
CREATE TRIGGER category_updated BEFORE UPDATE ON challenge.category
    FOR EACH ROW EXECUTE PROCEDURE updated();

COMMENT ON COLUMN challenge.category.unit IS
    'The singular unit, like \'word\' or \'hour\'.';
COMMENT ON COLUMN challenge.category.units IS
    'The plural units, like \'words\' or \'hours\'.';

-- table: event
CREATE SEQUENCE challenge.event_id_seq;
CREATE TABLE challenge.event (
    id              INTEGER NOT NULL DEFAULT nextval('challenge.event_id_seq'::TEXT) PRIMARY KEY,
    challenge_id    INTEGER NOT NULL REFERENCES challenge.challenge,
    category_id     INTEGER NOT NULL REFERENCES challenge.category,
    account_id      INTEGER NOT NULL REFERENCES account.account,
    name            TEXT NOT NULL,
    title           TEXT NOT NULL,
    description     TEXT NOT NULL,
    rules           TEXT NOT NULL,
    goal            INTEGER NOT NULL,
    startts         TIMESTAMP WITH TIME ZONE NOT NULL,
    endts           TIMESTAMP WITH TIME ZONE NOT NULL,

    UNIQUE(name),
    LIKE base       INCLUDING DEFAULTS
);
CREATE TRIGGER event_updated BEFORE UPDATE ON challenge.event
    FOR EACH ROW EXECUTE PROCEDURE updated();

COMMENT ON COLUMN challenge.event.account_id IS
    'The person who created the challenge.';
COMMENT ON COLUMN challenge.event.name IS
    'This is unique since we don\'t want the same name being used across challenges. e.g. someone making a member event with the same name as a site event.';

-- table: participant
CREATE SEQUENCE challenge.participant_id_seq;
CREATE TABLE challenge.participant (
    id              INTEGER NOT NULL DEFAULT nextval('challenge.participant_id_seq'::TEXT) PRIMARY KEY,
    event_id        INTEGER NOT NULL REFERENCES challenge.event,
    account_id      INTEGER NOT NULL,
    progress        INTEGER NOT NULL DEFAULT 0,

    UNIQUE(event_id, account_id),
    LIKE base       INCLUDING DEFAULTS
);
CREATE TRIGGER participant_updated BEFORE UPDATE ON challenge.participant
    FOR EACH ROW EXECUTE PROCEDURE updated();

COMMENT ON COLUMN challenge.participant.progress IS
    'The progress in terms of words, hours, pages, scenes, whatever...';

-- table: progress
CREATE SEQUENCE challenge.progress_id_seq;
CREATE TABLE challenge.progress (
    id              INTEGER NOT NULL DEFAULT nextval('challenge.progress_id_seq'::TEXT) PRIMARY KEY,
    participant_id  INTEGER NOT NULL REFERENCES challenge.participant,
    date            DATE NOT NULL,
    progress        INTEGER NOT NULL,

    UNIQUE(participant_id, date),
    LIKE base       INCLUDING DEFAULTS
);
CREATE TRIGGER progress_updated BEFORE UPDATE ON challenge.progress
    FOR EACH ROW EXECUTE PROCEDURE updated();

INSERT INTO zaapt.model(name, title, module) VALUES('challenge', 'Challenge', 'KiwiWriters::Zaapt::Store::Pg::Challenge');

-- ----------------------------------------------------------------------------
