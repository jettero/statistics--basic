
BEGIN { require "./t/locale_hack.pm" }
use Test;
use Statistics::Basic qw(:all ipres=1);

plan tests => 1;

my $mean = mean(1,3,7);
ok($mean, 3.7);
