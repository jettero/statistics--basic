
package Statistics::Basic::Median;

use strict;
use warnings;
use Carp;

use Statistics::Basic::Vector;

$ENV{DEBUG} ||= 0;

1;

# new {{{
sub new {
    my $this     = shift;
    my $vector   = shift;
    my $set_size = shift;

    warn "[new median]\n" if $ENV{DEBUG} >= 2;

    $this = bless {}, $this;

    if( ref($vector) eq "ARRAY" ) {
        $this->{v} = new Statistics::Basic::Vector( $vector, $set_size );
    } elsif( ref($vector) eq "Statistics::Basic::Vector" ) {
        $this->{v} = $vector;
        $this->{v}->set_size( $set_size ) if defined $set_size;
    } elsif( defined($vector) ) {
        croak "argument to new() too strange";
    } else {
        $this->{v} = new Statistics::Basic::Vector;
    }

    $this->recalc;

    return $this;
}
# }}}
# recalc {{{
sub recalc {
    my $this        = shift;
    my $cardinality = $this->{v}->size;

    unless( $cardinality > 0 ) {
        $this->{median} = undef;

        return;
    }

    my @v = (sort {$a <=> $b} ($this->{'v'}->query()));
    my $center = int($cardinality/2);
    if ($cardinality%2) {
        $this->{'median'} = $v[$center];

    } else {
        $this->{'median'} = ($v[$center] + $v[$center-1]) / 2.0;
    }

    warn "[recalc median] vector[int($cardinality/2)] = $this->{median}\n" if $ENV{DEBUG};
}
# }}}
# query {{{
sub query {
    my $this = shift;

    return $this->{'median'};
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

    warn "[set_size median] $size\n" if $ENV{DEBUG};
    croak "strange size" if $size < 1;

    $this->{v}->set_size($size);
    $this->recalc;
}
# }}}
# set_vector {{{
sub set_vector {
    my $this = shift;

    warn "[set_vector median]\n" if $ENV{DEBUG};

    $this->{v}->set_vector(@_);
    $this->recalc;
}
# }}}
# insert {{{
sub insert {
    my $this = shift;

    warn "[insert median]\n" if $ENV{DEBUG};

    $this->{v}->insert(@_);
    $this->recalc;
}
# }}}
# ginsert {{{
sub ginsert {
    my $this = shift;

    warn "[ginsert median]\n" if $ENV{DEBUG};

    $this->{v}->ginsert(@_);
    $this->recalc;
}
# }}}

__END__
# Below is stub documentation for your module. You better edit it!

=head1 NAME

    Statistics::Basic::Median

=head1 SYNOPSIS

    A machine to calculate the median of a given vector.

=head1 ENV VARIABLES

=head2 DEBUG

   Try setting $ENV{DEBUG}=1; or $ENV{DEBUG}=2; to see the internals.

   Also, from your bash prompt you can 'DEBUG=1 perl ./myprog.pl' to
   enable debugging dynamically.

=head1 AUTHOR

    Please contact me with ANY suggestions, no matter how pedantic.

    Jettero Heller <japh@voltar-confed.org>

=head1 SUB-MODULE AUTHOR

    The author of this module and it's tests was actually:

    http://search.cpan.org/~orien/

=head1 SEE ALSO

    perl(1)

=cut
