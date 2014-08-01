#!/usr/bin/env perl
use Mojolicious::Lite;

use FindBin;
use lib "$FindBin::Bin/../lib";

use PagSeguro::API;

###########
# HELPERS
###########
# pagseguro object helper
helper 'payment' => sub {
    my $self = shift;

    #########################################
    # CHANGE: email and token config
    # (add your sandbox config here)
    #########################################
    $ENV{PAGSEGURO_API_EMAIL} = 'foo@bar.com';
    $ENV{PAGSEGURO_API_TOKEN} = '95112EE828D94278BD394E91C4388F20';

    my $ps = PagSeguro::API->new( sandbox => 1 );
    return $ps->checkout;
};

helper 'current_user' => sub {
    return {
        name  => 'Jose Comprador',
        email => 'comprador@sandbox.pagseguro.com.br',
    };
};

###########
# ACTIONS
###########
get '/' => 'index';

post '/' => sub {
    my $self = shift;

    # current signed in user
    my $current_user = $self->current_user;

    my %params;
    $params{senderName}  = $current_user->{name};
    $params{senderEmail} = $current_user->{email};

    # form params
    map { $params{$_} = $self->param($_) if $self->param($_); }
      qw/itemId1 itemDescription1 itemAmount1
      itemQuantity1 itemWeight1 reference/;

    # send checkout request
    my $checkout = $self->payment('checkout');
    $checkout->send(%params);

    # redirect user to payment link if code has been
    # received from api
    return $self->redirect_to( $checkout->payment_url )
      if $checkout->code;

    # TODO render exception or error
    # return $self_render_not_found
};

app->start;
__DATA__

@@ index.html.ep
% layout 'default';
% title 'Welcome';
<h3>e-Commerce of Joe Doe - Product Notebook</h3>
<fieldset>
    <legend>Product Details</legend>

    <p><strong>Currency:</strong> Brazil Real</p>
    <p><strong>Id:</strong> 0001 </p>
    <p><strong>Description:</strong> Notebook </p>
    <p><strong>Amount:</strong> 24300.00 </p>
    <p><strong>Quantity1:</strong> 1 </p>
    <p><strong>Weight1:</strong> 1000 </p>

    <h5>Other Informations:</h5>
    <p><strong>Reference:</strong> REF1234 </p>

    <form method="post">
        <input type="hidden" name="itemId1" value="0001" />
        <input type="hidden" name="itemDescription1" value="Notebook Prata" />
        <input type="hidden" name="itemAmount1" value="24300.00" />
        <input type="hidden" name="itemQuantity1" value="1" />
        <input type="hidden" name="itemWeight1" value="1000" />
        <input type="hidden" name="reference" value="REF1234" />

        <button type="submit">Buy Now</button>
    </form>

</fieldset>

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title>e-Commerce example page</title></head>
  <body><%= content %></body>
</html>
