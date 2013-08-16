use 5.008001;
use strict;
use warnings;

package CPAN::Common::Distribution;
# ABSTRACT: Configure, build, test and install a CPAN distribution directory
# VERSION

use Carp       ();
use CPAN::Meta ();
use File::Spec ();
use Log::Any qw($log);

use Class::Tiny qw/path/;

sub configure_requires {
    my ($self) = @_;

    for my $file ( map { $self->_file($_) } qw( META.json META.yml ) ) {
        next unless -f $file;
        my $meta = eval { CPAN::Meta->load_file($file) };
        if ($meta) {
            return $meta->effective_prereqs->requirements_for(qw/configure requires/);
        }
        else {
            $log->warn($@) if $@;
        }
    }

    return;
}

sub _file {
    my ( $self, $child ) = @_;
    return File::Spec->catfile( $self->path, $child );
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
