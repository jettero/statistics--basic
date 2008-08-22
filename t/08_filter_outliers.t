
use strict;
use Test;
use Statistics::Basic qw(:all);

plan tests => 5;

my @a  = (((1,2,3) x 7), 15);
my @b  = (((1,2,3) x 7));
my $v1 = vector(@a);
my $v2 = vector(@b);
my $c  = computed($v1);
   $c->set_filter(sub {
       my $s = stddev($v1);
       my $m = mean($v1);

       grep { abs( $_-$m ) <= $s } @_
   });

do{ local $ENV{DEBUG}=0; ok( $c, $v2 ); };
ok( mean($c), mean($v2) );
ok( mean($c), 2 );
ok( median($c), 2 );
do{ local $ENV{DEBUG}=0; ok( mode($c), "[1, 2, 3]" ); };
