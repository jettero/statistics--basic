
use strict;
use Test;
use Statistics::Basic qw(:all);
use Scalar::Util qw(refaddr);

plan tests => 3;

my $v1 = vector([1 .. 5]);
my $v2 = $v1->copy;

ok( refaddr($v1) != refaddr($v2) );

my $c = correlation($v1, $v2);

ok( $c, 1 );
ok( refaddr($c->query_vector1), refaddr($v1) );
ok( refaddr($c->query_vector2), refaddr($v2) );
