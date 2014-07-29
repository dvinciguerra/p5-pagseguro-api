#!perl -w
use strict;

use Test::More;

use FindBin;
use lib "$FindBin::Bin/../lib";

use PagSeguro::API;

subtest 'checkout lazy loading' => sub {
    my $ps_api = PagSeguro::API->new(
        email => 'foo@bar.com',
        token => '1E4C2E4E08374D5E81DCE87548282656',
    );

    # try call private property
    my $c = eval{ $ps_api->{_checkout} } || undef;

    is($c, undef);

};


subtest 'call checkout in a right way' => sub {
    my $ps_api = PagSeguro::API->new(
        email => 'foo@bar.com',
        token => '1E4C2E4E08374D5E81DCE87548282656',
    );

    # try call property accessor
    my $c = eval{ $ps_api->checkout } || undef;

    ok($c);
    isa_ok($c, 'PagSeguro::API::Checkout');
};


my $ps_api = PagSeguro::API->new(
    email => 'foo@bar.com',
    token => '1E4C2E4E08374D5E81DCE87548282656',
);


subtest 'checking send checkout uri' => sub {
    my $c = $ps_api->checkout || undef;

    # only for test! do not use private api methods
    my $uri = eval { $c->_checkout_uri({
        itemId1          => 1,
        itemDescription1 => 'Product Foo',
        itemAmount1      => '1.00',
        itemQuantity1    => 1,
        itemWeight1      => 0,
    }) };

    like($uri, qr/itemId1=1/);
    like($uri, qr/itemAmount1=1\.00/);
    like($uri, qr/itemDescription1=Product Foo/);
};

subtest 'parse checkout response' => sub {
    my $c = $ps_api->checkout || undef;

    # load by code (using xml response to test)
    my $xml = eval { $c->send( file => 't/xml/checkout-response.xml' ) };

    is('HASH', ref($xml));
    ok($xml && $xml->{code});
    like($xml->{code}, qr/^([\w\d]+)$/);
};

done_testing;
