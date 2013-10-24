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

        _transaction => undef,
    }, $class;
}


# accessors
sub resource {
    return (PagSeguro::API::Resource->get($_[1]) || undef) if $_[1];
}

# methods
sub load {
    my ($self, $code) = @_;

    my $response = get $self->_code_uri($code) || '';
    return XMLin($response);
}

sub search {
    my $self = shift;
    my %args = (@_ % 2) == 0? @_: undef;

    my $response = get $self->_date_uri(
        $args{initial}, $args{final}, $args{page}, $args{max}
    ) || '';

    return XMLin($response);
}

sub abandoned {
    my $self = shift;
    my %args = (@_ % 2) == 0? @_: undef;

    my $response = get $self->_abandoned_uri(
        $args{initial}, $args{final}, $args{page}, $args{max}
    );

    return XMLin($response);
}

sub _code_uri {
    my ($self, $code) = @_;
    
    return join '', (
        $self->resource('BASE_URI'),
        $self->resource('TRANSACTION'),
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

sub _abandoned_uri {
    my ($self, $start, $end, $page, $max ) = @_;

    # defaults
    $page = 1 unless $page;
    $max = 1000 unless $max;

    return join '', (
        $self->resource('BASE_URI'),
        $self->resource('TRANSACTION'),
        $self->resource('ABANDONED'),
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

__END__

=pod

=head1 NAME

PagSeguro::API::Transaction - Transaction Class for PagSeguro::API module

=head1 SYNOPSIS

    use PagSeguro::API;

    # new instance
    my $ps = PagSeguro::API->new(
        email=> 'foo@bar.com', token=>'95112EE828D94278BD394E91C4388F20'
    );


    # transaction obj
    my $t = $ps->transaction;

    # load transaction by code
    my $transaction = $t->load('766B9C-AD4B044B04DA-77742F5FA653-E1AB24');
    
    # search transaction by date range
    my $list = $t->search(
        initial => '2013-10-01T00:00',
        final   => '2013-10-30T00:00',
        page    => 1,
        max     => 1000,
    );

    # search abandoned transaction by date range
    my $list = $t->abandoned(
        initial => '2013-10-01T00:00',
        final   => '2013-10-30T00:00',
        page    => 1,
        max     => 1000,
    );

    # transaction returns perl hash
    say $transaction->{code}; # 00000000-0000-0000-0000-000000000000


=head1 DESCRIPTION

L<PagSeguro::API::Transaction> is a class that provide access to transaction
api search methods.


=head1 ACCESSORS

Public properties and their accessors

=head3 resource
    
    my $t = $ps->transaction;
    say $t->resource('BASE_URI');

L<PagSeguro::API::Resource> is a container that store all connectoin url
parts and some other things;


=head1 METHODS

=head3 new

    # new instance
    my $ps = PagSeguro::API::Transaction->new(
        email => 'foo@bar.com', token => '95112EE828D94278BD394E91C4388F20'
    );


=head3 load

    # getting transaction class instance
    my $t = $ps->transaction;

    # load transaction by code
    my $transaction = $t->load('00000000-0000-0000-0000-000000000000');

    say $transaction->{code};

This method will load a transaction by code and returns a perl hash as
success result or C<undef> as error or not found;


=head3 search

    # getting transaction class instance
    my $t = $ps->transaction;

    # load transaction by date range
    my $list = $t->search(
        initial => '2013-10-01T00:00', 
        final   => '2013-10-30T00:00', 
        page    => 1, 
        max     => 10000
    );

This method will get a list of transactions by date range and returns a 
perl hash as success result or C<undef> as error or not found;


=head3 abandoned

    # getting transaction class instance
    my $t = $ps->transaction;

    # load abandoned transaction by date range
    my $list = $t->abandoned(
        initial => '2013-10-01T00:00', 
        final   => '2013-10-30T00:00', 
        page    => 1, 
        max     => 10000
    );

This method will get a list of abandoned transactions by date range and 
returns a perl hash as success result or C<undef> as error or not found;


=head1 AUTHOR

2013 (c) Bivee L<http://bivee.com.br>

Daniel Vinciguerra <daniel.vinciguerra@bivee.com.br>


=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Bivee.

This is a free software; you can redistribute it and/or modify it under the same terms of Perl 5 programming 
languagem system itself.

=cut
