use strict;
use warnings;

use Test::More;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Data::Dumper;

#use PagSeguro::API;

# use test
use_ok 'PagSeguro::API';

# methods test
can_ok 'PagSeguro::API', $_ for qw/new transaction/;

# params test
eval {
    my $p = PagSeguro::API->new;
    $p->transaction;
};
ok $@, 'email and token undef';

# param ok test
my $p = PagSeguro::API->new(
    email => 'daniel.vinciguerra@bivee.com.br',
    token => '1E4C2E4E08374D5E81DCE87548282656',
);
ok $p->email && $p->token, 'params ok';

# transaction test
is $p->{_transaction}, undef, 'transaction undef';

my $t = $p->transaction;
ok $t->isa('PagSeguro::API::Transaction'), 'transaction isa ok';

my $xml_load = "$FindBin::Bin/xml/transaction-load.xml";
is ref $t->load( file => $xml_load ), 'HASH', 'transaction load test ok';

#is ref $t->load('DC33DA45-B188-429A-A838-C781DB54F8D4'), 'HASH', 'transaction load online test';

my $xml_range = "$FindBin::Bin/xml/transaction-range.xml";
is ref $t->search( file => $xml_range ), 'HASH', 'transaction range test ok';

is ref $t->search(
    initial => '2014-01-01T00:00',
    final   => '2014-01-28T00:00',
    page    => 1,
    max     => 1000
  ),
  'HASH', 'transaction search online test';

done_testing;
