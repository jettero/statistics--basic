
use strict;
use Test;
use Statistics::Basic;

plan tests => 4;

my $i = Statistics::Basic::Vector->new([ 1 .. 30 ]);
my $j = Statistics::Basic::ComputedVector->new( $i );
   $j->set_filter(sub { grep {$_<= 3} @_ });

ok( $j->size, 3 );
do { local $ENV{DEBUG}=0; ok( $j, "[1, 2, 3]" ); };

$i->insert( 2 );

ok( $j->size, 3 );
do { local $ENV{DEBUG}=0; ok( $j, "[2, 3, 2]" ); };
