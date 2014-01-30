#!perl -w

use Test::More;

use FindBin;
use lib "$FindBin::Bin/../lib";

use PagSeguro::API;


my $p = PagSeguro::API->new(
    email => 'daniel.vinciguerra@bivee.com.br',
    token => '00000000000000000000000000000000',
);


is $p->{_transaction}, undef, 'transaction undef';

my $t = $p->transaction;
ok $t->isa('PagSeguro::API::Transaction'), 'transaction isa ok';


# load by code
my $load_xml = $t->load(file => 't/xml/transaction-load.xml');
is ref $load_xml, 'HASH', 'load test ok';


# load history
my $range_xml = $t->search(file => 't/xml/transaction-range.xml');
is ref $range_xml, 'HASH', 'history test ok';


# load abandoned
my $abandon_xml = $t->abandoned(file => 't/xml/transaction-abandon.xml');
is ref $abandon_xml, 'HASH', 'abandoned test ok';



done_testing;
