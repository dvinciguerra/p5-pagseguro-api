package PagSeguro::API;

# ABSTRACT: PagSeguro::API - UOL PagSeguro Payment Gateway API Module
our $VERSION = '0.009.1';

use Moo;

use PagSeguro::API::Payment;
use PagSeguro::API::Transaction;
use PagSeguro::API::Notification;

# attributes
has email => (is => 'rw');
has token => (is => 'rw');

has environment => (is => 'rw', default => sub {'production'});
has debug       => (is => 'rw', default => sub {0});

# methods
sub payment_request {
    my $self = shift;

    return PagSeguro::API::Payment->new(%{$self->_config});
}

sub notification {
    my $self = shift;

    return PagSeguro::API::Notification->new(%{$self->_config});
}

sub transaction {
    my $self = shift;

    return PagSeguro::API::Transaction->new(%{$self->_config});
}

sub _config {
    my $self = shift;
    return {
        email => $self->email,
        token => $self->token,

        debug       => $self->debug,
        environment => $self->environment,
    };
}


1;
__END__

=encoding utf8

=head1 NAME

PagSeguro::API - I<PagSeguro> Payment Gateway Module

=head1 SYNOPSIS

    use PagSeguro::API;
    my $p = PagSeguro::API->new;


    # configure api authentication
    $p->email('foo@bar.com');
    $p->token('95112EE828D94278BD394E91C4388F20');


    # create a new payment
    my $payment = $p->payment_request;
    $payment->reference('PRODUCT_ID:XXX');
    $payment->notification_url('http://google.com');
    $payment->redirect_url('http://url_of_love.com.br');


    $payment->add_item(
        id          => $product->id,
        description => $product->title,
        amount      => $product->price,
        weight      => $product->weight
    );

    # request payment checkout
    my $response = $payment->request;

    # error
    die "Error: ". $response->error if $response->error;
   

=head1 DESCRIPTION

PagSeguro API module implementation.

This module provide a way to communicate with PagSeguro payment gateway as easy 
as possible.

Because PagSeguro is a brazilian company that provide this payment gaeway, I 
will write this docs in portuguese.

If you need some help to use it, please, send me an e-mail with details of what
you need help.

B<< Agora Em Portugues >>

Modulo de implementação da API do I<PagSeguro>.

Este modulo provê uma forma de comunicar-se com o sistema de pagamento I<PagSeguro>
de forma simples.


=head3 Status

Alguns dados sobre o andamento do projeto:

=over

=item DONE

    - checkout via api

    - url de pagamento

    - consulta de transações por código

    - consulta de transações por range de datas

    - consulta de transações abandonadas

=item TODO

    - consulta notificações

    - pagamento por formulário

    - checkout transparente

=back

=head1 AUTHOR

Daniel Vinciguerra <daniel.vinciguerra at bivee.com.br>

2013-2015 E<copy> Bivee - L<http://bivee.com.br>

It is free software; you can redistribute it and/or modify it under the same 
terms of perl license.

