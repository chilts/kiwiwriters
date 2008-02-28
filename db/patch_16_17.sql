BEGIN;

-- ----------------------------------------------------------------------------

-- drop the old session table
DROP TABLE session;

-- replace with the new session schema (from create_session.sql)
CREATE SCHEMA session;

CREATE TABLE session.session (
    id              CHAR(32) NOT NULL PRIMARY KEY,
    a_session       TEXT,

    LIKE base       INCLUDING DEFAULTS
);
CREATE TRIGGER session_updated BEFORE UPDATE ON session.session
    FOR EACH ROW EXECUTE PROCEDURE updated();

-- now for the main Zaapt config
CREATE SCHEMA zaapt;

-- table: model
CREATE SEQUENCE zaapt.model_id_seq;
CREATE TABLE zaapt.model (
    id              INTEGER NOT NULL DEFAULT nextval('zaapt.model_id_seq'::TEXT) PRIMARY KEY,
    name            TEXT NOT NULL, -- like 'blog', 'news' and 'faq'
    title           TEXT NOT NULL, -- like 'Blog', 'News' and 'FAQ'
    module          TEXT, -- undef or like 'KiwiWriters::Zaapt::Store::Pg::Challenge'

    UNIQUE(name),
    LIKE base       INCLUDING DEFAULTS
);
CREATE TRIGGER model_updated BEFORE UPDATE ON zaapt.model
    FOR EACH ROW EXECUTE PROCEDURE updated();

-- table: setting
CREATE SEQUENCE zaapt.setting_id_seq;
CREATE TABLE zaapt.setting (
    id              INTEGER NOT NULL DEFAULT nextval('zaapt.setting_id_seq'::TEXT) PRIMARY KEY,
    model_id        INTEGER NOT NULL REFERENCES zaapt.model,
    name            TEXT NOT NULL,
    value           TEXT NOT NULL,

    UNIQUE(model_id, name),
    LIKE base       INCLUDING DEFAULTS
);
CREATE TRIGGER setting_updated BEFORE UPDATE ON zaapt.setting
    FOR EACH ROW EXECUTE PROCEDURE updated();

-- we now we need to tell zaapt of itself and all the others
INSERT INTO zaapt.model(name, title, module) VALUES('zaapt', 'Zaapt', 'Zaapt::Store::Pg::Zaapt');
INSERT INTO zaapt.model(name, title, module) VALUES('account', 'Account', 'Zaapt::Store::Pg::Account');
INSERT INTO zaapt.model(name, title, module) VALUES('blog', 'Blog', 'Zaapt::Store::Pg::Blog');
INSERT INTO zaapt.model(name, title, module) VALUES('common', 'Common', 'Zaapt::Store::Pg::Common');
INSERT INTO zaapt.model(name, title, module) VALUES('content', 'Content', 'Zaapt::Store::Pg::Content');
INSERT INTO zaapt.model(name, title, module) VALUES('faq', 'Faq', 'Zaapt::Store::Pg::Faq');
INSERT INTO zaapt.model(name, title, module) VALUES('forum', 'Forum', 'Zaapt::Store::Pg::Forum');
INSERT INTO zaapt.model(name, title, module) VALUES('friend', 'Friend', 'Zaapt::Store::Pg::Friend');
INSERT INTO zaapt.model(name, title, module) VALUES('menu', 'Menu', 'Zaapt::Store::Pg::Menu');
INSERT INTO zaapt.model(name, title, module) VALUES('message', 'Message', 'Zaapt::Store::Pg::Message');
INSERT INTO zaapt.model(name, title, module) VALUES('news', 'News', 'Zaapt::Store::Pg::News');
INSERT INTO zaapt.model(name, title, module) VALUES('session', 'Session', 'Zaapt::Store::Pg::Session');

-- and our custom ones
INSERT INTO zaapt.model(name, title, module) VALUES('challenge', 'Challenge', 'KiwiWriters::Zaapt::Store::Pg::Challenge');
INSERT INTO zaapt.model(name, title, module) VALUES('profile', 'Profile', 'KiwiWriters::Zaapt::Store::Pg::Profile');

-- ----------------------------------------------------------------------------

UPDATE property SET value = 17 WHERE key = 'Patch Level';

COMMIT;
