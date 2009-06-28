BEGIN { $ENV{TOLER} = 0.001; }

use strict;
use Test;
use Statistics::Basic qw(:all);

plan tests => 2;

my $warning = 0;
$SIG{__WARN__} = sub { warn "\n\n\e[1;33mWARNING DETECTED: @_\e[m\n\n"; $warning ++ };

my $v1 = vector(1 .. 10);
my $v2 = computed($v1)->set_filter(sub {
    map {$_ + 0.5 * rand(1)} @_
});

my $corr = cor( $v1, $v2 );

ok( $corr == 1  );
ok( $warning, 0 );
