# vi:set syntax=perl:

use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'          => 'Statistics::Basic',
    'VERSION_FROM'  => 'Basic.pm',
    'PREREQ_PM'     => { 
        'Number::Format' => 1.52,
        'Scalar::Util'   => 0,
    }
);
