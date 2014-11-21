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

has environment => (is => 'rw', default => sub { 'production' });
has debug => (is => 'rw', default => sub { 0 });

# methods
sub payment_request {
    my $self = shift;

    return PagSeguro::API::Payment
        ->new( %{$self->_config} );
}

sub notification {
    my $self = shift;

    return PagSeguro::API::Notification
        ->new( %{$self->_config} );
}

sub transaction {
    my $self = shift;

    return PagSeguro::API::Transaction
        ->new( %{$self->_config} );
}

sub _config {
    my $self = shift;
    return {
        email => $self->email,
        token => $self->token,

        debug => $self->debug,
        environment => $self->environment,
    };
}


1;
__END__

=for comment

    use PagSeguro::API;

    # new instance
    my $p = PagSeguro::API->new;
    
    #configure
    $p->email('foo@bar.com');
    $p->token('95112EE828D94278BD394E91C4388F20');

    # new payment
    my $payment = $p->payment_request;
    $payment->reference('XXX');
    $payment->notification_url('http://google.com');
    $payment->redirect_url('http://url_of_love.com.br');

    $payment->add_item(
        id          => $product->id,
        description => $product->title,
        amount      => $product->price,
        weight      => $product->weight
    );

    my $response = $payment->request;

    # error
    die "Error: ". $response->error if $response->error;

=head1 DESCRIPTION

PagSeguro API implementation.

This module provide a way to communicate with PagSeguro
payment gateway as easy as possible.

B<NOTE>
This is a very new module, then some public api(methods) 
can be changed/updates without warning, it can contain 
some bug or pieces of implementation that cannot working 
very well.

Please, dont use this code in production!

=head1 AUTHOR

Daniel Vinciguerra <daniel.vinciguerra at bivee.com.br>

