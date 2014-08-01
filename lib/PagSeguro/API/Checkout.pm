package PagSeguro::API::Checkout;
use base 'PagSeguro::API::Base';

use XML::Simple;

# constructor
sub new {
    my $class = shift;
    my %args = @_ if ( @_ % 2 ) == 0;

    return bless {
        email => $args{email} || undef,
        token => $args{token} || undef,

        _code        => undef,
        _transaction => undef,
    }, $class;
}

# accessors
sub code {
    return $_[0]->{_code} if $_[0]->{_code};
}

# methods
sub send {
    my $self = shift;
    my %args = ( @_ % 2 ) == 0 ? @_ : undef;

    $self->{_code} = undef;

    if ( scalar(%args) ) {

        # parse and return by file
        return XMLin( $args{file} ) if $args{file};

        # default parameters that you dont have to pass
        $args{email}        = $args{email}        || $self->{email};
        $args{token}        = $args{token}        || $self->{token};
        $args{currency}     = $args{currency}     || 'BRL';
        $args{shippingType} = $args{shippingType} || '3';

        my $uri = $self->_checkout_uri( \%args );
        my $response = $self->post( $uri, \%args );

        # debug
        warn "[Debug] Checkout Response: $response\n"
          if $ENV{PAGSEGURO_API_DEBUG};

        my $xml = XMLin($response);

        # save code for payment url
        $self->{_code} = $xml->{code} if $xml->{code};

        return $xml;
    }
    else {
        # error
        die "Error: invalid paramether bound";
    }
}

sub payment_url {
    my ($self, $code) = @_;

    $code = $self->code unless $code;
    
    my $uri = join '',
      (
        $self->resource(
            ( $ENV{PAGSEGURO_API_SANDBOX} ? 'SANDBOX_CHECKOUT_PAYMENT' : 'CHECKOUT_PAYMENT' )
        ),
        "?code=",
        $code
      );

    warn "[Debug] URI: $uri\n" if $ENV{PAGSEGURO_API_DEBUG};
    return $uri;
}

sub _checkout_uri {
    my ( $self, $args ) = @_;

    # add email and token
    $args->{email} = $args->{email} || $self->{email};
    $args->{token} = $args->{token} || $self->{token};

    # build query string
    my $query_string = join '&', map { "$_=$args->{$_}" } keys %$args;

    my $uri = join '',
      (
        $self->resource(
            ( $ENV{PAGSEGURO_API_SANDBOX} ? 'SANDBOX_URI' : 'BASE_URI' )
        ),
        $self->resource('CHECKOUT'),
        "?",
        $query_string
      );

    warn "[Debug] URI: $uri\n" if $ENV{PAGSEGURO_API_DEBUG};
    return $uri;
}

1;
