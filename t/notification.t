#!perl -w
use strict;

use Test::More;

use FindBin;
use lib "$FindBin::Bin/../lib";

use PagSeguro::API;

subtest 'notification lazy loading' => sub {
    my $ps_api = PagSeguro::API->new(
        email => 'foo@bar.com',
        token => '1E4C2E4E08374D5E81DCE87548282656',
    );

    # try call private property
    my $n = eval{ $ps_api->{_notification} } || undef;

    is($n, undef);
};

subtest 'call notification in a right way' => sub {
    my $ps_api = PagSeguro::API->new(
        email => 'foo@bar.com',
        token => '1E4C2E4E08374D5E81DCE87548282656',
    );

    # try call property accessor
    my $n = eval{ $ps_api->notification } || undef;

    ok($n);
    isa_ok($n, 'PagSeguro::API::Notification');
};

my $ps_api = PagSeguro::API->new(
    email => 'foo@bar.com',
    token => '1E4C2E4E08374D5E81DCE87548282656',
);

subtest 'load notification by code' => sub {
    my $n = $ps_api->notification || undef;

    # load by code (using xml response to test)
    my $xml = eval { $n->load( file => 't/xml/notification-load.xml' ) };
    
    ok($xml);
    is('HASH', ref($xml));
};


done_testing;
