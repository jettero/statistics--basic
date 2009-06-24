
use strict;
use Test;
use Statistics::Basic qw(:all);

plan tests => 2*(1+(my $t = 3));

$ENV{NOFILL} = 1;

my $avg = avg()->set_size($t);
ok( $avg->query_size, 0 );
for(1 .. $t) {
    ok( $avg->query, undef );
    $avg->insert(1);
    ok( $avg->query_size, $_ );
}

ok( $avg->query, 1 );
