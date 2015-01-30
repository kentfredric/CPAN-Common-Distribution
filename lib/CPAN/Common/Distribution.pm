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
use Module::Load ();

use Class::Tiny qw/path status/, {
    taskclass  => sub { 'CPAN::Common::Distribution::Task' },
    installer  => sub { $_[0]->_build_installer },
    installers => sub {
        [
            'CPAN::Common::Distribution::MakefilePL',
            'CPAN::Common::Distribution::BuildPL'
        ];
    },
};

use CPAN::Common::Distribution::Status;

sub BUILD {
    my $self = shift;
    $self->status( CPAN::Common::Distribution::Status->new );

    my $path = $self->path;
    unless ( defined $path && -d $path ) {
        Carp::croak( "Path '$path' is not a directory" );
    }
    Module::Load::load( $self->taskclass );
}

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

sub configure {
    my ($self) = @_;
    return $self->installer->configure;
}

sub build {
    my ($self) = @_;
    return $self->installer->build;
}

sub test {
    my ( $self) = @_;
    return $self->installer->test;
}

sub install {
    my ( $self ) = @_;
    return $self->installer->install;
}

sub _file {
    my ( $self, $child ) = @_;
    return File::Spec->catfile( $self->path, $child );
}

sub _build_installer {
    my ($self) = @_;
    for my $installer ( @{ $self->installers } ) {
        Module::Load::load($installer);
        my $installer_object = $installer->new(
            path      => $self->path,
            taskclass => $self->taskclass,
        );
        next unless $installer_object->is_valid;
    }
    $log->errorf( "No installer detected, tried: <%s>", join q[, ], @{ $self->installers } );
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
