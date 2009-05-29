
use Test;
use Statistics::Basic qw(:all);

plan tests => 1;

$SIG{__WARN__} = sub { die " warnings are considered catastrophic failures in here " };

my $v1 = vector(1,2,3,4);
ok("$v1", "[1, 2, 3, 4]");
