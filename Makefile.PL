# vi:set syntax=perl:

use strict;
use 5.008_001; # required for: my $b = bless {v1=>1, v2=>2}, "blarg"; warn $_ for keys %$b;
# BEGIN {
# #NOTE# I thought about being this way, but it turns out Number::Format needs 5.8.0 anyway
#
#     die "perl 5.8.0 has too many bugs to express bless {key=>'value'}, 'class' correctly"
#         if $] == 5.008_000;
# }
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'          => 'Statistics::Basic',
    'VERSION_FROM'  => 'Basic.pm',
    'PREREQ_PM'     => { 
        'Number::Format' => 1.61,
        'Scalar::Util'   => 0,
    }
);
