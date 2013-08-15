use 5.008001;
use strict;
use warnings;
use Test::More 0.96;
use Test::Deep '!blessed';
use Test::FailWarnings;
use Test::Fatal;

use File::Spec::Functions qw/catdir catfile/;
use File::Temp;

use lib 't/lib';
use TestUtils qw/untgz children has_pl/;

#--------------------------------------------------------------------------#
# Fixtures
#--------------------------------------------------------------------------#


my @corpus = qw(
  CPAN-Test-Dummy-Perl5-Build-1.03.tar.gz
  CPAN-Test-Dummy-Perl5-Make-1.05.tar.gz
);

#--------------------------------------------------------------------------#
# Tests
#--------------------------------------------------------------------------#

require_ok( 'CPAN::Common::Distribution' );

for my $c ( @corpus ) {
    my ($label) = $c =~ /^CPAN-Test-Dummy-Perl5-(.*?)-\d/;
    subtest $label => sub {
        my $tempdir = File::Temp->newdir;
        my $path = untgz( catfile('corpus', $c), $tempdir );
        my $dist = new_ok('CPAN::Common::Distribution', [{path => $path}] );
    };
}

done_testing;
# COPYRIGHT
# vim: ts=4 sts=4 sw=4 et:
