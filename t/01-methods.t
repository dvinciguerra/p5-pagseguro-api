#!perl -w
use strict;

use Test::More;

use FindBin;
use lib "$FindBin::Bin/../lib";

use PagSeguro::API;

# methods test
subtest 'testing all methods exists' => sub {
    can_ok 'PagSeguro::API', $_ for qw/new transaction/;
};

# accessors test    
subtest 'testing accessors exists' => sub {
    can_ok 'PagSeguro::API', $_ for qw/email token/;
}

done_testing;
