
package Statistics::Basic::Mean;

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
    my $class    = shift;
    my $vector   = shift;
    my $set_size = shift;

    warn "[new mean]\n" if $ENV{DEBUG} >= 2;

    my $this = bless {}, $class;

    if( ref($vector) eq "ARRAY" ) {
        $this->{v} = new Statistics::Basic::Vector( $vector, $set_size );

    } elsif( ref($vector) eq "Statistics::Basic::Vector" ) {
        my $c = $vector->get_computer("mean");
        return $c if $c;

        $this->{v} = $vector;
        $this->{v}->set_size( $set_size ) if defined $set_size;

    } elsif( defined($vector) ) {
        croak "argument to new() too strange";

    } else {
        $this->{v} = new Statistics::Basic::Vector;
    }

    $this->{rnc} = 1;
    $this->{v}->set_computer( mean => $this );

    return $this;
}
# }}}
# recalc {{{
sub recalc {
    my $this        = shift;
    my $sum         = 0; 
    my $cardinality = $this->{v}->size;

    delete $this->{rnc};
    delete $this->{mean};
    return unless $cardinality > 0;

    $sum += $_ for $this->{v}->query;

    $this->{mean} = ($sum / $cardinality);

    warn "[recalc mean] ($sum/$cardinality) = $this->{mean}\n" if $ENV{DEBUG};
}
# }}}
# query {{{
sub query {
    my $this = shift;

    $this->recalc if $this->{rcn};

    return $this->{mean};
}
# }}}
sub recalc_needed {
    my $this = shift;
       $this->{rnc} = 1;
}

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

    eval { $this->{v}->set_size($size) }; croak $@ if $@;
}
# }}}
# set_vector {{{
sub set_vector {
    my $this = shift;

    warn "[set_vector mean]\n" if $ENV{DEBUG};

    $this->{v}->set_vector(@_);
}
# }}}
# insert {{{
sub insert {
    my $this = shift;

    warn "[insert mean]\n" if $ENV{DEBUG};

    $this->{v}->insert(@_);
}
# }}}
# ginsert {{{
sub ginsert {
    my $this = shift;

    warn "[ginsert mean]\n" if $ENV{DEBUG};

    $this->{v}->ginsert(@_);
}
# }}}
