
package Statistics::Basic::Covariance;

use strict;
use warnings;
use Carp;

use Statistics::Basic;

1;

# new {{{
sub new {
    my $class = shift;
    my $v1    = eval { Statistics::Basic::Vector->new( shift ) }; croak $@ if $@;
    my $v2    = eval { Statistics::Basic::Vector->new( shift ) }; croak $@ if $@;

    warn "[new covariance]\n" if $ENV{DEBUG} >= 2;

    my $this = bless {v1=>$v1, v2=>$v2}, $class;

    my $c = $v1->get_linked_computer( covariance => $v2 );
    return $c if $c;

    $this->{m1} = eval { Statistics::Basic::Mean->new($v1) }; croak $@ if $@;
    $this->{m2} = eval { Statistics::Basic::Mean->new($v2) }; croak $@ if $@;

    $v1->set_linked_computer( covariance => $this, $v2 );
    $v2->set_linked_computer( covariance => $this, $v1 );

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

    confess "the two vectors in a Covariance object must be the same length" unless $c2 == $c1;

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
        for my $i (0 .. $#$v1) {
            warn "[recalc covariance] ( $v1->[$i] - $m1 ) * ( $v2->[$i] - $m2 )\n";
        }
    }

    for my $i (0 .. $#$v1) {
        $sum += ( $v1->[$i] - $m1 ) * ( $v2->[$i] - $m2 );
    }

    $this->{covariance} = ($sum / $cardinality);

    warn "[recalc covariance] ($sum/$cardinality) = $this->{covariance}\n" if $ENV{DEBUG};
}
# }}}
# recalc_needed {{{
sub recalc_needed {
    my $this = shift;
       $this->{recalc_needed} = 1;

    warn "[recalc_needed covariance]\n" if $ENV{DEBUG};
}
# }}}
# query {{{
sub query {
    my $this = shift;

    $this->recalc if $this->{recalc_needed};

    warn "[query covariance $this->{covariance}]\n" if $ENV{DEBUG};

    return $this->{covariance};
}
# }}}
# query_vector1 {{{
sub query_vector1 {
    my $this = shift;

    return $this->{v1};
}
# }}}
# query_vector2 {{{
sub query_vector2 {
    my $this = shift;

    return $this->{v2};
}
# }}}
# query_mean1 {{{
sub query_mean1 {
    my $this = shift;

    return $this->{m1};
}
# }}}
# query_mean2 {{{
sub query_mean2 {
    my $this = shift;

    return $this->{m2};
}
# }}}

# size {{{
sub size {
    my $this = shift;

    return ($this->{v2}->size, $this->{v1}->size); # only v1->size is returned in scalar context
}
# }}}
# set_size {{{
sub set_size {
    my $this = shift;
    my $size = shift;

    eval { $this->{v1}->set_size( $size );
           $this->{v2}->set_size( $size ); }; croak $@ if $@;
}
# }}}
# insert {{{
sub insert {
    my $this = shift;

    warn "[insert covariance]\n" if $ENV{DEBUG};

    croak "this insert() takes precisely two arguments.  They can be arrayrefs if you like." unless 2 == int @_;

    $this->{v1}->insert( $_[0] );
    $this->{v2}->insert( $_[1] );
}
# }}}
# ginsert {{{
sub ginsert {
    my $this = shift;

    warn "[ginsert covariance]\n" if $ENV{DEBUG};

    croak "this ginsert() takes precisely two arguments.  They can be arrayrefs if you like." 
        unless 2 == int @_;

    $this->{v1}->ginsert( $_[0] );
    $this->{v2}->ginsert( $_[1] );

    if( ref $_[0] ) {
        croak "The two vectors in a Covariance object must be the same length."
            unless $this->{v1}->size == $this->{v2}->size;
    }
}
# }}}
# set_vector {{{
sub set_vector {
    my $this = shift;

    warn "[set_vector covariance]\n" if $ENV{DEBUG};

    croak "this set_vector() takes precisely two arguments.  They can be arrayrefs if you like." 
        unless 2 == int @_;

    $this->{v1}->set_vector( $_[0] );
    $this->{v2}->set_vector( $_[1] );

    confess "The two vectors in a Covariance object must be the same length."
        unless $this->{v1}->size == $this->{v2}->size;
}
# }}}
