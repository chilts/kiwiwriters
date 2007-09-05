## -------------------------------------------------------------------*-perl-*-
package KiwiWriters::Zaapt::Store::Pg::Challenge;
use base qw( Zaapt::Store::Pg KiwiWriters::Zaapt::Model::Challenge );

use strict;
use warnings;
use Data::Dumper;

## ----------------------------------------------------------------------------
# constants

# schema name
my $schema = 'challenge';

my $table = {
    challenge => {
        name => 'challenge',
        prefix => 'c',
        cols => [ qw(id name title description r:admin_id r:view_id ts:inserted ts:updated) ],
    },
    category => {
        name => 'category',
        prefix => 'ca',
        cols => [ qw(id title description isstandard unit units ts:inserted ts:updated) ],
    },
    event => {
        name => 'event',
        prefix => 'e',
        cols => [
            'id',
            [ 'challenge_id', 'fk', 'c_id' ],
            [ 'category_id', 'fk', 'ca_id' ],
            [ 'account_id', 'fk', 'a_id' ],
            qw(name title description rules goal dt:startts dt:endts ts:inserted ts:updated),
            [ 'status', 'virtual', "CASE WHEN startts > CURRENT_TIMESTAMP THEN 'future' WHEN endts < CURRENT_TIMESTAMP THEN 'archive' ELSE 'current' END" ]
        ],
    },
    participant => {
        name => 'participant',
        prefix => 'p',
        cols => [
            'id',
            [ 'event_id', 'fk', 'e_id' ],
            [ 'account_id', 'fk', 'a_id' ],
            qw(progress ts:inserted ts:updated)
        ],
    },
    progress => {
        name => 'progress',
        prefix => 'pr',
        cols => [
            'id',
            [ 'participant_id', 'fk', 'p_id' ],
            qw( date progress ts:inserted ts:updated )
        ],
    },
    timezone => {
        name => 'timezone',
        prefix => 't',
        cols => [
            qw( id name extra ts:inserted ts:updated )
        ],
    },
    info => {
        name => 'info',
        prefix => 'i',
        cols => [
            [ 'account_id', 'fk', 'a_id' ],
            [ 'timezone_id', 'fk', 't_id' ],
            qw( ts:inserted ts:updated )
        ],
        no_id => 1,
        pk => [ 'account_id', 'fk', 'a_id' ],
    },
};

my $join = {
    c_e => "JOIN $schema.event e ON (c.id = e.challenge_id)",
    e_ca => "JOIN $schema.category ca ON (e.category_id = ca.id)",
    p_pr => "JOIN $schema.progress pr ON (p.id = pr.participant_id)",
    i_t => "JOIN $schema.timezone t ON (i.timezone_id = t.id)",
};

## ----------------------------------------------------------------------------

# creates {sql_fqt} and {sql_sel_cols}
__PACKAGE__->_mk_sql( $schema, $table );

# generate the Perl method accessors
__PACKAGE__->_mk_sql_accessors( $schema, $table );

## ----------------------------------------------------------------------------

# now that we've generated everything we want, we can add more to the data structure
$table->{account} = {
    schema => 'account',
    name   => 'account',
    prefix => 'a',
    cols   => [ qw(id username) ],
};
$table->{account}{sql_fqt} = __PACKAGE__->_mk_sel_fqt($table->{account}{schema}, $table->{account}{name}, $table->{account}{prefix});
$table->{account}{sql_sel_cols} = __PACKAGE__->_mk_cols( $table->{account}{prefix}, @{$table->{account}{cols}} );
$join->{p_a} = "JOIN account.account a ON (p.account_id = a.id)";

## ----------------------------------------------------------------------------

$join->{e_p} = "JOIN $schema.participant p ON (e.id = p.event_id)";

# create the standard selecters
__PACKAGE__->mk_selecter( $schema, $table->{challenge}{name}, $table->{challenge}{prefix}, @{$table->{challenge}{cols}} );
__PACKAGE__->mk_selecter( $schema, $table->{category}{name}, $table->{category}{prefix}, @{$table->{category}{cols}} );
__PACKAGE__->mk_select_row( 'sel_event', "SELECT $table->{challenge}{sql_sel_cols}, $table->{event}{sql_sel_cols} FROM $table->{challenge}{sql_fqt} $join->{c_e} WHERE e.id = ?", [ 'e_id' ] );
__PACKAGE__->mk_select_row( 'sel_info', "SELECT $table->{info}{sql_sel_cols}, $table->{timezone}{sql_sel_cols} FROM $table->{info}{sql_fqt} $join->{i_t} WHERE i.account_id = ?", [ 'a_id' ] );
__PACKAGE__->mk_selecter( $schema, $table->{timezone}{name}, $table->{timezone}{prefix}, @{$table->{timezone}{cols}} );

# challenge
__PACKAGE__->mk_selecter_using( $schema, 'challenge', 'c', 'name', @{$table->{challenge}{cols}} );

sub sel_challenge_all {
    my ($self) = @_;
    my $t = $table->{challenge};
    return $self->_rows( "SELECT $t->{sql_sel_cols} FROM $t->{sql_fqt} ORDER BY $t->{prefix}.id" );
}

# category
sub sel_category_all {
    my ($self) = @_;
    my $t = $table->{category};
    return $self->_rows( "SELECT $t->{sql_sel_cols} FROM $t->{sql_fqt} ORDER BY $t->{prefix}.id" );
}

sub sel_category_isstandard_all {
    my ($self) = @_;
    my $t = $table->{category};
    return $self->_rows( "SELECT $t->{sql_sel_cols} FROM $t->{sql_fqt} WHERE $t->{prefix}.isstandard ORDER BY $t->{prefix}.id" );
}

# event
sub sel_event_using_name {
    my ($self, $hr) = @_;
    my $t = $table->{event};
    return $self->_row( "SELECT $table->{challenge}{sql_sel_cols}, $t->{sql_sel_cols}, $table->{category}{sql_sel_cols} FROM $table->{challenge}{sql_fqt} $join->{c_e} $join->{e_ca} WHERE $t->{prefix}.name = ?", $hr->{e_name} );
}

sub sel_event_all_for {
    my ($self, $hr) = @_;
    my $t = $table->{event};
    return $self->_rows( "SELECT $t->{sql_sel_cols} FROM $table->{challenge}{sql_fqt} $join->{c_e} WHERE $table->{challenge}{prefix}.id = ? ORDER BY $t->{prefix}.id", $hr->{c_id} );
}

sub sel_event_all_current_for {
    my ($self, $hr) = @_;
    my $t = $table->{event};
    my $p = $table->{event}{prefix};

    return $self->_rows(
        "SELECT
            $table->{challenge}{sql_sel_cols},
            $t->{sql_sel_cols},
            $table->{category}{sql_sel_cols}
        FROM
            $table->{challenge}{sql_fqt}
            $join->{c_e}
            $join->{e_ca}
        WHERE
            $table->{challenge}{prefix}.id = ?
        AND
            $p.startts < CURRENT_TIMESTAMP
        AND
            $p.endts > CURRENT_TIMESTAMP
        ORDER BY
            $p.startts, $p.endts",
        $hr->{c_id}
    );
}

sub sel_event_all_archive_for {
    my ($self, $hr) = @_;
    my $t = $table->{event};
    return $self->_rows(
        "SELECT
            $table->{challenge}{sql_sel_cols},
            $t->{sql_sel_cols},
            $table->{category}{sql_sel_cols}
        FROM
            $table->{challenge}{sql_fqt}
            $join->{c_e}
            $join->{e_ca}
        WHERE
            $table->{challenge}{prefix}.id = ?
        AND
            $t->{prefix}.endts < CURRENT_TIMESTAMP
        ORDER BY
            $t->{prefix}.startts, $t->{prefix}.endts",
        $hr->{c_id}
    );
}

sub sel_event_all_future_for {
    my ($self, $hr) = @_;
    my $t = $table->{event};
    return $self->_rows(
        "SELECT
            $table->{challenge}{sql_sel_cols},
            $t->{sql_sel_cols},
            $table->{category}{sql_sel_cols}
        FROM
            $table->{challenge}{sql_fqt}
            $join->{c_e}
            $join->{e_ca}
        WHERE
            $table->{challenge}{prefix}.id = ?
        AND
            $t->{prefix}.startts > CURRENT_TIMESTAMP
        ORDER BY
            $t->{prefix}.startts, $t->{prefix}.endts",
        $hr->{c_id}
    );
}

sub sel_participants_all_for {
    my ($self, $hr) = @_;
    my $t = $table->{participant};
    return $self->_rows( "SELECT $t->{sql_sel_cols}, $table->{account}{sql_sel_cols} FROM $table->{event}{sql_fqt} $join->{e_p} $join->{p_a} WHERE e.id = ? ORDER BY $t->{prefix}.progress DESC, $table->{account}{prefix}.username", $hr->{e_id} );
}

sub sel_participant_status {
    my ($self, $hr) = @_;
    my $t = $table->{participant};
    return $self->_row( "SELECT $t->{sql_sel_cols}, $table->{account}{sql_sel_cols} FROM $t->{sql_fqt} $join->{p_a} WHERE $t->{prefix}.event_id = ? AND $t->{prefix}.account_id = ?", $hr->{e_id}, $hr->{a_id} );
}

# find which events were running at some stage yesterday
# Note: this method assumes that 'TIME ZONE' has been set correctly
sub sel_event_all_running_yesterday {
    my ($self) = @_;
    my $t = $table->{event};
    # SELECT id, name, startts, endts FROM challenge.event WHERE startts::DATE <= '2007-09-03'::DATE AND endts::DATE >= '2007-09-02'::DATE ORDER BY id;
    my $sql = "SELECT $table->{challenge}{sql_sel_cols}, $t->{sql_sel_cols} FROM $table->{challenge}{sql_fqt} $join->{c_e} WHERE $t->{prefix}.startts::DATE <= CURRENT_DATE-1 AND $t->{prefix}.endts::DATE >= CURRENT_DATE-2 ORDER BY $t->{prefix}.id";
    return $self->_rows( $sql );
}

# participant
sub accept_challenge {
    my ($self, $hr) = @_;
    my $t = $table->{participant};
    return $self->_do( "INSERT INTO $schema.$t->{name}(event_id, account_id) VALUES(?, ?)", $hr->{e_id}, $hr->{a_id} );
}

my $sel_progress_all_for = "
    SELECT
        $table->{participant}{sql_sel_cols}, $table->{progress}{sql_sel_cols}
    FROM
        $table->{participant}{sql_fqt}, $join->{p_pr}
    WHERE
        p.event_id = ? AND p.account_id = ?
";

__PACKAGE__->mk_select_rows( 'sel_progress_all_for', $sel_progress_all_for, [ 'e_id', 'a_id' ] );

# timezones
# Note: for some information regarding timezones, see:
# - http://kapiti.geek.nz/random/timezones-freak-me-out.html
__PACKAGE__->mk_select_rows( 'sel_timezone_all', "SELECT $table->{timezone}{sql_sel_cols} FROM $table->{timezone}{sql_fqt} ORDER BY t.id", [] );

# for the sub to get the current progress of the current events
# insert into challenge.progress(participant_id, date, progress) select id, current_date-1, progress from challenge.participant where event_id = 1

# users
sub sel_event_all_current_for_account {
    my ($self, $hr) = @_;
    my $e = $table->{event};
    my $p = $table->{participant};

    my $sql = "SELECT
            $table->{challenge}{sql_sel_cols},
            $e->{sql_sel_cols},
            $table->{category}{sql_sel_cols},
            $p->{sql_sel_cols}
        FROM
            $table->{challenge}{sql_fqt}
            $join->{c_e}
            $join->{e_ca}
            $join->{e_p}
        WHERE
            $e->{prefix}.startts < CURRENT_TIMESTAMP
        AND
            $e->{prefix}.endts > CURRENT_TIMESTAMP
        AND
            $p->{prefix}.account_id = ?
        ORDER BY
            $e->{prefix}.startts, $e->{prefix}.endts";

    return $self->_rows( $sql, $hr->{a_id} );
}

sub sel_event_all_future_for_account {
    my ($self, $hr) = @_;
    my $e = $table->{event};
    my $p = $table->{participant};

    my $sql = "SELECT
            $table->{challenge}{sql_sel_cols},
            $e->{sql_sel_cols},
            $table->{category}{sql_sel_cols},
            $p->{sql_sel_cols}
        FROM
            $table->{challenge}{sql_fqt}
            $join->{c_e}
            $join->{e_ca}
            $join->{e_p}
        WHERE
            $e->{prefix}.startts > CURRENT_TIMESTAMP
        AND
            $p->{prefix}.account_id = ?
        ORDER BY
            $e->{prefix}.startts, $e->{prefix}.endts";

    return $self->_rows( $sql, $hr->{a_id} );
}

sub has_time_passed_for {
    my ($self, $hr) = @_;

    my $sql1 = "SET TIME ZONE '$hr->{_tzname}'";
    my $sql2 = "SELECT CASE WHEN CURRENT_TIMESTAMP > ? THEN 1 else 0 END AS passed";
    my $sql3 = "SET TIME ZONE 'Pacific/Auckland'";

    $self->dbh()->do($sql1);
    my $res = $self->dbh()->selectrow_hashref($sql2, undef, $hr->{_time});
    $self->dbh()->do($sql3);

    return $res;
}

# progress
# expects $hr->{e_id} and $hr->{t_id}
sub ins_progress_for {
    my ($self, $hr) = @_;

    my $e = $table->{event};
    my $pr = $table->{progress};

    my $sql = "
        INSERT INTO
            $schema.$pr->{name}(participant_id, date, progress)
        SELECT
            p.id, current_date-1, progress
        FROM
            challenge.event e
            JOIN challenge.participant p ON (e.id = p.event_id)
            JOIN challenge.info i ON (p.account_id = i.account_id)
        WHERE
            e.id = ? AND i.timezone_id = ?
    ";
    return $self->_do( $sql, $hr->{e_id}, $hr->{t_id} );
}


sub _nuke {
    my ($self) = @_;
    $self->dbh()->begin_work();
    $self->dbh()->do( "DELETE FROM challenge.progress" );
    $self->dbh()->do( "DELETE FROM challenge.participant" );
    $self->dbh()->do( "DELETE FROM challenge.event" );
    $self->dbh()->do( "DELETE FROM challenge.category" );
    $self->dbh()->do( "DELETE FROM challenge.challenge" );
    $self->dbh()->commit();
}

## ----------------------------------------------------------------------------
1;
## ----------------------------------------------------------------------------
