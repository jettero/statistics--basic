
use strict;
use Test;
use Statistics::Basic;

plan tests => 4;

my $i = eval { Statistics::Basic::Vector->new([ 1 .. 30 ]) };
my $j = $i->copy;

$i->set_computer( my_computer => sub { $j->set_vector([ grep {$_<= 3} $i->query ]) });

ok( $j->size, 3 );
do { local $ENV{DEBUG}=0; ok( $j, "[1, 2, 3]" ); };

$i->insert( 2 );

ok( $j->size, 3 );
do { local $ENV{DEBUG}=0; ok( $j, "[2, 3, 2]" ); };
