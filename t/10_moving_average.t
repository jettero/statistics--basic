
use strict;
use Test;
use Statistics::Basic qw(:all);

plan tests => 2*(1+(my $t = 8));

my $avg = avg()->set_size($t, NOFILL);

ok( $avg->size, 0 );

for(1 .. $t) {
    ok( $avg->query, undef );
    $avg->insert(1);
    ok( $avg->size, $_ );
}

ok( $avg->query, 1 );
