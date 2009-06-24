
package Statistics::Basic::ComputedVector;

use strict;
use warnings;
use Carp;

use Statistics::Basic;
use base 'Statistics::Basic::Vector';

1;

# new {{{
sub new {
    my $class = shift;
    my $that  = shift;

    if( defined $that ) {
        $that = eval { Statistics::Basic::Vector->new($that) }; croak $@ if $@;
    }
    croak "input vector must be supplied to ComputedVector" unless defined $that;

    my $this = bless { c=>{}, input_vector=>$that, output_vector=>Statistics::Basic::Vector->new() }, $class;
       $this->_recalc;

    if( $_[0] ) {
        eval { $this->_set_computer(@_) }; croak $@ if $@;
    }

    $this;
}
# }}}
# set_filter {{{
sub set_filter {
    my $this = shift;
    my $cref = shift; croak "cref should be a code reference" unless ref($cref) eq "CODE";

    $this->{computer} = $cref;

    my $a = Scalar::Util::refaddr($this);
    $this->{input_vector}->_set_computer( "cvec_$a" => $this );
}
# }}}
# _recalc {{{
sub _recalc {
    my $this = shift;

    delete $this->{recalc_needed};
    delete $this->{mean};

    if( ref( my $c = $this->{computer} ) eq "CODE" ) {
        $this->{output_vector}->set_vector( [$c->($this->{input_vector}->query)] );

    } else {
        $this->{output_vector}->set_vector( [$this->{input_vector}->query] );
    }

    warn "[recalc computed vector]\n" if $ENV{DEBUG};
    $this->_inform_computers_of_change;
}
# }}}
# _recalc_needed {{{
sub _recalc_needed {
    my $this = shift;
       $this->{recalc_needed} = 1;

    warn "[recalc_needed mean]\n" if $ENV{DEBUG};
}
# }}}
# query_size {{{
sub query_size {
    my $this = shift;

    $this->_recalc if $this->{recalc_needed};

    $this->{output_vector}->query_size;
}

# maybe deprecate this later
*size = *query_size unless $ENV{TEST_AUTHOR};

# }}}
# query {{{
sub query {
    my $this = shift;

    $this->_recalc if $this->{recalc_needed};

    return $this->{output_vector}->query;
}
# }}}
# query_filled {{{
sub query_filled {
    my $this = shift;

    $this->_recalc if $this->{recalc_needed};

    return $this->{output_vector}->query_filled;
}
# }}}

sub fix_size   { croak   "fix_size() makes no sense on computed vectors" }
sub set_size   { croak   "set_size() makes no sense on computed vectors" }
sub insert     { croak     "insert() makes no sense on computed vectors" }
sub ginsert    { croak    "ginsert() makes no sense on computed vectors" }
sub set_vector { croak "set_vector() makes no sense on computed vectors" }
