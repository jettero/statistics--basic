
package Statistics::Basic::Correlation;

use strict;
use warnings;
use Carp;

use Statistics::Basic::Vector;
use Statistics::Basic::StdDev;
use Statistics::Basic::CoVariance;

$ENV{DEBUG} ||= 0;

1;

# new {{{
sub new {
    my $this = shift;
    my $v1   = new Statistics::Basic::Vector( shift );
    my $v2   = new Statistics::Basic::Vector( shift );

    $this = bless {}, $this;

    $this->{sd1} = new Statistics::Basic::StdDev($v1);
    $this->{sd2} = new Statistics::Basic::StdDev($v2);
    $this->{cov} = new Statistics::Basic::CoVariance( $v1, $v2, undef, $this->{sd1}{v}{m}, $this->{sd2}{v}{m});

    $this->recalc;

    return $this;
}
# }}}
# recalc {{{
sub recalc {
    my $this  = shift;

    my $c  = $this->{cov}->query; return unless defined $c;
    my $s1 = $this->{sd1}->query; return unless defined $s1;
    my $s2 = $this->{sd2}->query; return unless defined $s2;

    if( $s1 == 0 or $s2 == 0 ) {
        warn "[recalc correlation] Standard deviation of 0.  Crazy infinite correlation detected.\n" if $ENV{DEBUG};

        return;
    }

    $this->{correlation} = ( $c / ($s1*$s2) );

    warn "[recalc correlation] ( $c / ($s1*$s2) ) = $this->{correlation}\n" if $ENV{DEBUG};

    return 1;
}
# }}}
# query {{{
sub query {
    my $this = shift;

    return $this->{correlation};
}
# }}}

# size {{{
sub size {
    my $this = shift;

    return $this->{cov}->size;
}
# }}}
# set_size {{{
sub set_size {
    my $this = shift;
    my $size = shift;

    warn "[set_size correlation] $size\n" if $ENV{DEBUG};
    croak "strange size" if $size < 1;

    $this->{sd1}->set_size( $size );
    $this->{sd2}->set_size( $size );

    $this->{cov}->recalc;
    $this->recalc;
}
# }}}
# insert {{{
sub insert {
    my $this = shift;

    warn "[insert correlation]\n" if $ENV{DEBUG};

    croak "this insert() takes precisely two arguments.  They can be arrayrefs if you like." unless 2 == int @_;

    $this->{sd1}->insert( $_[0] );
    $this->{sd2}->insert( $_[1] );

    $this->{cov}->recalc;
    $this->recalc;
}
# }}}
# ginsert {{{
sub ginsert {
    my $this = shift;

    warn "[ginsert correlation]\n" if $ENV{DEBUG};

    croak "this ginsert() takes precisely two arguments.  They can be arrayrefs if you like." 
        unless 2 == int @_;

    $this->{sd1}->ginsert( $_[0] );
    $this->{sd2}->ginsert( $_[1] );

    croak "The two vectors in a Correlation object must be the same length."
        unless $this->{sd1}->{v}->size == $this->{sd2}->{v}->size;

    $this->{cov}->recalc;
    $this->recalc;
}
# }}}
# set_vector {{{
sub set_vector {
    my $this = shift;

    warn "[set_vector correlation]\n" if $ENV{DEBUG};

    croak "this set_vector() takes precisely two arguments.  They can be arrayrefs if you like." 
        unless 2 == int @_;

    $this->{sd1}->set_vector( $_[0] );
    $this->{sd2}->set_vector( $_[1] );

    croak "The two vectors in a Correlation object must be the same length."
        unless $this->{sd1}->{v}->size == $this->{sd2}->{v}->size;

    $this->{cov}->recalc;

    return $this->recalc;
}
# }}}
