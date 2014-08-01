package PagSeguro::API::Notification;
use base 'PagSeguro::API::Base';

use LWP::Simple;
use XML::Simple;

# constructor
sub new {
    my $class = shift;
    my %args = @_ if ( @_ % 2 ) == 0;

    return bless {
        email => $args{email} || undef,
        token => $args{token} || undef,

        _notification => undef,
    }, $class;
}

# methods
sub load {
    my $self = shift;    

    my %args;
    $args{file} = $_[1] if $_[0] && $_[1];

    if ( %args ) {
        # parse and return by file
        return XMLin( $args{file} ) if $args{file};
    }

    my $response = get $self->_code_uri( $_[0] ) || '';
    
    # debug
    warn "[Debug] Notification Response: $response\n"
      if $ENV{PAGSEGURO_API_DEBUG};

    return XMLin($response);
}

sub _code_uri {
    my ( $self, $code ) = @_;

    my $uri = join '',
      (
        $self->resource(
            ( $ENV{PAGSEGURO_API_SANDBOX} ? 'SANDBOX_URI' : 'BASE_URI' )
        ),
        $self->resource('TRANSACTION'),
        $self->resource('NOTIFICATIONS'),
        "${code}",
        "?email=" . $self->{email},
        "&token=" . $self->{token},
      );

    warn "[Debug] URI: $uri\n" if $ENV{PAGSEGURO_API_DEBUG};
    return $uri;
}

1;
__END__

=pod

=head1 NAME

PagSeguro::API::Notification - Notification Class for PagSeguro::API module

=head1 SYNOPSIS

    use PagSeguro::API;

    # new instance
    my $ps = PagSeguro::API->new(
        email=> 'foo@bar.com', token=>'95112EE828D94278BD394E91C4388F20'
    );


    # notification obj
    my $t = $ps->notification;

    # load notification by code
    my $notification = $t->load('766B9C-AD4B044B04DA-77742F5FA653-E1AB24');
    

    # notification returns perl hash
    say $notification->{code}; # 00000000-0000-0000-0000-000000000000


=head1 DESCRIPTION

L<PagSeguro::API::Notification> is a class that provide access to transaction
api search methods.


=head1 ACCESSORS

Public properties and their accessors

=head3 resource
    
    my $t = $ps->notification;
    say $t->resource('BASE_URI');

L<PagSeguro::API::Resource> is a container that store all connectoin url
parts and some other things;


=head1 METHODS

=head3 new

    # new instance
    my $ps = PagSeguro::API::Notification->new(
        email => 'foo@bar.com', token => '95112EE828D94278BD394E91C4388F20'
    );


=head3 load

    # getting notification class instance
    my $t = $ps->notification;

    # load notification by code
    my $notification = $t->load('00000000-0000-0000-0000-000000000000');

    say $notification->{code};

This method will load a notification by code and returns a perl hash as
success result or C<undef> as error or not found;

=head1 AUTHOR

2013 (c) Bivee L<http://bivee.com.br>

Daniel Vinciguerra <daniel.vinciguerra@bivee.com.br>


=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Bivee.

This is a free software; you can redistribute it and/or modify it under the same terms of Perl 5 programming 
languagem system itself.

=cut
