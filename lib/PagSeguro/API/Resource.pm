package PagSeguro::API::Resource;

our $_instance;

sub instance {
    my $class = shift;

    unless ($_instance){
        my $self;

        map{
            chomp;
            my ($k, $v) = split /=/, $_;
            $self->{_res}->{$k} = $v;
        } <DATA>;

        $_instance = bless $self, $class;
    }

    return $_instance;
}

# static methods
sub get {
    my ($self, $code) = @_;
    return $self->{_res}->{$code};
}

1;

__DATA__
BASE_URI=https://ws.pagseguro.uol.com.br
SANDBOX_URI=https://ws.sandbox.pagseguro.uol.com.br
CHECKOUT=/v2/checkout/
TRANSACTION=/v2/transactions/
ABANDONED=abandoned
NOTIFICATIONS=notifications/
