package Statistics::Basic::Variance;

use strict;
use warnings;
use Carp;

use base 'Statistics::Basic::_OneVectorBase';

sub new {
    my $class = shift;

    warn "[new $class]\n" if $ENV{DEBUG} >= 2;

    my $this   = bless {}, $class;
    my $vector = eval { Statistics::Basic::Vector->new(shift, @_) }; croak $@ if $@;
    my $c      = $vector->get_computer("variance"); return $c if defined $c;

    $this->{v} = $vector;
    $this->{m} = eval { Statistics::Basic::Mean->new($vector, @_) }; croak $@ if $@;

    $vector->set_computer( variance => $this );

    return $this;
}

sub _recalc {
    my $this = shift;
    my $first = shift;

    delete $this->{recalc_needed};
    delete $this->{_value};

    my $mean = $this->{m}->query;
    return unless defined $mean;

    my $v = $this->{v};
    my $cardinality = $v->size;
       $cardinality -- if $ENV{UNBIAS};
    return unless $cardinality > 0;

    if( $ENV{DEBUG} >= 2 ) {
        warn "[recalc " . ref($this) . "] ( $_ - $mean ) ** 2\n" for $v->query;
    }

    my $sum = 0;

    $sum += ( $_ - $mean ) ** 2 for $v->query;

    $this->{_value} = ($sum / $cardinality);

    warn "[recalc " . ref($this) . "] ($sum/$cardinality) = $this->{_value}\n" if $ENV{DEBUG};
}

1;
