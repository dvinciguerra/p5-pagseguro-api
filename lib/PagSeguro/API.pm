package PagSeguro::API;
use strict;
use warnings;
our $VERSION = '0.001';

use PagSeguro::API::Transaction;
#use PagSeguro::API::Notification;


# constructor
sub new {
    my $class = shift;
    my %args = @_ if (@_ % 2) == 0;

    return bless {
        _email => $args{email} || undef,
        _token => $args{token} || undef,

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

1;
__END__

=pod

=head1 NAME

PagSeguro::API - UOL PagSeguro Payment Gateway API Module

=head1 SYNOPSIS

    use PagSeguro::API;

    # new instance
    my $ps = PagSeguro::API->new(
        email=> 'foo@bar.com', token=>'95112EE828D94278BD394E91C4388F20'
    );


    # load transaction by code
    my $transaction = $ps->transaction
        ->load('TRANSACTION_CODE_HERE');

    # api xml response to perl hash
    say $transaction->{sender}->{name}; # Foo Bar

    ...

    my $notification = $ps->notification
        ->load('NOTIFICATION_CODE_HERE');

    # transaction code associated to this notification
    say $notification->{code}; # 00000000-0000-0000-0000-000000000000 


=head1 ACCESSORS

Public properties and their accessors

=head3 email
    
    # get or set email property
    $ps->email('foo@bar.com');
    say $ps->email; 

Email is a required properties to access HTTP GET based API urls.


=head3 token
    
    # get or set token property
    $ps->token('95112EE828D94278BD394E91C4388F20');
    say $ps->token;

Token is a required properties to access HTTP GET based API urls.


=head1 METHODS

=head3 new

    my $ps = PagSeguro::API->new;

or pass paramethers...

    my $ps = PagSeguro::API->new(
        email => 'foo@bar.com', token => '95112EE828D94278BD394E91C4388F20'
    );


=head3 transaction

    # getting transaction class instance
    my $t = $ps->transaction;

    # setting new transaction instance
    $ps->transaction( PagSeguro::API::Transaction->new );


L<PagSeguro::API::Transaction> is a class that will provide access to transaction
methods for API.

See more informations about at L<PagSeguro::API::Transaction>.


=head1 AUTHOR

Daniel Vinciguerra <daniel.vinciguerra@bivee.com.br>

2013 (c) Bivee L<http://bivee.com.br>


=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Bivee.

This is a free software; you can redistribute it and/or modify it under the same terms of Perl 5 programming 
languagem system itself.

=cut
