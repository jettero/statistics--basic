
package Statistics::Basic::Covariance;

use strict;
use warnings;
use Carp;

use Statistics::Basic;

1;

# new {{{
sub new {
    my $class = shift;
    my @v     = (shift, shift);
    my $set_size = shift;

    warn "[new covariance]\n" if $ENV{DEBUG} >= 2;

    my $this = bless {}, $class;

    for my $i(0 .. 1) {
        my $x = $i +1;

        my $vector = $this->{"v$x"} = eval { new Statistics::Basic::Vector($v[$i], $set_size) }; croak $@ if $@;
                     $this->{"m$x"} = eval { Statistics::Basic::Mean->new($vector, $set_size) }; croak $@ if $@;
    }

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

    croak "the two vectors in a Covariance object must be the same length" unless $c2 == $c1;

    my $cardinality = $c1;
       $cardinality -- if $ENV{UNBIAS};

    delete $this->{recalc_necessary};
    delete $this->{covariance};
    return unless $cardinality > 0;

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

    eval { $this->{m1}->set_size( $size );
           $this->{m2}->set_size( $size ); }; croak $@ if $@;

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

    if( ref $_[0] ) {
        croak "The two vectors in a Covariance object must be the same length."
            unless $this->{v1}->size == $this->{m2}->size;
               # note, that this comparison is intentionally asymmetric
               # in theory it proves that the vectors in {v1} and {m2} are the same
               # vectors...
    }

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

    croak "The two vectors in a Covariance object must be the same length."
        unless $this->{v1}->size == $this->{m2}->size;

    $this->recalc;
}
# }}}