#!perl -w

use Test::More;

use PagSeguro::API;


my $p = PagSeguro::API->new;


eval { $p->transaction };
ok $@, 'email and token undef';

$p = PagSeguro::API->new(
    email => 'daniel.vinciguerra@bivee.com.br',
    token => '1E4C2E4E08374D5E81DCE87548282656',
);
ok $p->email && $p->token, 'params ok';


done_testing;
