
package Statistics::Basic::CoVariance;

use strict;
use warnings;
use Carp;
use Statistics::Basic::Mean;
use Statistics::Basic::Vector;

$ENV{DEBUG} ||= 0;

1;

# new {{{
sub new {
    my $this     = shift;
    my @v        = (shift, shift);
    my $set_size = shift;
    my @m        = (shift, shift);

    warn "[new covariance]\n" if $ENV{DEBUG} >= 2;

    $this = bless {}, $this;

    for my $i(0 .. 1) {
        my $x = $i +1;

        if( ref($v[$i]) eq "ARRAY" ) {
            $this->{"v$x"} = new Statistics::Basic::Vector( $v[$i], $set_size );

        } elsif( ref($v[$i]) eq "Statistics::Basic::Vector" ) {
            $this->{"v$x"} = $v[$i];
            $this->{"v$x"}->set_size( $set_size ) if defined $set_size;

        } elsif(defined($v[$i])) {
            croak "argument to new() must be an arrayref or Statistics::Basic::Vector";

        } else {
            $this->{"v$x"} = new Statistics::Basic::Vector;
        }

        $this->{"m$x"} = (ref($m[$i]) eq "Statistics::Basic::Mean" ?  $m[$i] : new Statistics::Basic::Mean($this->{"v$x"}));
    }

    $this->recalc;

    return $this;
}
# }}}
# recalc {{{
sub recalc {
    my $this  = shift;
    my $sum   = 0;
    my $c1    = $this->{v1}->size;
    my $c2    = $this->{v2}->size;

    warn "[recalc covariance] (\$c1, \$c2) = ($c1, $c2)\n" if $ENV{DEBUG};

    croak "the two vectors in a CoVariance object must be the same length" unless $c2 == $c1;

    my $cardinality = $c1;

    $cardinality -- if $ENV{UNBIAS};

    unless( $cardinality > 0 ) {
        warn "[recalc covariance] cardinality found to be 0-ish\n" if $ENV{DEBUG};

        $this->{covariance} = undef;

        return;
    }

    my $v1 = $this->{v1}->query;
    my $v2 = $this->{v2}->query;

    my $m1 = $this->{m1}->query;
    my $m2 = $this->{m2}->query;

    if( $ENV{DEBUG} >= 2 ) {
        for my $i (0 .. $#{ $v1 }) {
            warn "[recalc covariance] ( $v1->[$i] - $m1 ) * ( $v2->[$i] - $m2 )\n";
        }
    }

    for my $i (0 .. $#{ $v1 }) {
        $sum += (( $v1->[$i] - $m1 ) * ( $v2->[$i] - $m2 ));
    }

    $this->{covariance} = ($sum / $cardinality);

    warn "[recalc covariance] ($sum/$cardinality) = $this->{covariance}\n" if $ENV{DEBUG};
}
# }}}
# query {{{
sub query {
    my $this = shift;

    return $this->{covariance};
}
# }}}

# size {{{
sub size {
    my $this = shift;

    return $this->{v1}->size;
}
# }}}
# set_size {{{
sub set_size {
    my $this = shift;
    my $size = shift;

    warn "[set_size covariance] $size\n" if $ENV{DEBUG};
    croak "strange size" if $size < 1;

    $this->{m1}->set_size( $size );
    $this->{m2}->set_size( $size );

    $this->recalc;
}
# }}}
# insert {{{
sub insert {
    my $this = shift;

    warn "[insert covariance]\n" if $ENV{DEBUG};

    croak "this insert() takes precisely two arguments.  They can be arrayrefs if you like." unless 2 == int @_;

    $this->{m1}->insert( $_[0] );
    $this->{m2}->insert( $_[1] );

    $this->recalc;
}
# }}}
# ginsert {{{
sub ginsert {
    my $this = shift;

    warn "[ginsert covariance]\n" if $ENV{DEBUG};

    croak "this ginsert() takes precisely two arguments.  They can be arrayrefs if you like." 
        unless 2 == int @_;

    $this->{m1}->ginsert( $_[0] );
    $this->{m2}->ginsert( $_[1] );

    croak "The two vectors in a CoVariance object must be the same length."
        unless $this->{v1}->size == $this->{m2}->size;
           # note, that this comparison is intentionally asymmetric
           # in theory it proves that the vectors in {v1} and {m2} are the same
           # vectors...

    $this->recalc;
}
# }}}
# set_vector {{{
sub set_vector {
    my $this = shift;

    warn "[set_vector covariance]\n" if $ENV{DEBUG};

    croak "this set_vector() takes precisely two arguments.  They can be arrayrefs if you like." 
        unless 2 == int @_;

    $this->{m1}->set_vector( $_[0] );
    $this->{m2}->set_vector( $_[1] );

    croak "The two vectors in a CoVariance object must be the same length."
        unless $this->{m1}->{v}->size == $this->{m2}->{v}->size;

    $this->recalc;
}
# }}}
