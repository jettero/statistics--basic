
package Statistics::Basic::Variance;

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
    my $this   = shift;
    my $vector = shift;
    my $size   = shift;

    warn "[new variance]\n" if $ENV{DEBUG} >= 2;

    $this = eval { bless { m => Statistics::Basic::Mean->new( $vector, $size ) }, $this }; croak $@ if $@;
    $this->{v} = $this->{m}{v};
    $this->recalc;

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
# query {{{
sub query {
    my $this = shift;

    return $this->{variance};
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
    $this->{m}->recalc;
    $this->recalc;
}
# }}}
# insert {{{
sub insert {
    my $this = shift;

    warn "[insert variance]\n" if $ENV{DEBUG};

    $this->{m}->insert( @_ );
    $this->recalc;
}
# }}}
# ginsert {{{
sub ginsert {
    my $this = shift;

    warn "[ginsert variance]\n" if $ENV{DEBUG};

    $this->{m}->ginsert( @_ );
    $this->recalc;
}
# }}}
# set_vector {{{
sub set_vector {
    my $this = shift;

    warn "[set_vector variance]\n" if $ENV{DEBUG};

    $this->{m}->set_vector( @_ );
    $this->recalc;
}
# }}}
