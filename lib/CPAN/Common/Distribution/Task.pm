use 5.008001;
use strict;
use warnings;

package CPAN::Common::Distribution::Task;

# ABSTRACT: A container for executing a system process and transporting its output

use Class::Tiny qw/ exit command /, {
    stderr => sub {
        require File::Temp;
        return File::Temp->new();
    },
    stdout => sub {
        require File::Temp;
        return File::Temp->new();
    },
};

1;

