# vi:set syntax=perl:

use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'          => 'Statistics::Basic',
    'VERSION_FROM'  => 'Basic.pm',
    'PREREQ_PM'     => { 
        'Number::Format' => 0,
        'Scalar::Util'   => 0,
    }
);
