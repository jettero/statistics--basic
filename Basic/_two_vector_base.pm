package Statistics::Basic::_two_vector_base;

use strict;
use warnings;
use Carp;

use overload
    '""' => sub { defined( my $v = $_[0]->query ) || return "n/a"; $Statistics::Basic::fmt->format_number("$v", $ENV{IPRES}) },
    '0+' => sub { $_[0]->query },
    ( exists($ENV{TOLER}) ? ('==' => sub { abs($_[0]-$_[1])<=$ENV{TOLER} }) : () ),
    'eq' => sub { "$_[0]" eq "$_[1]" },
    fallback => 1; # tries to do what it would have done if this wasn't present.

# query {{{
sub query {
    my $this = shift;

    $this->_recalc if $this->{recalc_needed};

    warn "[query " . ref($this) . " $this->{_value}]\n" if $ENV{DEBUG};

    return $this->{_value};
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

    warn "[insert " . ref($this) . "]\n" if $ENV{DEBUG};

    croak ref($this) . "-insert() takes precisely two arguments.  They can be arrayrefs if you like." unless 2 == int @_;

    $this->{sd1}->insert( $_[0] );
    $this->{sd2}->insert( $_[1] );
}
# }}}
# ginsert {{{
sub ginsert {
    my $this = shift;

    warn "[ginsert " . ref($this) . "]\n" if $ENV{DEBUG};

    croak "" . ref($this) . "-ginsert() takes precisely two arguments.  They can be arrayrefs if you like." 
        unless 2 == int @_;

    $this->{sd1}->ginsert( $_[0] );
    $this->{sd2}->ginsert( $_[1] );

    my @s = $this->{cov}->size;
    croak "The two vectors in a " . ref($this) . " object must be the same length."
        unless $s[0] == $s[1];
}
# }}}
# set_vector {{{
sub set_vector {
    my $this = shift;

    warn "[set_vector " . ref($this) . "]\n" if $ENV{DEBUG};

    croak "this set_vector() takes precisely two arguments.  They can be arrayrefs if you like." 
        unless 2 == int @_;

    $this->{sd1}->set_vector( $_[0] );
    $this->{sd2}->set_vector( $_[1] );

    my @s = $this->{cov}->size;
    croak "The two vectors in a " . ref($this) . " object must be the same length."
        unless $s[0] == $s[1];
}
# }}}
# _recalc_needed {{{
sub _recalc_needed {
    my $this = shift;
       $this->{recalc_needed} = 1;

    warn "[recalc_needed " . ref($this) . "]\n" if $ENV{DEBUG};
}
# }}}

1;
