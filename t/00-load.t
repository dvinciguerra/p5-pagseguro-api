#!perl -w
use strict;

use Test::More;

use FindBin;
use lib "$FindBin::Bin/../lib";

subtest 'testing module load' => sub {
    use_ok 'PagSeguro::API';
    require_ok 'PagSeguro::API';
};

done_testing;
