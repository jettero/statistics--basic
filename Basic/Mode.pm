
package Statistics::Basic::Mode;

use strict;
no warnings;
use Carp;

use Statistics::Basic::Vector;

1;

# new {{{
sub new {
    my $this     = shift;
    my $vector   = shift;
    my $set_size = shift;

    warn "[new mode]\n" if $ENV{DEBUG} >= 2;

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
    my %mode;
    my $mode_count  = 0;

    unless( $cardinality > 0 ) {
        $this->{mode} = undef;

        return;
    }

    $this->{'mode'} = undef;
    foreach my $val ($this->{'v'}->query()) {
      $mode{$val}++;
      if (not defined $this->{'mode'}) {
        $this->{'mode'} = $val;
        $mode_count = $mode{$val};
      } elsif ($mode{$val} > $mode_count) {
        $this->{'mode'} = $val;
        $mode_count = $mode{$val};
      }
    }

    warn "[recalc mode] count of $this->{mode} = $mode{$this->{mode}}\n" if $ENV{DEBUG};
}
# }}}
# query {{{
sub query {
    my $this = shift;

    return $this->{mode};
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

    warn "[set_size mode] $size\n" if $ENV{DEBUG};
    croak "strange size" if $size < 1;

    $this->{v}->set_size($size);
    $this->recalc;
}
# }}}
# set_vector {{{
sub set_vector {
    my $this = shift;

    warn "[set_vector mode]\n" if $ENV{DEBUG};

    $this->{v}->set_vector(@_);
    $this->recalc;
}
# }}}
# insert {{{
sub insert {
    my $this = shift;

    warn "[insert mode]\n" if $ENV{DEBUG};

    $this->{v}->insert(@_);
    $this->recalc;
}
# }}}
# ginsert {{{
sub ginsert {
    my $this = shift;

    warn "[ginsert mode]\n" if $ENV{DEBUG};

    $this->{v}->ginsert(@_);
    $this->recalc;
}
# }}}

__END__
# Below is stub documentation for your module. You better edit it!

=head1 NAME

    Statistics::Basic::Mode

=head1 SYNOPSIS

    A machine to calculate the mode of a given vector.

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
