
package Statistics::Basic::LeastSquareFit;

use strict;
use warnings;
use Carp;

use Statistics::Basic;

use overload
    '""' => sub {
        my ($alpha,$beta) = map{$Statistics::Basic::fmt->format_number($_, $ENV{IPRES})} $_[0]->query;
        "alpha: $alpha, beta: $beta";
    },
    '0+' => sub { croak "the result of LSF may not be used as a number" },
    fallback => 1; # tries to do what it would have done if this wasn't present.

1;

# new {{{
sub new {
    my $this = shift;
    my $v1   = eval { Statistics::Basic::Vector->new( shift ) }; croak $@ if $@;
    my $v2   = eval { Statistics::Basic::Vector->new( shift ) }; croak $@ if $@;

    $this = bless {}, $this;

    my $c = $v1->get_linked_computer( LSF => $v2 );
    return $c if $c;

    $this->{vrx} = new Statistics::Basic::Variance($v1);
    $this->{vry} = new Statistics::Basic::Variance($v2);
    $this->{mnx} = new Statistics::Basic::Mean($v1);
    $this->{mny} = new Statistics::Basic::Mean($v2);
    $this->{cov} = new Statistics::Basic::Covariance($v1, $v2);

    $v1->set_linked_computer( LSF => $this, $v2 );
    $v2->set_linked_computer( LSF => $this, $v1 );

    return $this;
}
# }}}
# _recalc {{{
sub _recalc {
    my $this  = shift;

    delete $this->{recalc_needed};
    delete $this->{alpha};
    delete $this->{beta};

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
}
# }}}
# _recalc_needed {{{
sub _recalc_needed {
    my $this = shift;
       $this->{recalc_needed} = 1;

    warn "[recalc_needed LSF]\n" if $ENV{DEBUG};
}
# }}}
# query {{{
sub query {
    my $this = shift;

    $this->_recalc if $this->{recalc_needed};

    warn "[query LSF ($this->{alpha}, $this->{beta})]\n" if $ENV{DEBUG};

    return (wantarray ? ($this->{alpha}, $this->{beta}) : [$this->{alpha}, $this->{beta}] );
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

    return $this->{mnx};
}
# }}}
# query_mean2 {{{
sub query_mean2 {
    my $this = shift;

    return $this->{mny};
}
# }}}
# query_variance1 {{{
sub query_variance1 {
    my $this = shift;

    return $this->{vrx};
}
# }}}
# query_variance2 {{{
sub query_variance2 {
    my $this = shift;

    return $this->{vry};
}
# }}}
# query_covariance {{{
sub query_covariance {
    my $this = shift;

    return $this->{cov};
}
# }}}

# y_given_x {{{
sub y_given_x {
    my $this = shift;
    my ($alpha, $beta) = $this->query;
    my $x = shift;

    return ($beta*$x + $alpha);
}
# }}}
# x_given_y {{{
sub x_given_y {
    my $this = shift;
    my ($alpha, $beta) = $this->query;
    my $y = shift;

    my $x = eval { ( ($y-$alpha)/$beta ) }; croak $@ if $@;
    return $x;
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

    eval { $this->{vrx}->set_size( $size );
           $this->{vry}->set_size( $size ); }; croak $@ if $@;
}
# }}}
# insert {{{
sub insert {
    my $this = shift;

    warn "[insert LSF]\n" if $ENV{DEBUG};

    croak "this insert() takes precisely two arguments.  They can be arrayrefs if you like." unless 2 == int @_;

    $this->{vrx}->insert( $_[0] );
    $this->{vry}->insert( $_[1] );
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
        unless $this->{vrx}->size == $this->{vry}->size;
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
        unless $this->{vrx}->size == $this->{vry}->size;
}
# }}}
