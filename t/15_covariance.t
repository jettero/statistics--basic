
use strict;
use Test;
use Statistics::Basic::CoVariance;

plan tests => 7;

my  $cov = new Statistics::Basic::CoVariance([1 .. 3], [1 .. 3]);

ok( $cov->query, (2/3) );

    $cov->set_size( 4 );
ok( $cov->query, (5/4) );

    $cov->insert( 9, 9 );
ok( $cov->query, (45/4) );

    $cov->insert( [10 .. 11], [11 .. 12] );
ok( $cov->query, (83/4) );

    $cov->set_vector( [10 .. 11], [11 .. 12] );
ok( $cov->query, (1/4) );

    $cov->ginsert( [13, 0], [13, 0] );
ok( $cov->query, (105/4) );


my  $j = new Statistics::Basic::CoVariance;
    $j->set_vector([1 .. 3], [1 .. 3]);

ok( $j->query, (2/3) );
