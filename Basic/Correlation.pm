
package Statistics::Basic::Correlation;

use strict;
use warnings;
use Carp;

use base 'Statistics::Basic::_TwoVectorBase';

# new {{{
sub new {
    my $this = shift;
    my $v1   = eval { Statistics::Basic::Vector->new( shift ) }; croak $@ if $@;
    my $v2   = eval { Statistics::Basic::Vector->new( shift ) }; croak $@ if $@;

    $this = bless {}, $this;

    my $c = $v1->get_linked_computer( correlation => $v2 );
    return $c if $c;

    $this->{sd1} = eval { Statistics::Basic::StdDev->new($v1) }; croak $@ if $@;
    $this->{sd2} = eval { Statistics::Basic::StdDev->new($v2) }; croak $@ if $@;
    $this->{cov} = eval { Statistics::Basic::Covariance->new( $v1, $v2 ) }; croak $@ if $@;

    $this->{_vectors} = [ $v1, $v2 ];

    $v1->set_linked_computer( correlation => $this, $v2 );
    $v2->set_linked_computer( correlation => $this, $v1 );

    return $this;
}
# }}}
# _recalc {{{
sub _recalc {
    my $this  = shift;

    delete $this->{recalc_needed};
    delete $this->{_value};

    my $c  = $this->{cov}->query; return unless defined $c;
    my $s1 = $this->{sd1}->query; return unless defined $s1;
    my $s2 = $this->{sd2}->query; return unless defined $s2;

    if( $s1 == 0 or $s2 == 0 ) {
        warn "[recalc " . ref($this) . "] Standard deviation of 0.  Crazy infinite correlation detected.\n" if $ENV{DEBUG};

        return;
    }

    $this->{_value} = ( $c / ($s1*$s2) );

    warn "[recalc " . ref($this) . "] ( $c / ($s1*$s2) ) = $this->{_value}\n" if $ENV{DEBUG};

    return 1;
}
# }}}

# query_vector1 {{{
sub query_vector1 {
    my $this = shift;

    return $this->{cov}->query_vector1;
}
# }}}
# query_vector2 {{{
sub query_vector2 {
    my $this = shift;

    return $this->{cov}->query_vector2;
}
# }}}
# query_mean1 {{{
sub query_mean1 {
    my $this = shift;

    return $this->{cov}->query_mean1;
}
# }}}
# query_mean2 {{{
sub query_mean2 {
    my $this = shift;

    return $this->{cov}->query_mean2;
}
# }}}
# query_covariance {{{
sub query_covariance {
    my $this = shift;

    return $this->{cov};
}
# }}}

1;
