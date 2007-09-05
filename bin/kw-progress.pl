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
    sel_past_midnight => "
        SELECT
            CASE WHEN
                CURRENT_TIMESTAMP >= CURRENT_DATE::TIMESTAMP
            AND
                CURRENT_TIMESTAMP < CURRENT_DATE + '15 mins'::INTERVAL
            THEN
                1
            ELSE
                0
            END AS yes
    ",
};

my $log_conf = <<'EOF';


EOF

## ----------------------------------------------------------------------------
# setup

# get the logger
my $logger = get_logger();
$logger->level( $INFO );

# pick a layout
my $layout = Log::Log4perl::Layout::PatternLayout->new( "%d %p %F{1}[%5L] %m%n" );

# choose and setup the appender
my $appender;
if ( 1 ) {
    $appender = Log::Log4perl::Appender->new(
        "Log::Dispatch::File",
        filename => "/var/log/kiwiwriters/kw-progress.log",
        mode     => "append",
    );
}
else {
    $appender = Log::Log4perl::Appender->new(
        "Log::Dispatch::Screen",
    );
}
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

    my $zaapt = Zaapt->new({ store => 'Pg', dbh => $dbh });
    my $challenge = $zaapt->get_model("KiwiWriters::Zaapt::Store::Pg::Challenge");

    $logger->debug("got \$zaapt and \$challenge");

    $dbh->begin_work();

    # get a list of all the Timezones
    my $timezones = $challenge->sel_timezone_all();

    $logger->debug("got all the timezones (" . (scalar @$timezones) . ")");

    # see which ones are past midnight
  TIMEZONE:
    foreach my $timezone ( @$timezones ) {
        $logger->debug("checking '$timezone->{t_name}' (id=$timezone->{t_id})...");

        # set to this timezone
        $dbh->do( "SET TIME ZONE ?", undef, $timezone->{t_name} );

        # see if it is just past midnight
        my $row = row( $dbh, $sql->{sel_past_midnight} );

        # skip if this timezone hasn't just past midnight
        next TIMEZONE unless $row->{yes};

        # see all the events for this timezone
        my $events = $challenge->sel_event_all_running_yesterday();

        $logger->debug("got all the events (" . (scalar @$events) . ")");

        $logger->info("* tz: '$timezone->{t_name}' (id=$timezone->{t_id})");
        foreach my $event ( @$events ) {
            $logger->info("** event: '$event->{e_name}' (id=$event->{e_id})");

            # now, select from the people in this challenge with this timezone
            # and place their info into the progress table
            $challenge->ins_progress_for({ e_id => $event->{e_id}, t_id => $timezone->{t_id} });
        }
    }

    $dbh->commit();

    $logger->info("$0: finished");
    $logger->debug(' ');
}

## ----------------------------------------------------------------------------
# subs

sub do {
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
