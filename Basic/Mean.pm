
package Statistics::Basic::Mean;

use strict;
use warnings;
use Carp;

use base 'Statistics::Basic::_OneVectorBase';

1;

# new {{{
sub new {
    my $class = shift;

    warn "[new mean]\n" if $ENV{DEBUG} >= 2;

    my $this   = bless {}, $class;
    my $vector = eval { Statistics::Basic::Vector->new(@_) }; croak $@ if $@;
    my $c      = $vector->get_computer("mean"); return $c if defined $c;

    $this->{v} = $vector;

    $vector->set_computer( mean => $this );

    return $this;
}
# }}}
# _recalc {{{
sub _recalc {
    my $this        = shift;
    my $sum         = 0; 
    my $cardinality = $this->{v}->size;

    delete $this->{recalc_needed};
    delete $this->{_value};
    return unless $cardinality > 0;

    $sum += $_ for $this->{v}->query;

    $this->{_value} = ($sum / $cardinality);

    warn "[recalc " . ref($this) . "] ($sum/$cardinality) = $this->{_value}\n" if $ENV{DEBUG};
}
# }}}
