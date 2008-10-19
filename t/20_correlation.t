
use strict;
use Test;
use Statistics::Basic qw(:all);

$ENV{TOLER} = 0.000_001;

plan tests => 7;

my  $corr = new Statistics::Basic::Correlation([1 .. 10], [1 .. 10]);
ok( $corr == 1.0 );

    $corr->insert( 11, 7 );
warn "$corr == ( (129.0/20) / (sqrt(609.0/100) * sqrt(165.0/20))))\n";
ok( $corr == ( (129.0/20) / (sqrt(609.0/100) * sqrt(165.0/20))));

    $corr->set_vector( [11 .. 13], [11 .. 13] );
ok( $corr == 1.0 );

    $corr->ginsert( 13, 12 );
ok( $corr == ( (1/2) / (sqrt(11/16) * sqrt(1/2)) ));

my  $j = new Statistics::Basic::Correlation;

    $j->set_vector( [11 .. 13], [11 .. 13] );
ok( $j == 1.0 );

my $c = correlation([4,7,7], [4,7,7]);
ok( $c == 1.0 );

$c->insert(3,4);
ok( $c == correlation([7,7,3], [7,7,4]) );
