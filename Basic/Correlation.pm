
package Statistics::Basic::Correlation;

use strict;
use warnings;
use Carp;

use Statistics::Basic;

use overload
    '""' => sub { $Statistics::Basic::fmt->format_number($_[0]->query, $ENV{IPRES}) },
    '0+' => sub { $_[0]->query },
    ( exists($ENV{TOLER}) ?  ('==' => sub { abs($_[0]-$_[1])<=$ENV{TOLER} }) : () ),
    'eq' => sub { "$_[0]" eq "$_[1]" },
    fallback => 1; # tries to do what it would have done if this wasn't present.

1;

# new {{{
sub new {
    my $this = shift;
    my $v1   = eval { Statistics::Basic::Vector->new( shift ) }; croak $@ if $@;
    my $v2   = eval { Statistics::Basic::Vector->new( shift ) }; croak $@ if $@;

    $this = bless {}, $this;

    my $c = $v1->get_linked_computer( correlation => $v2 );
    return $c if $c;

    $this->{sd1} = new Statistics::Basic::StdDev($v1);
    $this->{sd2} = new Statistics::Basic::StdDev($v2);
    $this->{cov} = new Statistics::Basic::Covariance( $v1, $v2 );

    $v1->set_linked_computer( correlation => $this, $v2 );
    $v2->set_linked_computer( correlation => $this, $v1 );

    return $this;
}
# }}}
# recalc {{{
sub recalc {
    my $this  = shift;

    delete $this->{recalc_needed};
    delete $this->{correlation};

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

    warn "[query correlation $this->{correlation}]\n" if $ENV{DEBUG};

    return $this->{correlation};
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

    eval { $this->{sd1}->set_size( $size );
           $this->{sd2}->set_size( $size ); }; croak $@ if $@;
}
# }}}
# insert {{{
sub insert {
    my $this = shift;

    warn "[insert correlation]\n" if $ENV{DEBUG};

    croak "this insert() takes precisely two arguments.  They can be arrayrefs if you like." unless 2 == int @_;

    $this->{sd1}->insert( $_[0] );
    $this->{sd2}->insert( $_[1] );
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

    my @s = $this->{cov}->size;
    croak "The two vectors in a Correlation object must be the same length."
        unless $s[0] == $s[1];
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

    my @s = $this->{cov}->size;
    croak "The two vectors in a Correlation object must be the same length."
        unless $s[0] == $s[1];
}
# }}}
