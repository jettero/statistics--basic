
use strict;
use Test;
use Statistics::Basic qw(:all);

$ENV{TOLER} = 0.000_001;
delete $ENV{TOLER};

plan tests => (my $t = 2);

unless( eval 'use Math::BigFloat; 1' ) {
    warn " [skipping all Math::BigFloat tests, as it does't appear to load]\n";
    skip(1,1,1) for 1 .. $t;
    exit 0;
}

my $corr = new Statistics::Basic::Correlation([ map {Math::BigFloat->new($_)} 1 .. 10], [ map {Math::BigFloat->new($_)} 1 .. 10]);
ok( $corr == 1 );

$corr->insert( map {Math::BigFloat->new($_)} 11, 7 );
ok( $corr, ( (Math::BigFloat->new(129)/20) / (sqrt(Math::BigFloat->new(609)/100) * sqrt(Math::BigFloat->new(165)/20))));
