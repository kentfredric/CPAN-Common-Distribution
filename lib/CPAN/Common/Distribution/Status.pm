use 5.008001;
use strict;
use warnings;

package CPAN::Common::Distribution::Status;
# ABSTRACT: Track status of distribution build phases
# VERSION

use Class::Tiny qw/configure build test install/;

sub BUILD {
    my $self = shift;
    for my $phase (qw/configure build test install/) {
        $self->$phase( CPAN::Common::Distribution::Status::_Result->new );
    }
}

# private package to hold status info for a phase
package CPAN::Common::Distribution::Status::_Result;

use Class::Tiny qw/done pass msg/;

1;
