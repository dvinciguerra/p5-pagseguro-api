
use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME         => 'PagSeguro::API',
    VERSION_FROM => 'lib/PagSeguro/API.pm',    # finds \$VERSION
    AUTHOR    => 'Daniel Vinciguerra (daniel.vinciguerra@bivee.com.br)',
    ABSTRACT  => 'PagSeguro API Client',
    PREREQ_PM => {
        'Test::More'  => 0.98,
        'XML::Simple' => 2.20,
        'LWP::Simple' => 6.00,
    },
);
