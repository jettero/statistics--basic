
package Statistics::Basic::StdDev;

use strict;
use warnings;
use Carp;

use Statistics::Basic::Variance;

$ENV{DEBUG} ||= 0;

1;

# new {{{
sub new {
    my $this   = shift;
    my $vector = shift;
    my $size   = shift;

    $this = bless { v => Statistics::Basic::Variance->new( $vector, $size ) }, $this;
    $this->recalc;

    return $this;
}
# }}}
# recalc {{{
sub recalc {
    my $this  = shift;
    my $first = shift;

    my $var = $this->{v}->query;
    return unless defined $var;

    warn "[recalc stddev] sqrt( $var )\n" if $ENV{DEBUG};

    $this->{stddev} = sqrt( $var );
}
# }}}
# query {{{
sub query {
    my $this = shift;

    return $this->{stddev};
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

    warn "[set_size stddev] $size\n" if $ENV{DEBUG};
    croak "strange stddev" if $size < 1;

    $this->{v}->set_size( $size );
    $this->recalc;
}
# }}}
# insert {{{
sub insert {
    my $this = shift;

    warn "[insert stddev]\n" if $ENV{DEBUG};

    $this->{v}->insert( @_ );
    $this->recalc;
}
# }}}
# ginsert {{{
sub ginsert {
    my $this = shift;

    warn "[ginsert stddev]\n" if $ENV{DEBUG};

    $this->{v}->ginsert( @_ );
    $this->recalc;
}
# }}}
# set_vector {{{
sub set_vector {
    my $this = shift;

    warn "[set_vector stddev]\n" if $ENV{DEBUG};

    $this->{v}->set_vector( @_ );
    $this->recalc;
}
# }}}
