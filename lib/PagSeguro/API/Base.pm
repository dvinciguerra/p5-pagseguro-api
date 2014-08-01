package PagSeguro::API::Base;
use strict;
use warnings;

use LWP::UserAgent;
use PagSeguro::API::Resource;

sub new {
    return bless {}, shift;
}

# accessors
sub resource {
    my $self = shift;
    
    # return resources key
    my $res = PagSeguro::API::Resource->instance;
    return ($res->get($_[0]) || undef) if $_[0];
}

# method
sub get {
    my ($self, $url) = @_;

    my $ua = LWP::UserAgent->new;
    my $response = $ua->get($url) || undef;
    
    # success
    return $response->decoded_content 
        if $response && $response->is_success
}

sub post {
    my ($self, $url, $params) = @_;
    
    my $ua = LWP::UserAgent->new;
    my $response = $ua->post($url, $params) || undef;
    
    # success
    return $response->decoded_content 
        if $response && $response->is_success;

    # error
    return $response->status_line;
}


1;
