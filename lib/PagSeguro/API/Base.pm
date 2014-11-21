package PagSeguro::API::Base;
use Moo;

use XML::LibXML;

# attributes
has email => (is => 'rw');
has token => (is => 'rw');

has environment => (is => 'rw', default => sub { 'production' });
has debug => (is => 'rw', default => sub { 0 });

sub base_uri {
    my $self = shift;
    return $self->environment eq 'production'?
        'https://pagseguro.uol.com.br' :
        'https://sandbox.pagseguro.uol.com.br';
}

sub api_uri {
    my $self = shift;
    return $self->environment eq 'production'?
        'https://ws.pagseguro.uol.com.br/v2' :
        'https://ws.sandbox.pagseguro.uol.com.br/v2';
}

sub xml {
    my $self = shift;

    my $xml = XML::LibXML->new;
    my $doc = $xml->parse_string( $_[0] ) if $_[0];

    return $doc;
}

1;
