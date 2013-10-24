#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use App::Rad;
use Data::Dumper;
use PagSeguro::API;

# show transactions
sub transaction
:Help("get the transaction:\n\t--email=you\@email.com\n\t--code=[transaction_code]\n\t--token=[account_token]"){
    my $c = shift;

    my $ps = PagSeguro::API->new(
        email => $c->options->{email}, token => $c->options->{token}
    );

    if($c->options->{code}){
        my $code = $c->options->{code} || undef;
        print Dumper $ps->transaction->load($code);

        return;
    }
}

# app run
App::Rad->run;
