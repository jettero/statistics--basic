# vi:set syntax=perl:

use strict;
use 5.008_001; # required for: my $b = bless {v1=>1, v2=>2}, "blarg"; warn $_ for keys %$b;

use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'          => 'Statistics::Basic',
    'VERSION_FROM'  => 'Basic.pm',

    'PREREQ_PM'     => { 
        'Number::Format' => 1.61,
        'Scalar::Util'   => 0,
    },

    ($ExtUtils::MakeMaker::VERSION ge '6.48'? 
        (MIN_PERL_VERSION => 5.008,
            META_MERGE => {
                keywords => ['stats','statistics', 'mean', 'average', 'correlation'],
                resources=> {
                    repository => 'http://github.com/jettero/statistics--basic/tree',
                },
            },

        LICENSE	=> 'lgpl2',
    ) : ()),

);
