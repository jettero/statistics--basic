
BEGIN { require "./t/locale_hack.pm" }
use Test;
use Statistics::Basic qw(:all nofill=0);

plan tests => 1;

my $vector = vector()->set_size(10);
ok($vector->query_size, 10);
