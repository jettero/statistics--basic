
use strict;
use Test;
use Statistics::Basic;

plan tests => 1;

my $cvec = eval { Statistics::Basic::ComputedVector->new([1 .. 3]) };
