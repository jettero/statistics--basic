
use strict;
use Test;
use Statistics::Basic;

plan tests => 6;

my  $sbm = new Statistics::Basic::Median([1 .. 3]);

ok($sbm->query, 2);

$sbm->insert( 10 );
ok($sbm->query, 3);

$sbm->set_size( 5 );
ok($sbm->query, 2);

$sbm->ginsert( 9 );
ok($sbm->query, 2.5);

$sbm->set_vector( [2, 3 .. 5, 7, 0, 0] );
ok($sbm->query, 3);

my  $j = new Statistics::Basic::Median;
    $j->set_vector( [1 .. 3] );

ok($j->query, 2);
