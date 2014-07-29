#!perl -w
use strict;

use Test::More;

use FindBin;
use lib "$FindBin::Bin/../lib";

use PagSeguro::API;

subtest 'testing object instantiate error' => sub {
    my $ps_api = PagSeguro::API->new;

    my ($email, $token) = ($ps_api->email, $ps_api->token);

    ok(!$email && !$token);
    is($email, undef);
    is($token, undef);
};


subtest 'testing object instantiate args' => sub {
    my $ps_api = PagSeguro::API->new(
        email => 'foo@bar.com',
        token => '1E4C2E4E08374D5E81DCE87548282656',
    );

    my ($email, $token) = ($ps_api->email, $ps_api->token);

    ok($email && $token);
    is($email, 'foo@bar.com');
    is($token, '1E4C2E4E08374D5E81DCE87548282656');
};


subtest 'testing object instantiate env' => sub {
    $ENV{PAGSEGURO_API_EMAIL} = 'foo@bar.com';
    $ENV{PAGSEGURO_API_TOKEN} = '1E4C2E4E08374D5E81DCE87548282656';

    my $ps_api = PagSeguro::API->new;
    my ($email, $token) = ($ps_api->email, $ps_api->token);

    ok($email && $token);
    is($email, 'foo@bar.com');
    is($token, '1E4C2E4E08374D5E81DCE87548282656');
};

done_testing;
