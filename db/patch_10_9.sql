BEGIN;

-- ----------------------------------------------------------------------------

-- update the forum.tables to have the account information
CREATE TABLE forum.count (
    account_id      INTEGER NOT NULL REFERENCES account.account PRIMARY KEY,
    total           INTEGER NOT NULL DEFAULT 0,

    LIKE base       INCLUDING DEFAULTS
);

-- function: newtopic
CREATE OR REPLACE FUNCTION newtopic() RETURNS trigger as '
    BEGIN
        UPDATE forum.forum SET topics = topics + 1 WHERE id = NEW.forum_id;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
DROP TRIGGER newtopic_inserted ON forum.topic;
CREATE TRIGGER newtopic_inserted BEFORE INSERT ON forum.topic
    FOR EACH ROW EXECUTE PROCEDURE newtopic();

-- function: deltopic
CREATE OR REPLACE FUNCTION deltopic() RETURNS trigger as '
    BEGIN
        UPDATE forum.forum SET topics = topics - 1 WHERE id = OLD.forum_id;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
DROP TRIGGER deltopic_deleted ON forum.topic;
CREATE TRIGGER deltopic_deleted AFTER DELETE ON forum.topic
    FOR EACH ROW EXECUTE PROCEDURE deltopic();

-- function: newpost
CREATE OR REPLACE FUNCTION newpost() RETURNS trigger as '
    DECLARE
        -- to hold the account id of the person posting
        found_id INTEGER;
    BEGIN
        UPDATE forum.topic SET posts = posts + 1, poster_id = NEW.account_id WHERE id = NEW.topic_id;
        UPDATE forum.forum SET posts = posts + 1, poster_id = NEW.account_id WHERE id = (SELECT forum_id FROM forum.topic WHERE id = NEW.topic_id);

        -- now update this users number of posts
        SELECT INTO found_id account_id FROM forum.count WHERE account_id = NEW.account_id;
        IF NOT FOUND THEN
            INSERT INTO forum.count(account_id) VALUES(NEW.account_id);
            SELECT INTO found_id account_id FROM forum.count WHERE account_id = NEW.account_id;
        END IF;
        UPDATE forum.count SET total = total + 1 WHERE account_id = found_id;

        RETURN NEW;
    END;
' LANGUAGE plpgsql;
DROP TRIGGER newpost_inserted ON forum.post;
CREATE TRIGGER newpost_inserted BEFORE INSERT ON forum.post
    FOR EACH ROW EXECUTE PROCEDURE newpost();

-- function: delpost
CREATE OR REPLACE FUNCTION delpost() RETURNS trigger as '
    BEGIN
        UPDATE forum.topic SET posts = posts - 1 WHERE id = OLD.topic_id;
        UPDATE forum.forum SET posts = posts - 1 WHERE id = (SELECT forum_id FROM forum.topic WHERE id = OLD.topic_id);
        UPDATE forum.count SET total = total - 1 WHERE account_id = OLD.account_id;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;
DROP TRIGGER delpost_deleted ON forum.post;
CREATE TRIGGER delpost_deleted AFTER DELETE ON forum.post
    FOR EACH ROW EXECUTE PROCEDURE delpost();

-- copy across the current number of posts
INSERT INTO forum.count(account_id, total) SELECT account_id, posts FROM forum.info;

DROP TABLE forum.info CASCADE;

-- ----------------------------------------------------------------------------

UPDATE property SET value = 9 WHERE key = 'Patch Level';

COMMIT;
