## -------------------------------------------------------------------*-perl-*-
package KiwiWriters::Zaapt::Store::Pg::Profile;
use base qw( Zaapt::Store::Pg KiwiWriters::Zaapt::Model::Profile );

use strict;
use warnings;

## ----------------------------------------------------------------------------
# constants

# table names

my $profile_tablename = "profile.profile p";


# helper
my $profile_cols = __PACKAGE__->_mk_cols( 'p', qw(account_id age location website favauthors favbooks ts:inserted ts:updated) );

# profile
my $ins_profile = __PACKAGE__->_mk_ins( 'profile.profile', qw(account_id age location website favauthors favbooks) );
my $upd_profile = __PACKAGE__->_mk_upd( 'profile.profile', 'account_id', qw(age location website favauthors favbooks) );
my $del_profile = __PACKAGE__->_mk_del('profile.profile', 'account_id');
my $sel_profile = "SELECT $profile_cols FROM $profile_tablename WHERE p.account_id = ?";

## ----------------------------------------------------------------------------
# methods

sub ins_profile {
    my ($self, $hr) = @_;
    $self->_do( $ins_profile, $hr->{a_id}, $hr->{p_age}, $hr->{p_location}, $hr->{p_website}, $hr->{p_favauthors}, $hr->{p_favbooks} );
}

sub upd_profile {
    my ($self, $hr) = @_;
    $self->_do( $upd_profile, $hr->{p_age}, $hr->{p_location}, $hr->{p_website}, $hr->{p_favauthors}, $hr->{p_favbooks}, $hr->{a_id} );
}

sub del_profile {
    my ($self, $hr) = @_;
    $self->_do( $del_profile, $hr->{a_id} );
}

sub sel_profile {
    my ($self, $hr) = @_;
    return $self->_row( $sel_profile, $hr->{a_id} );
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
