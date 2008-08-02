
package Statistics::Basic::Mode;

use strict;
use warnings;
use Carp;

use Statistics::Basic;

use overload
    '""' => sub {
        my $q = $_[0]->query; return $q if ref $q; # vectors interpolate themselves
        $Statistics::Basic::fmt->format_number($_[0]->query, $ENV{IPRES});
    },
    '0+' => sub {
        my $q = $_[0]->query;
        croak "result is multimodal and cannot be used as a number" if ref $q;
        $q;
    },
    fallback => 1; # tries to do what it would have done if this wasn't present.

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

    delete $this->{mode};
    my $max = 0;
    for my $val ($this->{v}->query) {
        my $t = ++ $mode{$val};
        $max = $t if $t > $max;
    }
    my @a = sort {$a<=>$b} grep { $mode{$_}==$max } keys %mode;

    $this->{mode} = ( (@a == 1) ?  $a[0] : Statistics::Basic::Vector->new(\@a) );

    warn "[recalc mode] count of $this->{mode} = $max\n" if $ENV{DEBUG};
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
