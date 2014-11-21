package PagSeguro::API::Util;
use Exporter 'import';
our @EXPORT = qw(camelize decamelize);

sub camelize {
    my $str = shift;
    return join '', map { 
        ucfirst lc 
    } split '_', $str;
}

sub decamelize {
    my $str = shift;
    $str =~ s/^([A-Z])(.*)$/lc($1).$2/e;

    return join '', map { 
        s/([A-Z])/_$1/; lc;  
    } split '', $str;
}

1;
