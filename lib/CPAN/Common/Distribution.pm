use 5.008001;
use strict;
use warnings;

package CPAN::Common::Distribution;
# ABSTRACT: Configure, build, test and install a CPAN distribution directory
# VERSION

use Carp ();

my @ATTRIBUTES = qw(
    path
);

for my $k ( @ATTRIBUTES ) {
    no strict 'refs';
    *{ __PACKAGE__ . "::$k" } = sub {
        return @_ > 1 ? $_[0]->{$k} = $_[1] : $_[0]->{$k};
    };
}

sub new {
    my ($class, $args ) = @_;

    # argument must be a hash
    $args = {} unless defined $args;
    if ( ref $args ne 'HASH' ) {
        Carp::croak("Argument to new() must be a hash reference");
    }

    # initialize attributes
    my %attributes;
    for my $k ( @ATTRIBUTES ) {
        if ( exists $args->{$k} ) {
            $attributes{$k} = delete $args->{$k};
        }
    }

    # die on any unknown attributes
    if ( keys %$args ) {
        Carp::croak( "Unknown arguments to new(): " . join( " ", keys %$args ) );
    }

    # return the object
    my $self = bless \%attributes, $class;
    return $self;
}

1;

=for Pod::Coverage method_names_here

=head1 SYNOPSIS

  use CPAN::Common::Distribution;

=head1 DESCRIPTION

This module might be cool, but you'd never know it from the lack
of documentation.

=head1 USAGE

Good luck!

=head1 SEE ALSO

Maybe other modules do related things.

=cut

# vim: ts=4 sts=4 sw=4 et:
