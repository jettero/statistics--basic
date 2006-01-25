# vi:fdm=marker fdl=0 syntax=perl:
# $Id: 10_mode.t,v 1.1 2006-01-25 22:20:42 jettero Exp $

use strict;
use Test;
use Statistics::Basic::Mode;

plan tests => 6;

my  $sbm = new Statistics::Basic::Mode([1..3]);

ok( $sbm->query == 1 );

    $sbm->insert( 3 );
ok( $sbm->query == 3 );

    $sbm->set_size( 5 );
ok( $sbm->query == 3 );

    $sbm->ginsert( 2 );
ok( $sbm->query == 3 );

    $sbm->set_vector( [2, 3..5, 7, 0, 0] );
ok( $sbm->query == 0 );

my  $j = new Statistics::Basic::Mode;
    $j->set_vector( [1, 2, 3, 3, 3, 2] );
ok( $j->query == 3 );
