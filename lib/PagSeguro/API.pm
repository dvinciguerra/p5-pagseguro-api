package PagSeguro::API;
use strict;
use warnings;
our $VERSION = '0.004';

use PagSeguro::API::Checkout;
use PagSeguro::API::Transaction;
use PagSeguro::API::Notification;

# constructor
sub new {
    my $class = shift;
    my %args = @_ if (@_ % 2) == 0;

    # start resource
    PagSeguro::API::Resource->instance;

    # check env vars
    $args{email} = $ENV{PAGSEGURO_API_EMAIL} || undef
        unless $args{email};

    $args{token} = $ENV{PAGSEGURO_API_TOKEN} || undef
        unless $args{token};

    # enable sandbox
    $ENV{PAGSEGURO_API_SANDBOX} = $args{sandbox} 
        if $args{sandbox};

    # enable debug
    $ENV{PAGSEGURO_API_DEBUG} = $args{debug} 
        if $args{debug};

    return bless {
        _email => $args{email} || undef,
        _token => $args{token} || undef,

        _checkout     => undef,
        _transaction  => undef,
        _notification => undef,
    }, $class;
}

# accessors
sub email {
    $_[0]->{_email} = $_[1] if $_[1];
    return shift->{_email};
}

sub token {
    $_[0]->{_token} = $_[1] if $_[1];
    return shift->{_token};
}

# methods
sub transaction {
    my $self = shift;

    # error
    die "Exception: e-mail or token undef" 
        unless $self->email && $self->token;

    # manual instance
    $self->{_transaction} = $_[0] 
        if $_[0] && $_[0]->isa('PagSeguro::API::Transaction');


    $self->{_transaction} = PagSeguro::API::Transaction->new(
        email => $self->email, token => $self->token
    ) unless $self->{_transaction};

    return $self->{_transaction};
}

sub notification {
    my $self = shift;

    # error
    die "Exception: e-mail or token undef" 
        unless $self->email && $self->token;

    # manual instance
    $self->{_notification} = $_[0] 
        if $_[0] && $_[0]->isa('PagSeguro::API::Notification');


    $self->{_notification} = PagSeguro::API::Notification->new(
        email => $self->email, token => $self->token
    ) unless $self->{_notification};

    return $self->{_notification};
}

sub checkout {
    my $self = shift;

    # error
    die "Exception: e-mail or token undef" 
        unless $self->email && $self->token;

    # manual instance
    $self->{_checkout} = $_[0] 
        if $_[0] && $_[0]->isa('PagSeguro::API::Checkout');


    $self->{_checkout} = PagSeguro::API::Checkout->new(
        email => $self->email, token => $self->token
    ) unless $self->{_checkout};

    return $self->{_checkout};
}


1;
__END__

=pod

=head1 NAME

PagSeguro::API - UOL PagSeguro Payment Gateway API Module

=head1 SYNOPSIS

    use PagSeguro::API;

    # new instance
    my $ps = PagSeguro::API->new(
        debug   => 1,                   # enable debug
        sandbox => 1,                   # enable sandbox
        email   => 'sandbox@bar.com', 
        token   =>'95112EE828D94278BD394E91C4388F20'
    );


    # load transaction by code
    my $transaction = $ps->transaction
        ->load('TRANSACTION_CODE_HERE');

    # api xml response to perl hash
    say $transaction->{sender}->{name}; # Foo Bar

=head1 VARS

Enviroment variables that you can define to configure your access, 
debug mode, sandbox use, etc...

=head2 email

Configure email to access api.

    my $ps = PagSeguro::API->new( email => 'joe@doe.com' );

or you can use env var

    $ENV{PAGSEGURO_API_EMAIL} = 'joe@doe.com';

=head2 token

Configure token to access api.

    my $ps = PagSeguro::API->new( token => '95112EE828D94278BD394E91C4388F20' );

or you can use env var

    $ENV{PAGSEGURO_API_TOKEN} = '95112EE828D94278BD394E91C4388F20';

=head2 sandbox

Configure module to use sandbox mode (default is 0).

    my $ps = PagSeguro::API->new( sandbox => 1 );

or you can use env var

    $ENV{PAGSEGURO_API_SANDBOX} = 1;

=head2 debug

Configure module to use debug mode (default is 0).

    my $ps = PagSeguro::API->new( debug => 1 );

or you can use env var

    $ENV{PAGSEGURO_API_DEBUG} = 1;


=head1 ACCESSORS

Public properties and their accessors

=head2 email

This is the user registered email that you need to use PagSeguro payment API.

    # get or set email property
    $ps->email('foo@bar.com');
    say $ps->email; 

*email is a required properties to access HTTP GET based API urls.


=head2 token

This is a key that you need to use PagSeguro payment API.
    
    # get or set token property
    $ps->token('95112EE828D94278BD394E91C4388F20');
    say $ps->token;

*token is a required properties to access HTTP GET based API urls.


=head1 METHODS

=head2 new

    my $ps = PagSeguro::API->new;

or pass paramethers...

    my $ps = PagSeguro::API->new(
        email => 'foo@bar.com', token => '95112EE828D94278BD394E91C4388F20'
    );

=head2 checkout

    # getting product checkout class instance
    my $c = $ps->checkout;
    
    $ps->checkout( PagSeguro::API::Checkout->new );


=head2 transaction

    # getting transaction class instance
    my $t = $ps->transaction;
    
    $ps->transaction( PagSeguro::API::Transaction->new );


L<PagSeguro::API::Transaction> is a class that will provide access to transaction
methods for API.

See more informations about at L<PagSeguro::API::Transaction>.

=head2 notification

    # getting notification class instance
    my $n = $ps->notification;
    
    $ps->notification( PagSeguro::API::Notification->new );


L<PagSeguro::API::Notification> is a class that will provide access to notification
methods for API.

See more informations about at L<PagSeguro::API::Notification>.

=head1 BUG

Please, send bug reports to my CPAN user email at dvinci@cpan.org.

git-repository: 

L<https://github.com/dvinciguerra/p5-pagseguro-api>


=head1 AUTHOR

Daniel Vinciguerra <daniel.vinciguerra@bivee.com.br>

2013 (c) Bivee L<http://bivee.com.br>


=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Bivee.

This is a free software; you can redistribute it and/or modify it under the same terms of Perl 5 programming 
languagem system itself.

=cut
