use 5.008001;
use strict;
use warnings;
use Test::More 0.96;
use Log::Any::Test;
use Log::Any qw($log);

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
  CPAN-Test-Dummy-Perl5-Make-ConfReq-1.00.tar.gz
);

my %config_req = (
  'Build' => [], 
  'Make' => [],
  'Make-ConfReq' => ['CPAN::Test::Dummy::Perl5::Make'],
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

        my $config_req = $dist->configure_requires;
        
        diag explain $config_req;
        $log->empty_ok( "no log messages" );
    };
}

done_testing;
# COPYRIGHT
# vim: ts=4 sts=4 sw=4 et:
