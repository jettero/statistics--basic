
package Statistics::Basic::LeastSquareFit;

use strict;
use warnings;
use Carp;
use Statistics::Basic::Vector;
use Statistics::Basic::Variance;
use Statistics::Basic::CoVariance;

$ENV{DEBUG} ||= 0;

1;

# new {{{
sub new {
    my $this = shift;
    my $v1   = new Statistics::Basic::Vector( shift );
    my $v2   = new Statistics::Basic::Vector( shift );

    $this = bless {}, $this;

    $this->{vrx} = new Statistics::Basic::Variance($v1);
    $this->{vry} = new Statistics::Basic::Variance($v2);
    $this->{mnx} = $this->{vrx}{m};
    $this->{mny} = $this->{vry}{m};
    $this->{cov} = new Statistics::Basic::CoVariance($v1, $v2, undef, $this->{mnx}, $this->{mny});

    $this->recalc;

    return $this;
}
# }}}
# recalc {{{
sub recalc {
    my $this  = shift;

    unless( $this->{vrx}->query ) {
        unless( defined $this->{vrx}->query ) {
            warn "[recalc LSF] undef variance...\n" if $ENV{DEBUG};

        } else {
            warn "[recalc LSF] narrowly avoided division by zero.  Something is probably wrong.\n" if $ENV{DEBUG};
        }

        return;
    }

    $this->{beta}  = ($this->{cov}->query / $this->{vrx}->query);
    $this->{alpha} = ($this->{mny}->query - ($this->{beta} * $this->{mnx}->query));

    warn "[recalc LSF] (alpha: $this->{alpha}, beta: $this->{beta})\n" if $ENV{DEBUG};

    return 1;
}
# }}}
# query {{{
sub query {
    my $this = shift;

    return (wantarray ? ($this->{alpha}, $this->{beta}) : [$this->{alpha}, $this->{beta}] );
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

    warn "[set_size LSF] $size\n" if $ENV{DEBUG};
    croak "strange size" if $size < 1;

    $this->{vrx}->set_size( $size );
    $this->{vry}->set_size( $size );

    $this->{cov}->recalc;
    $this->recalc;
}
# }}}
# insert {{{
sub insert {
    my $this = shift;

    warn "[insert LSF]\n" if $ENV{DEBUG};

    croak "this insert() takes precisely two arguments.  They can be arrayrefs if you like." unless 2 == int @_;

    $this->{vrx}->insert( $_[0] );
    $this->{vry}->insert( $_[1] );

    $this->{cov}->recalc;
    $this->recalc;
}
# }}}
# ginsert {{{
sub ginsert {
    my $this = shift;

    warn "[ginsert LSF]\n" if $ENV{DEBUG};

    croak "this ginsert() takes precisely two arguments.  They can be arrayrefs if you like." 
        unless 2 == int @_;

    $this->{vrx}->ginsert( $_[0] );
    $this->{vry}->ginsert( $_[1] );

    croak "The two vectors in a LeastSquareFit object must be the same length."
        unless $this->{vrx}->{v}->size == $this->{vry}->{v}->size;

    $this->{cov}->recalc;
    $this->recalc;
}
# }}}
# set_vector {{{
sub set_vector {
    my $this = shift;

    warn "[set_vector LSF]\n" if $ENV{DEBUG};

    croak "this set_vector() takes precisely two arguments.  They can be arrayrefs if you like." 
        unless 2 == int @_;

    $this->{vrx}->set_vector( $_[0] );
    $this->{vry}->set_vector( $_[1] );

    croak "The two vectors in a LeastSquareFit object must be the same length."
        unless $this->{vrx}->{v}->size == $this->{vry}->{v}->size;

    $this->{cov}->recalc;

    return $this->recalc;
}
# }}}
