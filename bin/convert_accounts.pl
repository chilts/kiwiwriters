#!/usr/bin/perl
## ----------------------------------------------------------------------------

use strict;
use warnings;

use Data::Dumper;
use Config::Simple;
use DBI;

use File::Slurp qw(read_file);
use Log::Log4perl qw(get_logger :levels);

use Zaapt;

my $dbname = 'kiwiwriters';

my $tables = {
    'blog.blog' => { cols => [ qw( admin_id view_id edit_id publish_id comment_id trackback_id ) ] },
    'content.content' => { cols => [ qw( admin_id view_id edit_id publish_id ) ] },
    # 'dir.dir' => { cols => [ qw( admin_id view_id edit_id ) ] },
    'faq.faq' => { cols => [ qw( admin_id view_id edit_id ) ] },
    'forum.forum' => { cols => [ qw( admin_id view_id moderator_id ) ] },
    # 'gallery.gallery' => { cols => [ qw( admin_id view_id edit_id ) ] },
    'menu.menu' => { cols => [ qw( admin_id view_id edit_id ) ] },
    'news.news' => { cols => [ qw( admin_id view_id edit_id publish_id ) ] },
    'challenge.challenge' => { cols => [ qw( admin_id view_id ) ] },
    # 'profile.profile' => { cols => [ qw( admin_id view_id edit_id ) ] },
    # 'complex.complex' => { cols => [ qw( admin_id view_id edit_id ) ] },
};

## ----------------------------------------------------------------------------
# setup

# get the logger
my $logger = get_logger();
# $logger->level( $INFO );
$logger->level( $DEBUG );

# pick a layout
my $layout = Log::Log4perl::Layout::PatternLayout->new( "%d %p %F{1}[%5L] %m%n" );

# choose and setup the appender
my $appender = Log::Log4perl::Appender->new( "Log::Dispatch::Screen" );
$appender->layout( $layout );
$logger->add_appender( $appender );

## ----------------------------------------------------------------------------

MAIN: {
    $logger->debug('-' x 79);
    $logger->info("$0: started");

    my $dbh =  DBI->connect(
        "dbi:Pg:dbname=$dbname",
        $dbname,
        undef,
        { RaiseError => 1, AutoCommit => 1, PrintError => 1 }
    );

    die "Couldn't connect to database"
        unless defined $dbh;

    $logger->debug("got database handle");

    $dbh->begin_work();

    # read all the current roles (since these will be the new permissions)
    my $old_roles = rows( $dbh, "SELECT id, name, description FROM account.role" );
    $logger->debug("Old Roles:");
    my %old_roles;
    foreach ( @$old_roles ) {
        $logger->debug(" - ($_->{id}) $_->{name}");
        $old_roles{$_->{id}} = $_->{name};
    }

    # read all the current privileges - these will be mapped through to the accounts
    my $old_privileges = rows( $dbh, "SELECT id, account_id, role_id FROM account.privilege" );
    $logger->debug("Old Privileges:");
    foreach ( @$old_privileges ) {
        $logger->debug(" - $_->{account_id} has $_->{role_id} ($old_roles{$_->{role_id}})");
    }

    # read what each table needs for each column
    foreach my $table ( keys %$tables ) {
        $logger->debug("reading table: $table");
        $tables->{$table}{rows} = rows($dbh, "SELECT id, " . join(', ', @{$tables->{$table}{cols}}) . " FROM $table");
    }
    # print Dumper($tables);

    # remove the dependencies on the old role table
    foreach my $table ( keys %$tables ) {
        $logger->info( "Doing table: $table" );
        foreach my $col ( @{$tables->{$table}{cols}} ) {
            $logger->info( " - $col" );
            doit($dbh, "ALTER TABLE $table DROP COLUMN $col");
        }
    }

    # remove the old tables
    $logger->info( doit($dbh, "DROP TABLE account.privilege") );
    $logger->info( doit($dbh, "DROP SEQUENCE account.privilege_id_seq") );
    $logger->info( doit($dbh, "DROP TABLE account.role") );
    $logger->info( doit($dbh, "DROP SEQUENCE account.role_id_seq") );

    # add the new tables
    my $sql = <<'EOF';
CREATE SEQUENCE account.role_id_seq;
CREATE TABLE account.role (
    id              INTEGER NOT NULL DEFAULT nextval('account.role_id_seq'::TEXT) PRIMARY KEY,
    name            TEXT NOT NULL,
    description     TEXT NOT NULL,

    UNIQUE(name),
    LIKE base       INCLUDING DEFAULTS
);
CREATE TRIGGER role_updated BEFORE UPDATE ON account.role
    FOR EACH ROW EXECUTE PROCEDURE updated();

-- table: permission
CREATE SEQUENCE account.permission_id_seq;
CREATE TABLE account.permission (
    id              INTEGER NOT NULL DEFAULT nextval('account.permission_id_seq'::TEXT) PRIMARY KEY,
    name            TEXT NOT NULL,
    description     TEXT NOT NULL,

    UNIQUE(name),
    LIKE base       INCLUDING DEFAULTS
);
CREATE TRIGGER permission_updated BEFORE UPDATE ON account.permission
    FOR EACH ROW EXECUTE PROCEDURE updated();

-- table: ra - role assignment (read: which account has which role)
-- Note: in most RBAC articles, this is named the 'user assignment' table)
CREATE SEQUENCE account.ra_id_seq;
CREATE TABLE account.ra (
    id              INTEGER NOT NULL DEFAULT nextval('account.ra_id_seq'::TEXT) PRIMARY KEY,
    account_id      INTEGER NOT NULL REFERENCES account.account,
    role_id         INTEGER NOT NULL REFERENCES account.role,

    UNIQUE(account_id, role_id),
    LIKE base       INCLUDING DEFAULTS
);
CREATE TRIGGER required_updated BEFORE UPDATE ON account.ra
    FOR EACH ROW EXECUTE PROCEDURE updated();

-- table: pa - permission assignment (read: which role has which permission)
CREATE SEQUENCE account.pa_id_seq;
CREATE TABLE account.pa (
    id              INTEGER NOT NULL DEFAULT nextval('account.pa_id_seq'::TEXT) PRIMARY KEY,
    role_id         INTEGER NOT NULL REFERENCES account.role,
    permission_id   INTEGER NOT NULL REFERENCES account.permission,

    UNIQUE(role_id, permission_id),
    LIKE base       INCLUDING DEFAULTS
);
CREATE TRIGGER required_updated BEFORE UPDATE ON account.pa
    FOR EACH ROW EXECUTE PROCEDURE updated();
EOF

    doit($dbh, $sql);

    # add the permissions back in
    my $max_p_id = 0;
    foreach my $p ( @$old_roles ) {
        $logger->info("Inserting: ($p->{id}) $p->{name}");
        doit( $dbh, "INSERT INTO account.permission(id, name, description) VALUES(?, ?, ?)", $p->{id}, $p->{name}, $p->{description} );
        $max_p_id = ( $max_p_id < $p->{id} ? $p->{id} : $max_p_id );
    }
    $max_p_id++;
    $logger->info("Setting the sequence...");
    doit($dbh, "ALTER SEQUENCE account.permission_id_seq RESTART WITH $max_p_id");

    # add all those columns back in
    foreach my $table ( keys %$tables ) {
        $logger->info( "Doing table: $table" );
        foreach my $col ( @{$tables->{$table}{cols}} ) {
            $logger->info( " - $col" );
            $logger->info( doit($dbh, "ALTER TABLE $table ADD COLUMN $col INTEGER REFERENCES account.permission") );

            # for each of the rows we had earlier
            foreach my $row ( @{$tables->{$table}{rows}} ) {
                $logger->info( doit($dbh, "UPDATE $table SET $col = ? WHERE id = ?", $row->{$col}, $row->{id}) );
            }

            $logger->info( doit($dbh, "ALTER TABLE $table ALTER COLUMN $col SET NOT NULL") );
        }
    }


    # $dbh->rollback();
    $dbh->commit();

    $logger->info("$0: finished");
    $logger->debug('=' x 79);
}

## ----------------------------------------------------------------------------
# subs

sub doit {
    my ($dbh, $stm, @bind_values) = @_;
    $dbh->do($stm, undef, @bind_values);
}

sub row {
    my ($dbh, $stm, @bind_values) = @_;
    return $dbh->selectrow_hashref($stm, @bind_values);
}

sub rows {
    my ($dbh, $stm, @bind_values) = @_;
    my $sth = $dbh->prepare( $stm );
    my @rows;
    $sth->execute( @bind_values );
    while ( my $row = $sth->fetchrow_hashref() ) {
        push @rows, $row;
    }
    $sth->finish();
    return \@rows;
}


## ----------------------------------------------------------------------------
