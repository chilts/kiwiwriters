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

## ----------------------------------------------------------------------------
# constants

my $sql = {
    fix_profile => "
INSERT INTO
    challenge.info
SELECT
    a.id, (SELECT id FROM challenge.timezone WHERE name = 'Pacific/Auckland')
FROM
    account.account a
    LEFT JOIN challenge.info i ON (a.id = i.account_id)
WHERE
    i.account_id IS NULL
ORDER BY
    a.id
;
    ",
};

## ----------------------------------------------------------------------------
# setup

# get the logger
my $logger = get_logger();
$logger->level( $INFO );

# pick a layout
my $layout = Log::Log4perl::Layout::PatternLayout->new( "%d %p %F{1}[%5L] %m%n" );

# choose and setup the appender
my $appender = Log::Log4perl::Appender->new(
    "Log::Dispatch::File",
    filename => "/var/log/kiwiwriters/kw-fix-profile.log",
    mode     => "append",
);
$appender->layout( $layout );
$logger->add_appender( $appender );

## ----------------------------------------------------------------------------
# main program

MAIN: {
    $logger->info("$0: started");

    my $cfg = {};
    Config::Simple->import_from('/etc/kiwiwriters/kiwiwriters.cfg', $cfg);

    my $dbh =  DBI->connect(
        "dbi:Pg:dbname=$cfg->{db_name}",
        $cfg->{db_user},
        undef,
        { RaiseError => 1, AutoCommit => 1, PrintError => 1 }
    );

    die "Couldn't connect to database"
        unless defined $dbh;

    $logger->debug("got database handle");

    $dbh->begin_work();

    # set to this timezone
    my $count = $dbh->do( $sql->{fix_profile} );
    $logger->info("Query affected $count " . ($count == 1 ? 'row' : 'rows'));

    $dbh->commit();

    $logger->info("$0: finished");
    $logger->debug(' ');
}

## ----------------------------------------------------------------------------
