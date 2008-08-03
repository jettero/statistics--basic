
package Statistics::Basic::Vector;

use strict;
use warnings;
use Carp;

use Statistics::Basic;

use overload
    '0+' => sub { croak "attempt to use vector as scalar numerical value" },
    '""' => sub {
        local $" = ", ";
        my @r = map { $Statistics::Basic::fmt->format_number($_, $ENV{IPRES}) } $_[0]->query;
        "[@r]";
    },
    fallback => 1; # tries to do what it would have done if this wasn't present.

1;

# new {{{
sub new {
    my $class = shift;
    my $this  = bless {s=>0, c=>{}, v=>[]}, $class;
       $this->set_vector( @_ );

    return $this;
}
# }}}
# query {{{
sub query {
    my $this = shift;

    return (wantarray ? @{$this->{v}} : $this->{v});
}
# }}}
# copy {{{
sub copy {
    my $this = shift;
    my $that = _PACKAGE_->new( @{$this->{v}}, $this->{s} );

    $that;
}
# }}}

# fix_size {{{
sub fix_size {
    my $this = shift;
    my $norm = shift;;

    my $fixed = 0;

    return $fixed unless $this->{s} > 0;

    my $d = $this->{s} - @{$this->{v}};
    if( $d > 0 ) {
        splice @{$this->{v}}, 0, $d;
        $fixed = 1;
    }

    if( $norm and $d < 0 ) {

        unshift @{$this->{v}}, # unshift so the 0s leave first
            map {0} $d .. -1;  # add $d of them

        $fixed = 1;
    }

    warn "[fix_size vector] [@{ $this->{v} }]\n" if $ENV{DEBUG} >= 2;

    return $fixed;
}
# }}}
# set_size {{{
sub set_size {
    my $this = shift;
    my $size = shift;
    my $norm = shift;

    croak "strange size" if $size < 1;

    if( $this->{s} != $size ) {
        $_->recalc_needed for values %{$this->{c}};
        $this->{s} = $size;
        $this->fix_size($norm);
    }
}
# }}}
# size {{{
sub size {
    my $this = shift;

    return int(@{ $this->{v} });
}
# }}}
# insert {{{
sub insert {
    my $this = shift;

    croak "you must define a vector size before using insert()" unless defined $this->{s};

    for my $e (@_) {
        if( ref($e) ) {
            if( ref($e) eq "ARRAY" ) {
                push @{ $this->{v} }, @$e;
                warn "[insert vector] @$e\n" if $ENV{DEBUG} >= 2;

            } else {
                croak "insert() elements do not make sense";
            }

        } else {
            push @{ $this->{v} }, $e;
            warn "[insert vector] $e\n" if $ENV{DEBUG} >= 2;
        }
    }

    $this->fix_size;
    $_->recalc_needed for values %{$this->{c}};
}
# }}}
# ginsert {{{
sub ginsert {
    my $this = shift;

    for my $e (@_) {
        if( ref($e) ) {
            if( ref($e) eq "ARRAY" ) {
                push @{ $this->{v} }, @$e;
                warn "[ginsert vector] @$e\n" if $ENV{DEBUG} >= 2;

            } else {
                croak "ginsert() elements do not make sense";
            }

        } else {
            push @{ $this->{v} }, $e;
            warn "[ginsert vector] $e\n" if $ENV{DEBUG} >= 2;
        }
    }

    $this->{s} = @{$this->{v}};
    $_->recalc_needed for values %{$this->{c}};
}
# }}}
# set_vector {{{
sub set_vector {
    my $this     = shift;
    my $vector   = shift;
    my $set_size = shift;

    if( ref($vector) eq "ARRAY" ) {
        $this->{v} = $vector;
        $this->{s} = int @$vector;
        $_->recalc_needed for values %{$this->{c}};

    } elsif( ref($vector) eq "Statistics::Basic::Vector") {
        $this->{s} = $vector->{s};
        $this->{v} = $vector->{v}; # this links the vectors together
        $this->{c} = $vector->{c}; # so we should link their computers too

    } elsif( defined $vector ) {
        croak "argument to set_vector() too strange";
    }

    if( defined $set_size ) {
        $this->set_size( $set_size );
    }

    warn "[set_vector vector] [@{ $this->{v} }]\n" if $ENV{DEBUG} >= 2 and ref($this->{v});
}
# }}}
