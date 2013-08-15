use 5.008001;
use strict;
use warnings;

package TestUtils;

use Archive::Tar          ();
use Carp                  (qw/croak/);
use Cwd                   (qw/getcwd/);
use File::Spec::Functions (qw/catfile catdir rel2abs/);
use autodie;

use Exporter;
our @ISA    = qw/Exporter/;
our @EXPORT = qw(
  children
  has_pl
  untgz
);

sub children {
    my $dir = shift;
    croak "$dir does not exist"
      unless -d $dir;
    opendir my ($dh), $dir;
    my @children = grep { $_ ne "." && $_ ne ".." } readdir $dh;
    return @children;
}

sub has_pl {
    return grep { $_ eq 'Makefile.PL' or $_ eq 'Build.PL' } @_;
}

sub untgz {
    my ( $file, $into ) = @_;
    croak "$file does not exist"
      unless -f $file;
    croak "$into does not exist"
      unless -d $into;

    my $cwd = getcwd();
    $file = rel2abs($file);

    # Make sure AT leaves current user as owner
    local $Archive::Tar::CHOWN            = 0;
    local $Archive::Tar::CHMOD            = 1;
    local $Archive::Tar::SAME_PERMISSIONS = 0;

    chdir $into;
    Archive::Tar->extract_archive( $file, 1 )
      or die( "Could not untar $file with Archive::Tar: " . Archive::Tar->error );
    chdir $cwd;

    return _find_dist_dir( $into );
}

sub _find_dist_dir {
    my ($path) = @_;

    while ( !has_pl( my @children = children($path) ) ) {
        last if ! @children;
        $path = catdir( $path, $children[0] );
    }

    croak "Could not locate distribution directory in $path"
        unless has_pl( children($path) );

    return $path;
}

1;

# vim: ts=4 sts=4 sw=4 et:
