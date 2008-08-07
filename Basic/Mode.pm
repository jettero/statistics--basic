
package Statistics::Basic::Mode;

use strict;
use warnings;
use Carp;

use Statistics::Basic;
use Scalar::Util qw(blessed);

use overload
    '""' => sub {
        my $q = $_[0]->query; return $q if ref $q; # vectors interpolate themselves
        $Statistics::Basic::fmt->format_number($_[0]->query, $ENV{IPRES});
    },
    '0+' => sub {
        my $q = $_[0]->query;
        croak "result is multimodal and cannot be used as a number" if ref $q;
        $q;
    },
    fallback => 1; # tries to do what it would have done if this wasn't present.

1;

# new {{{
sub new {
    my $class = shift;

    warn "[new median]\n" if $ENV{DEBUG} >= 2;

    my $this   = bless {}, $class;
    my $vector = eval { Statistics::Basic::Vector->new(@_) }; croak $@ if $@;
    my $c      = $vector->get_computer("mode"); return $c if defined $c;

    $this->{v} = $vector;

    $vector->set_computer( mode => $this );

    return $this;
}
# }}}
# recalc {{{
sub recalc {
    my $this        = shift;
    my $cardinality = $this->{v}->size;

    delete $this->{recalc_needed};
    delete $this->{mode};
    return unless $cardinality > 0;

    my %mode;
    my $max = 0;

    for my $val ($this->{v}->query) {
        my $t = ++ $mode{$val};
        $max = $t if $t > $max;
    }
    my @a = sort {$a<=>$b} grep { $mode{$_}==$max } keys %mode;

    $this->{mode} = ( (@a == 1) ?  $a[0] : Statistics::Basic::Vector->new(\@a) );

    warn "[recalc mode] count of $this->{mode} = $max\n" if $ENV{DEBUG};
}
# }}}
# recalc_needed {{{
sub recalc_needed {
    my $this = shift;
       $this->{recalc_needed} = 1;

    warn "[recalc_needed mode]\n" if $ENV{DEBUG};
}
# }}}
# query {{{
sub query {
    my $this = shift;

    $this->recalc if $this->{recalc_needed};

    warn "[query mode $this->{mode}]\n" if $ENV{DEBUG};

    return $this->{mode};
}
# }}}
# query_vector {{{
sub query_vector {
    my $this = shift;

    return $this->{v};
}
# }}}
# is_multimodal {{{
sub is_multimodal {
    my $this = shift;
    my $that = $this->query;

    return (blessed($that) ? 1:0);
}
# }}}

# size {{{
sub size {
    my $this = shift;

    return $this->{v}->size;
}
# }}}
# set_size {{{
sub set_size {
    my $this = shift;
    my $size = shift;

    eval { $this->{v}->set_size($size) }; croak $@ if $@;
}
# }}}
# set_vector {{{
sub set_vector {
    my $this = shift;

    warn "[set_vector mode]\n" if $ENV{DEBUG};

    $this->{v}->set_vector(@_);
}
# }}}
# insert {{{
sub insert {
    my $this = shift;

    warn "[insert mode]\n" if $ENV{DEBUG};

    $this->{v}->insert(@_);
}
# }}}
# ginsert {{{
sub ginsert {
    my $this = shift;

    warn "[ginsert mode]\n" if $ENV{DEBUG};

    $this->{v}->ginsert(@_);
}
# }}}
