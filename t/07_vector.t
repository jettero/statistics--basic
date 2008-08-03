
use strict;
use Test;
use Statistics::Basic::Vector;

plan tests => 18;

my $normalize    = undef;
my $no_normalize = 1;

my  $v = new Statistics::Basic::Vector([1 .. 3]);
ok( $v->size, 3 );

$v->set_size( 4, $normalize ); # fix_size() fills in with 0s
ok( $v->size, 4 ); 

$v->set_size( 6, $no_normalize ); # waits for you to insert()
ok( $v->size, 4 );

$v->insert(5);     # this runs the normalizer whether you like it or not
ok( $v->size, 6 ); # and of course, by normalizer, we mean 0-padder

$v->insert( [10..13], 14..15 );
ok( $v->size, 6 );

my $j = new Statistics::Basic::Vector;
ok( $j->size, 0 );

$j->set_vector([7,9,21]);
ok( $j->size, 3 );
ok( $j, "[7, 9, 21]");

$j->set_size(0);
ok( $j, "[]" );
ok( $j->size, 0 );

my $k = $j->copy;
   $k->ginsert(7);
   $j->ginsert(9);

ok( $j->size, 1 );
ok( $k->size, 1 );

$j->ginsert(7);

ok( $j->size, 2 );
ok( $k->size, 1 );

ok( $j, "[9, 7]" );
ok( $k, "[7]" );

$k->set_vector($j);
$j->ginsert(33);

ok( $j, "[9, 7, 33]" );
ok( $k, "[9, 7, 33]" );
