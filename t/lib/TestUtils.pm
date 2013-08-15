use 5.008001;
use strict;
use warnings;

package TestUtils;

use Archive::Tar          ();
use Carp                  (qw/croak/);
use Cwd                   (qw/getcwd/);
use File::Spec::Functions (qw/catfile/);
use autodie;

sub untgz {
    my ( $file, $into ) = shift;
    croak "$file does not exist"
      unless -f $file;
    croak "$into does not exist"
      unless -d $into;

    my $cwd = getcwd();

    # Make sure AT leaves current user as owner
    local $Archive::Tar::CHOWN            = 0;
    local $Archive::Tar::CHMOD            = 1;
    local $Archive::Tar::SAME_PERMISSIONS = 0;

    chdir $into;
    Archive::Tar->extract_archive( $file, 1 )
      or die( "Could not untar $file with Archive::Tar: " . Archive::Tar->error );
    chdir $cwd;

    return 1;
}

1;

# vim: ts=4 sts=4 sw=4 et:
