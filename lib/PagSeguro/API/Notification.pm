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
sub email {
    $_[0]->{_email} = $_[1] if $_[1];
    return shift->{_email};
}

sub token {
    $_[0]->{_token} = $_[1] if $_[1];
    return shift->{_token};
}

sub resource {
    return PagSeguro::API::Resource->get($_[1]) if $_[1];
}

# methods
sub load {
    my ($self, $code) = @_;

    my $response = get $self->code_uri($code);
    return XMLin($response);
}


sub search {
    my $self = shift;
    my %args = (@_ % 2) == 0? @_: undef;

    my $response = get $self->date_uri(
        $args{initial}, $args{final}, $args{page}, $args{max}
    );

    return XMLin($response);
}

sub code_uri {
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

sub date_uri {
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
__END__

=pod

=head1 NAME

PagSeguro::API - UOL PagSeguro Payment Gateway API Module

=head1 SYNOPSIS

    use PagSeguro::API;

    # new instance
    my $ps = PagSeguro::API->new(
        email=> 'foo@bar.com', token=>'YOUR_SECURITY_TOKEN_HERE'
    );


    # load transaction by code
    my $transaction = $ps->transaction
        ->load('TRANSACTION_CODE_HERE');

    my $transaction = $ps->transaction
        ->search( 'TRANSACTION_CODE_HERE');

    # api xml response to perl hash
    say $transaction->{sender}->{name}; # Foo Bar



=head1 DESCRIPTION


=head1 ACCESSORS

Public properties and their accessors

=head3 email
    
    # getting setted email property
    say $ps->email;

    # setting an email
    $ps->email('foo@bar.com');

Email is a required properties to access HTTP GET based API urls.

=head3 token
    
    # getting setted token property
    say $ps->token;

    # setting a token
    $ps->token('95112EE828D94278BD394E91C4388F20');

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


=head3 notification

    # getting notification class instance
    my $t = $ps->notification;

    # setting new notification instance
    $ps->notification( PagSeguro::API::Notification->new );


L<PagSeguro::API::Notification> is a class that will provide access to notification
methods for API.

See more informations about at L<PagSeguro::API::Notification>.


=head1 AUTHOR

2013 (c) Bivee L<http://bivee.com.br>

Daniel Vinciguerra <daniel.vinciguerra@bivee.com.br>


=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Bivee.

This is a free software; you can redistribute it and/or modify it under the same terms of Perl 5 programming 
languagem system itself.

=cut
