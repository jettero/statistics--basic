
package Statistics::Basic::StdDev;

use strict;
use warnings;
use Carp;

use Statistics::Basic;

use overload
    '""' => sub { $Statistics::Basic::fmt->format_number($_[0]->query, $ENV{IPRES}) },
    '0+' => sub { $_[0]->query },
    fallback => 1; # tries to do what it would have done if this wasn't present.

1;

# new {{{
sub new {
    my $class = shift;

    warn "[new stddev]\n" if $ENV{DEBUG} >= 2;

    my $this     = bless {}, $class;
    my $variance = $this->{V} = eval { Statistics::Basic::Variance->new(@_) }; croak $@ if $@;
    my $vector   = $variance->query_vector;
    my $c        = $vector->get_computer( 'stddev' ); return $c if defined $c;

    $vector->set_computer( stddev => $this );

    return $this;
}
# }}}
# recalc {{{
sub recalc {
    my $this  = shift;
    my $first = shift;

    delete $this->{recalc_needed};

    my $var = $this->{V}->query;
    return unless defined $var;

    warn "[recalc stddev] sqrt( $var )\n" if $ENV{DEBUG};

    $this->{stddev} = sqrt( $var );
}
# }}}
# recalc_needed {{{
sub recalc_needed {
    my $this = shift;
       $this->{recalc_needed} = 1;

    warn "[recalc_needed variance]\n" if $ENV{DEBUG};
}
# }}}
# query {{{
sub query {
    my $this = shift;

    $this->recalc if $this->{recalc_needed};

    warn "[query stddev $this->{stddev}]\n" if $ENV{DEBUG};

    return $this->{stddev};
}
# }}}
# query_vector {{{
sub query_vector {
    my $this = shift;

    return $this->{V}->query_vector;
}
# }}}
# query_mean {{{
sub query_mean {
    my $this = shift;

    return $this->{V}->query_mean;
}
# }}}
# query_variance {{{
sub query_variance {
    my $this = shift;

    return $this->{V};
}
# }}}

# size {{{
sub size {
    my $this = shift;

    return $this->{V}->size;
}
# }}}
# set_size {{{
sub set_size {
    my $this = shift;
    my $size = shift;

    eval { $this->{V}->set_size( $size ) }; croak $@ if $@;
}
# }}}
# insert {{{
sub insert {
    my $this = shift;

    warn "[insert stddev]\n" if $ENV{DEBUG};

    $this->{V}->insert( @_ );
}
# }}}
# ginsert {{{
sub ginsert {
    my $this = shift;

    warn "[ginsert stddev]\n" if $ENV{DEBUG};

    $this->{V}->ginsert( @_ );
}
# }}}
# set_vector {{{
sub set_vector {
    my $this = shift;

    warn "[set_vector stddev]\n" if $ENV{DEBUG};

    $this->{V}->set_vector( @_ );
}
# }}}
