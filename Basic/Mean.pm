
package Statistics::Basic::Mean;

use strict;
use warnings;
use Carp;

use Statistics::Basic::Vector;

our $fmt;
use Number::Format;
use overload
    '""' => sub { $fmt ||= new Number::Format; $fmt->format_number($_[0], $ENV{IPRES}) },
    '0+' => sub { $_[0]->query },
    fallback => 1; # tries to do what it would have done if this wasn't present.

$ENV{DEBUG} ||= 0;
$ENV{IPRES} ||= 2;

1;

# new {{{
sub new {
    my $this     = shift;
    my $vector   = shift;
    my $set_size = shift;

    warn "[new mean]\n" if $ENV{DEBUG} >= 2;

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
    my $sum         = 0; 
    my $cardinality = $this->{v}->size;

    unless( $cardinality > 0 ) {
        $this->{mean} = undef;

        return;
    }

    $sum += $_ for $this->{v}->query;

    $this->{mean} = ($sum / $cardinality);

    warn "[recalc mean] ($sum/$cardinality) = $this->{mean}\n" if $ENV{DEBUG};
}
# }}}
# query {{{
sub query {
    my $this = shift;

    return $this->{mean};
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

    warn "[set_size mean] $size\n" if $ENV{DEBUG};
    croak "strange size" if $size < 1;

    $this->{v}->set_size($size);
    $this->recalc;
}
# }}}
# set_vector {{{
sub set_vector {
    my $this = shift;

    warn "[set_vector mean]\n" if $ENV{DEBUG};

    $this->{v}->set_vector(@_);
    $this->recalc;
}
# }}}
# insert {{{
sub insert {
    my $this = shift;

    warn "[insert mean]\n" if $ENV{DEBUG};

    $this->{v}->insert(@_);
    $this->recalc;
}
# }}}
# ginsert {{{
sub ginsert {
    my $this = shift;

    warn "[ginsert mean]\n" if $ENV{DEBUG};

    $this->{v}->ginsert(@_);
    $this->recalc;
}
# }}}
