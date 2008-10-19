
package Statistics::Basic::Variance;

use strict;
use warnings;
use Carp;

use Statistics::Basic;

use overload
    '""' => sub { my $v = $_[0]->query; $Statistics::Basic::fmt->format_number("$v", $ENV{IPRES}) },
    '0+' => sub { $_[0]->query },
    ( exists($ENV{TOLER}) ?  ('==' => sub { abs($_[0]-$_[1])<=$ENV{TOLER} }) : () ),
    'eq' => sub { "$_[0]" eq "$_[1]" },
    fallback => 1; # tries to do what it would have done if this wasn't present.

1;

# new {{{
sub new {
    my $class = shift;

    warn "[new variance]\n" if $ENV{DEBUG} >= 2;

    my $this   = bless {}, $class;
    my $vector = eval { Statistics::Basic::Vector->new(shift, @_) }; croak $@ if $@;
    my $c      = $vector->get_computer("variance"); return $c if defined $c;

    $this->{v} = $vector;
    $this->{m} = eval { Statistics::Basic::Mean->new($vector, @_) }; croak $@ if $@;

    $vector->set_computer( variance => $this );

    return $this;
}
# }}}
# recalc {{{
sub recalc {
    my $this        = shift;
    my $first       = shift;
    my $sum         = 0;
    my $cardinality = $this->{v}->size;
    my $mean        = $this->{m}->query;

    $cardinality -- if $ENV{UNBIAS};

    delete $this->{recalc_needed};
    delete $this->{variance};
    return unless $cardinality > 0;

    if( $ENV{DEBUG} >= 2 ) {
        warn "[recalc variance] ( $_ - $mean ) ** 2\n" for $this->{v}->query;
    }

    $sum += ( $_ - $mean ) ** 2 for $this->{v}->query;

    $this->{variance} = ($sum / $cardinality);

    warn "[recalc variance] ($sum/$cardinality) = $this->{variance}\n" if $ENV{DEBUG};
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

    warn "[query variance $this->{variance}]\n" if $ENV{DEBUG};

    return $this->{variance};
}
# }}}
# query_vector {{{
sub query_vector {
    my $this = shift;

    return $this->{v};
}
# }}}
# query_mean {{{
sub query_mean {
    my $this = shift;

    return $this->{m};
}
# }}}

# size {{{
sub size {
    my $this = shift;

    return $this->{v}->size;
}
# }}}
# set_size {{{
sub set_size {
    my $this = shift;
    my $size = shift;

    eval { $this->{v}->set_size( $size ) }; croak $@ if $@;
}
# }}}
# insert {{{
sub insert {
    my $this = shift;

    warn "[insert variance]\n" if $ENV{DEBUG};

    $this->{v}->insert( @_ );
}
# }}}
# ginsert {{{
sub ginsert {
    my $this = shift;

    warn "[ginsert variance]\n" if $ENV{DEBUG};

    $this->{v}->ginsert( @_ );
}
# }}}
# set_vector {{{
sub set_vector {
    my $this = shift;

    warn "[set_vector variance]\n" if $ENV{DEBUG};

    $this->{v}->set_vector( @_ );
}
# }}}
