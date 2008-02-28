BEGIN;

-- ----------------------------------------------------------------------------

-- give me some temporary permissions to make it easier
INSERT INTO account.role
    (name, description)
VALUES
    ('mega-super-user', 'Temporary role to give andy to do all the work.');

INSERT INTO account.pa(role_id, permission_id) SELECT (SELECT id FROM account.role WHERE name = 'mega-super-user'), id FROM account.permission;
INSERT INTO account.ra(account_id, role_id) VALUES((SELECT id FROM account.account WHERE username = 'andychilton'), (SELECT id FROM account.role WHERE name = 'mega-super-user'));

-- ----------------------------------------------------------------------------

UPDATE property SET value = 19 WHERE key = 'Patch Level';

COMMIT;
