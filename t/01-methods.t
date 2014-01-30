#!perl -w

use Test::More;

use PagSeguro::API;

# methods test
can_ok 'PagSeguro::API', $_ 
    for qw/new transaction/;

# accessors test    
can_ok 'PagSeguro::API', $_ 
    for qw/email token/;

done_testing;
