package PagSeguro::API;

use strict;
use warnings;

use PagSeguro::API::Resource;
use PagSeguro::API::Transaction;

our $VERSION = 1.0;

# constructor
sub new {
    my $class = shift;
    my %args = @_ if (@_ % 2) == 0;

    return bless {
        _email => $args{email} || undef,
        _token => $args{token} || undef,

        _transaction => undef,
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

sub transaction {
    my $self = shift;

    # error
    die "Exception: E-mail or token undef" 
        unless $self->email && $self->token;

    # manual instance
    $self->{_transaction} = $_[0] 
        if $_[0] && $_[0]->isa('PagSeguro::API::Transaction');

    # undefined transaction
    $self->{_transaction} = PagSeguro::API::Transaction->new(
        email => $self->email, token => $self->token
    ) unless $self->{_transaction};

    return $self->{_transaction};
}

sub resource {
    my ($self, $key) = shift;
    return PagSeguro::API::Resource->get($key);
}

1;
