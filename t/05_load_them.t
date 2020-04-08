BEGIN { require "./t/locale_hack.pm" }
use strict;
use Test;

my @packages = map { s/\.pm$//; s/^.+?\///; "Statistics::Basic::$_" } <Basic/*.pm>;

plan tests => int @packages;

for my $p (@packages) {
    eval "use $p";

    ok($@, "");
}
