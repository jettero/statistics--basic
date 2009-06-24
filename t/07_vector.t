
use strict;
use Test;
use Statistics::Basic;

plan tests => 27;

my  $v = new Statistics::Basic::Vector([1 .. 3]);
ok( $v->size, 3 );

$v->set_size( 4 ); # fix_size() fills in with 0s
ok( $v->size, 4 ); 
ok( $v->query_filled );

{ local $ENV{NOFILL} = 1;
    $v->set_size( 6 ); # waits for you to insert()
    ok( $v->size, 4 );
    ok( !$v->query_filled );

    $v->insert( 9 ); # waits for you to insert()
    ok( $v->size, 5 );
    ok( !$v->query_filled );
}

$v->insert(5); # auto fills
ok( $v->size, 6 );

$v->insert( [10..13], 14..15 );
ok( $v->size, 6 );

my $j = new Statistics::Basic::Vector;
ok( $j->size, 0 );

$j->set_vector([7,9,21]);
ok( $j->size, 3 );
do { local $ENV{DEBUG}=0; ok( $j, "[7, 9, 21]"); };

$j->set_size(0);
do { local $ENV{DEBUG}=0; ok( $j, "[]" ); };
ok( $j->size, 0 );

my $k = $j->copy;
   $k->ginsert(7);
   $j->ginsert(9);

ok( $j->size, 1 );
ok( $k->size, 1 );

$j->ginsert(7);

ok( $j->size, 2 );
ok( $k->size, 1 );

do { local $ENV{DEBUG}=0; ok( $j, "[9, 7]" ); };
do { local $ENV{DEBUG}=0; ok( $k, "[7]" ); };

$k->set_vector($j);
$j->ginsert(33);

do { local $ENV{DEBUG}=0; ok( $j, "[9, 7, 33]" ); };
do { local $ENV{DEBUG}=0; ok( $k, "[9, 7, 33]" ); };

my $w = $j->copy;
ok( $w->size, $j->size );
do { local $ENV{DEBUG}=0; ok( $w, $j ); };

$w->ginsert(6);
ok( $w->size-1, $j->size );
do { local $ENV{DEBUG}=0;
    my $str = "$w"; ok($str =~ s/, 6//, 1);
    ok( $str, $j );
};
