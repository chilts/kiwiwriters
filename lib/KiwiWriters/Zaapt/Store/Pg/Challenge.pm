## -------------------------------------------------------------------*-perl-*-
package KiwiWriters::Zaapt::Store::Pg::Challenge;
use base qw( Zaapt::Store::Pg KiwiWriters::Zaapt::Model::Challenge );

use strict;
use warnings;

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
        cols => [ qw(id challenge_id category_id account_id name title description rules goal dt:startts dt:endts ts:inserted ts:updated) ],
        alias => {
            challenge_id => 'c_id',
            category_id => 'ca_id',
            account_id => 'a_id',
        },
    },
    participant => {
        name => 'participant',
        prefix => 'p',
        cols => [ qw(id event_id account_id progress ts:inserted ts:updated) ],
    },
    progress => {
        name => 'progress',
        prefix => 'pr',
        cols => [ qw(id participant_id date progress ts:inserted ts:updated) ],
    },
};

my $join = {
    c_e => "JOIN $schema.event e ON (c.id = e.challenge_id)",
    e_ca => "JOIN $schema.category ca ON (e.category_id = ca.id)",
};

## ----------------------------------------------------------------------------

# creates {sql_fqt} and {sql_cols}
__PACKAGE__->_mk_sql( $schema, $table );

# generate the SQL accessors
__PACKAGE__->_mk_sql_accessors( $schema, $table );

## ----------------------------------------------------------------------------

# now that we've generated everything we want, we can add more to the data structure
$table->{account} = {
    schema => 'account',
    name   => 'account',
    prefix => 'a',
    cols   => [ qw(id username) ],
};
$table->{account}{sql_fqt} = "$table->{account}{schema}.$table->{account}{name} $table->{account}{prefix}",
$table->{account}{sql_cols} = __PACKAGE__->_mk_cols( $table->{account}{prefix}, @{$table->{account}{cols}} );
$join->{p_a} = "JOIN account.account a ON (p.account_id = a.id)";

## ----------------------------------------------------------------------------

# create sel_challenge_using_name
__PACKAGE__->mk_selecter_using( $schema, 'challenge', 'c', 'name', @{$table->{challenge}{cols}} );

sub sel_event_using_name {
    my ($self, $hr) = @_;
    my $t = $table->{event};
    return $self->_row( "SELECT $table->{challenge}{sql_cols}, $t->{sql_cols}, $table->{category}{sql_cols} FROM $table->{challenge}{sql_fqt} $join->{c_e} $join->{e_ca} WHERE $t->{prefix}.name = ?", $hr->{e_name} );
}

sub sel_challenge_all {
    my ($self) = @_;
    my $t = $table->{challenge};
    return $self->_rows( "SELECT $t->{sql_cols} FROM $t->{sql_fqt} ORDER BY $t->{prefix}.id" );
}

sub sel_category_all {
    my ($self) = @_;
    my $t = $table->{category};
    return $self->_rows( "SELECT $t->{sql_cols} FROM $t->{sql_fqt} ORDER BY $t->{prefix}.id" );
}

sub sel_category_isstandard_all {
    my ($self) = @_;
    my $t = $table->{category};
    return $self->_rows( "SELECT $t->{sql_cols} FROM $t->{sql_fqt} WHERE $t->{prefix}.isstandard ORDER BY $t->{prefix}.id" );
}

sub sel_event_all_for {
    my ($self, $hr) = @_;
    my $t = $table->{event};
    return $self->_rows( "SELECT $t->{sql_cols} FROM $table->{challenge}{sql_fqt} $join->{c_e} WHERE $table->{challenge}{prefix}.id = ? ORDER BY $t->{prefix}.id", $hr->{c_id} );
}

sub sel_event_all_current_for {
    my ($self, $hr) = @_;
    my $t = $table->{event};
    return $self->_rows(
        "SELECT
            $table->{challenge}{sql_cols},
            $t->{sql_cols},
            $table->{category}{sql_cols}
        FROM
            $table->{challenge}{sql_fqt}
            $join->{c_e}
            $join->{e_ca}
        WHERE
            $table->{challenge}{prefix}.id = ?
        AND
            $t->{prefix}.startts < CURRENT_TIMESTAMP
        AND
            $t->{prefix}.endts > CURRENT_TIMESTAMP
        ORDER BY
            $t->{prefix}.startts, $t->{prefix}.endts",
        $hr->{c_id}
    );
}

sub sel_event_all_archive_for {
    my ($self, $hr) = @_;
    my $t = $table->{event};
    return $self->_rows(
        "SELECT
            $table->{challenge}{sql_cols},
            $t->{sql_cols},
            $table->{category}{sql_cols}
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
            $table->{challenge}{sql_cols},
            $t->{sql_cols},
            $table->{category}{sql_cols}
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
    return $self->_rows( "SELECT $t->{sql_cols}, $table->{account}{sql_cols} FROM $t->{sql_fqt} $join->{p_a} ORDER BY $t->{prefix}.progress DESC, $table->{account}{prefix}.username" );
}

sub sel_participant_status {
    my ($self, $hr) = @_;
    my $t = $table->{participant};
    return $self->_row( "SELECT $t->{sql_cols} FROM $t->{sql_fqt} WHERE $t->{prefix}.event_id = ? AND $t->{prefix}.account_id = ?", $hr->{e_id}, $hr->{a_id} );
}

sub join_event {
    my ($self, $hr) = @_;
    my $t = $table->{participant};
    return $self->_do( "INSERT INTO $schema.$t->{name}(event_id, account_id) VALUES(?, ?)", $hr->{e_id}, $hr->{a_id} );
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
