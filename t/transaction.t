#!perl -w
use strict;

use Test::More;

use FindBin;
use lib "$FindBin::Bin/../lib";

use PagSeguro::API;

subtest 'transaction lazy loading' => sub {
    my $ps_api = PagSeguro::API->new(
        email => 'foo@bar.com',
        token => '1E4C2E4E08374D5E81DCE87548282656',
    );

    # try call private property
    my $t = eval{ $ps_api->{_transaction} } || undef;

    is($t, undef);

};


subtest 'call transaction in a right way' => sub {
    my $ps_api = PagSeguro::API->new(
        email => 'foo@bar.com',
        token => '1E4C2E4E08374D5E81DCE87548282656',
    );

    # try call property accessor
    my $t = eval{ $ps_api->transaction } || undef;

    ok($t);
    isa_ok($t, 'PagSeguro::API::Transaction');
};


my $ps_api = PagSeguro::API->new(
    email => 'foo@bar.com',
    token => '1E4C2E4E08374D5E81DCE87548282656',
);

subtest 'load transaction by code' => sub {
    my $t = $ps_api->transaction || undef;

    # load by code (using xml response to test)
    my $xml = eval { $t->load( file => 't/xml/transaction-load.xml' ) };

    ok($xml);
    is('HASH', ref($xml));
};

subtest 'load transaction by code' => sub {
    my $t = $ps_api->transaction || undef;

    # load by history (using xml response to test)
    my $xml = eval { $t->search( file => 't/xml/transaction-range.xml' ) };

    ok($xml);
    is('HASH', ref($xml));
};

subtest 'load transaction by code' => sub {
    my $t = $ps_api->transaction || undef;

    # load by abandoned (using xml response to test)
    my $xml = eval { $t->abandoned( file => 't/xml/transaction-abandon.xml' ) };

    ok($xml);
    is('HASH', ref($xml));
};

done_testing;
