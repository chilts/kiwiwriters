## -------------------------------------------------------------------*-perl-*-
package KiwiWriters::Zaapt::Store::Pg::Profile;
use base qw( Zaapt::Store::Pg KiwiWriters::Zaapt::Model::Profile );

use strict;
use warnings;

use Zaapt::Store::Pg::Account;

## ----------------------------------------------------------------------------
# constants

# schema name
my $schema = 'profile';

my $tables = {
    profile => {
        name => 'profile',
        prefix => 'p',
        cols => [
            [ 'account_id', 'fk', 'a_id' ],
            qw(age location website favauthors favbooks ts:inserted ts:updated)
        ],
        pk => [ 'account_id', 'fk', 'a_id' ],
    },
    account => Zaapt::Store::Pg::Account->_get_table( 'account' ),
};

my $join = {
    p_a   => "JOIN account.account a ON (p.account_id = a.id)",
};

## ----------------------------------------------------------------------------

# creates {sql_fqt} and {sql_sel_cols}
__PACKAGE__->_mk_sql( $schema, $tables );

# generate the Perl method accessors
__PACKAGE__->_mk_store_accessors( $schema, $tables );

## ----------------------------------------------------------------------------
# simple accessors

# create some reusable sql
my $profile_cols = "$tables->{profile}{sql_sel_cols}, $tables->{account}{sql_sel_cols}";
my $profile_tables = "$tables->{profile}{sql_fqt} $join->{p_a}";

# profile
__PACKAGE__->mk_select_row( 'sel_profile', "SELECT $profile_cols FROM $profile_tables WHERE a.id = ?", [ 'a_id' ] );

my $ins_profile_skeleton = "INSERT INTO profile.profile(account_id) VALUES(?)";
sub ins_profile_skeleton {
    my ($self, $hr) = @_;
    $self->_do( $ins_profile_skeleton, $hr->{a_id} );
}

sub _nuke {
    my ($self) = @_;
    $self->dbh()->begin_work();
    $self->dbh()->do( "DELETE FROM profile.profile" );
    $self->dbh()->commit();
}

## ----------------------------------------------------------------------------
1;
## ----------------------------------------------------------------------------
