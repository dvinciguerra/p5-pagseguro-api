package PagSeguro::API::Checkout;
use base 'PagSeguro::API::Base';

use XML::Simple;

# constructor
sub new {
    my $class = shift;
    my %args = @_ if (@_ % 2) == 0;

    return bless {
        email => $args{email} || undef,
        token => $args{token} || undef,

        _transaction => undef,
    }, $class;
}

# methods
sub send {
    my $self = shift;
    my %args = (@_ % 2) == 0? @_: undef;

    # parse and return by file
    return XMLin($args{file}) if $args{file};

    # default parameters that you dont have to pass
    $args{currency} = $args{currency} || 'BRL';

    my $response = $self->post($self->_checkout_uri( \%args ), \%args) || '';

    return XMLin($response);
}

sub _checkout_uri {
    my ($self, $args) = @_;

    # add email and token
    $args->{email} = $args->{email} || $self->{email};
    $args->{token} = $args->{token} || $self->{token};

    # build query string
    my $query_string = join '&', map {
        "$_=$args->{$_}" 
    } keys %$args;
    
    return join '', (
        $self->resource(($ENV{PAGSEGURO_API_SANDBOX}? 'SANDBOX_URI' : 'BASE_URI')),
        $self->resource('CHECKOUT'),
        "?",
        $query_string
    );
}

1;
