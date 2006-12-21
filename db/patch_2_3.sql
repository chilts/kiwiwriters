BEGIN;

-- ----------------------------------------------------------------------------

-- get the 'base' table and the 'updated' function from zaapt

-- \i /usr/share/zaapt/store/Pg/create_zaapt.sql
-- \i /usr/share/zaapt/store/Pg/create_account.sql
-- \i /usr/share/zaapt/store/Pg/create_content.sql
\i /home/andy/svn/google/zaapt/trunk/store/Pg/create_zaapt.sql
\i /home/andy/svn/google/zaapt/trunk/store/Pg/create_account.sql
\i /home/andy/svn/google/zaapt/trunk/store/Pg/create_content.sql

-- ----------------------------------------------------------------------------

-- insert an initial user
INSERT INTO account.account(username, firstname, lastname, email, salt, password, admin)
    VALUES('andy', 'Andrew', 'Chilton', 'andychilton@gmail.com', 'Ya1t', md5('Ya1t' || 'password'), True);

-- add an editor role, this will have overall admin privileges on the whole site
INSERT INTO account.role(name, description)
    VALUES('editor', 'This will be the overall editor of the whole site.');

INSERT INTO account.privilege(account_id, role_id)
    VALUES(currval('account.account_id_seq'), currval('account.role_id_seq'));

-- ----------------------------------------------------------------------------

-- allow using Phliky as the page markup
INSERT INTO content.type(tid) VALUES('phliky');

-- ----------------------------------------------------------------------------

UPDATE property SET value = 3 WHERE key = 'Patch Level';

COMMIT;
