
use Test;
use Statistics::Basic qw(:all);

my $warning = 0;
$SIG{__WARN__} = sub { warn "\n\n\e[1;33mWARNING DETECTED: @_\e[m\n\n"; $warning ++ };

my @zerosies = (
    scalar vector(),
    scalar computed(),
);

my @onesies = (
    scalar mean(),
    scalar median(),
    scalar mode(),
    scalar stddev(),
    scalar variance(),
);

my @twosies = (
    scalar correlation(),
    scalar covariance(),
    scalar lsf(),
);

plan tests => 1   # warnings
    + 1*@zerosies # vector tests
    + 1*@onesies  # one-vector tests
    + 2*@twosies  # two-vector tests
    ;

for (@zerosies) {
    ok($_->query_size, 0);
}

for (@onesies) {
    my $v = $_->query_vector;

    ok($v->query_size, 0);
}

for (@twosies) {
    my $v1 = $_->query_vector1;
    my $v2 = $_->query_vector2;

    ok($v1->query_size, 0);
    ok($v2->query_size, 0);
}

ok($warning, 0);
