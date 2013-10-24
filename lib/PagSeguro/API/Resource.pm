package PagSeguro::API::Resource;

sub get {
    my ($class, $code) = @_;

    while(<DATA>){
        chomp $_;

        if($_ =~ /^$code/){
            my ($key, $value) = split /=/, $_;
            return $value if $value;
        }
    }

    return undef;
}

1;

__DATA__
BASE_URI=https://ws.pagseguro.uol.com.br
TRANSACTION=/v2/transactions/
ABANDONED=abandoned
