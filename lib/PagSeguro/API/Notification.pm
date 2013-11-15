package PagSeguro::API::Transaction;

use LWP::Simple;
use XML::Simple;
use PagSeguro::API::Resource;

# constructor
sub new {
    my $class = shift;
    my %args = @_ if (@_ % 2) == 0;

    return bless {
        _email => $args{email} || undef,
        _token => $args{token} || undef,

        _notification => undef,
    }, $class;
}


# accessors
sub resource {
    return PagSeguro::API::Resource->get($_[1]) if $_[1];
}

# methods
sub load {
    my ($self, $code) = @_;

    my $response = get $self->_code_uri($code);
    return XMLin($response);
}


sub search {
    my $self = shift;
    my %args = (@_ % 2) == 0? @_: undef;

    my $response = get $self->_date_uri(
        $args{initial}, $args{final}, $args{page}, $args{max}
    );

    return XMLin($response);
}

sub _code_uri {
    my ($self, $code) = @_;
    
    return join '', (
        $self->resource('BASE_URI'),
        $self->resource('TRANSACTION'),
        $self->resource('NOTIFICATIONS'),
        "${code}",
        "?email=". $self->email,
        "&token=". $self->token,
    );
}

sub _date_uri {
    my ($self, $start, $end, $page, $max ) = @_;

    # defaults
    $page = 1 unless $page;
    $max = 1000 unless $max;

    return join '', (
        $self->resource('BASE_URI'),
        $self->resource('TRANSACTION'),
        "?initialDate=${start}",
        "&finalDate=${end}",
        "&page=${page}",
        "&maxPageResults=${max}",
        "&email=". $self->email,
        "&token=". $self->token,
    );
}


sub DESTROY { }

1;
