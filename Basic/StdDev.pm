# vi:fdm=marker fdl=0
# $Id: StdDev.pm,v 1.1 2006-01-25 22:20:42 jettero Exp $ 

package Statistics::Basic::StdDev;

use strict;
no warnings;
use Carp;
use Statistics::Basic::Variance;

1;

# new {{{
sub new {
    my $this   = shift;
    my $vector = shift;
    my $size   = shift;

    $this = bless { v => Statistics::Basic::Variance->new( $vector, $size ) }, $this;

    $this->recalc;

    return $this;
}
# }}}
# recalc {{{
sub recalc {
    my $this  = shift;
    my $first = shift;

    my $var = $this->{v}->query;

    warn "[recalc stddev] sqrt( $var )\n" if $ENV{DEBUG};

    $this->{stddev} = sqrt( $var );
}
# }}}
# query {{{
sub query {
    my $this = shift;

    return $this->{stddev};
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

    warn "[set_size stddev] $size\n" if $ENV{DEBUG};
    croak "strange stddev" if $size < 1;

    $this->{v}->set_size( $size );
    $this->recalc;
}
# }}}
# insert {{{
sub insert {
    my $this = shift;

    warn "[insert stddev]\n" if $ENV{DEBUG};

    $this->{v}->insert( @_ );
    $this->recalc;
}
# }}}
# ginsert {{{
sub ginsert {
    my $this = shift;

    warn "[ginsert stddev]\n" if $ENV{DEBUG};

    $this->{v}->ginsert( @_ );
    $this->recalc;
}
# }}}
# set_vector {{{
sub set_vector {
    my $this = shift;

    warn "[set_vector stddev]\n" if $ENV{DEBUG};

    $this->{v}->set_vector( @_ );
    $this->recalc;
}
# }}}

__END__
# Below is stub documentation for your module. You better edit it!

=head1 NAME

    Statistics::Basic::StdDev

=head1 SYNOPSIS

A machine to calculate the standard deviation of a given vector.

=head1 ENV VARIABLES

=head2 DEBUG

Try setting $ENV{DEBUG}=1; or $ENV{DEBUG}=2; to see the internals.

Also, from your bash prompt you can 'DEBUG=1 perl ./myprog.pl' to
enable debugging dynamically.

=head1 AUTHOR

Please contact me with ANY suggestions, no matter how pedantic.

Jettero Heller <japh@voltar-confed.org>

=head1 SEE ALSO

perl(1)

=cut
