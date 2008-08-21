
package Statistics::Basic::Vector;

use strict;
use warnings;
use Carp;
use Scalar::Util qw(blessed weaken);

our $tag_number = 0;

use Statistics::Basic;

use overload
    '0+' => sub { croak "attempt to use vector as scalar numerical value" },
    '""' => sub {
        my $this = $_[0];
        local $" = ", ";
        my @r = map { $Statistics::Basic::fmt->format_number($_, $ENV{IPRES}) } $this->query;
        $ENV{DEBUG} ? "vector-$this->{tag}:[@r]" : "[@r]";
    },
    fallback => 1; # tries to do what it would have done if this wasn't present.

1;

# new {{{
sub new {
    my $class  = shift;
    my $vector = $_[0];

    if( blessed($vector) and $vector->isa(__PACKAGE__) ) {
        warn "vector->new called with blessed argument, returning $vector instead of making another\n" if $ENV{DEBUG} >= 3;
        return $vector;
    }

    my $this = bless {tag=>(++$tag_number), s=>0, c=>{}, v=>[]}, $class;
       $this->set_vector( @_ );

    warn "created new vector $this\n" if $ENV{DEBUG} >= 3;

    return $this;
}
# }}}
# copy {{{
sub copy {
    my $this = shift;
    my $that = __PACKAGE__->new( [@{$this->{v}}], $this->{s} );

    warn "copied vector($this -> $that)\n" if $ENV{DEBUG} >= 3;

    $that;
}
# }}}

# query {{{
sub query {
    my $this = shift;

    return (wantarray ? @{$this->{v}} : $this->{v});
}
# }}}
# set_computer {{{
sub set_computer {
    my $this = shift;

    while( my ($k,$v) = splice @_, 0, 2 ) {
        warn "$this set_computer($k => " . overload::StrVal($v) . ")\n" if $ENV{DEBUG};
        weaken($this->{c}{$k} = $v);
        $v->recalc_needed;
    }
}
# }}}
# set_linked_computer {{{
sub set_linked_computer {
    my $this = shift;
    my $key  = shift;
    my $var  = shift;

    my $new_key = join("_", ($key, sort {$a<=>$b} map {$_->{tag}} @_));

    $this->set_computer( $new_key => $var );
}
# }}}
# get_computer {{{
sub get_computer {
    my $this = shift;
    my $k = shift;

    warn "$this get_computer($k): " . overload::StrVal($this->{c}{$k}||"<undef>") . "\n" if $ENV{DEBUG};

    $this->{c}{$k};
}
# }}}
# get_linked_computer {{{
sub get_linked_computer {
    my $this = shift;
    my $key  = shift;

    my $new_key = join("_", ($key, sort {$a<=>$b} map {$_->{tag}} @_));

    $this->get_computer( $new_key );
}
# }}}

# fix_size {{{
sub fix_size {
    my $this = shift;
    my $norm = not shift; # 0 is normalize, 1 is no normalize

    my $fixed = 0;

    my $d = @{$this->{v}} - $this->{s};
    if( $d > 0 ) {
        splice @{$this->{v}}, 0, $d;
        $fixed = 1;
    }

    if( $norm and $d < 0 ) {
        unshift @{$this->{v}}, # unshift so the 0s leave first
            map {0} $d .. -1;  # add $d of them

        $fixed = 1;
    }

    warn "[fix_size $this] [@{ $this->{v} }]\n" if $ENV{DEBUG} >= 2;

    return $fixed;
}
# }}}
# set_size {{{
sub set_size {
    my $this = shift;
    my $size = shift;
    my $norm = shift;

    croak "strange size" if $size < 0;

    if( $this->{s} != $size ) {
        $this->{s} = $size;
        $this->fix_size($norm);
        $_->recalc_needed for values %{$this->{c}};
    }
}
# }}}
# size {{{
sub size {
    my $this = shift;

    return scalar @{$this->{v}};
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
                warn "[insert $this] @$e\n" if $ENV{DEBUG} >= 2;

            } else {
                croak "insert() elements do not make sense";
            }

        } else {
            push @{ $this->{v} }, $e;
            warn "[insert $this] $e\n" if $ENV{DEBUG} >= 2;
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
                warn "[ginsert $this] @$e\n" if $ENV{DEBUG} >= 2;

            } else {
                croak "ginsert() elements do not make sense";
            }

        } else {
            push @{ $this->{v} }, $e;
            warn "[ginsert $this] $e\n" if $ENV{DEBUG} >= 2;
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

    } elsif( UNIVERSAL::isa($vector, "Statistics::Basic::Vector") ) {
        $this->{s} = $vector->{s};
        $this->{v} = $vector->{v}; # this links the vectors together
        $this->{c} = $vector->{c}; # so we should link their computers too

    } elsif( defined $vector ) {
        croak "argument to set_vector() too strange";
    }

    if( defined $set_size ) {
        $this->set_size( $set_size );
    }

    warn "[set_vector $this] [@{ $this->{v} }]\n" if $ENV{DEBUG} >= 2 and ref($this->{v});
}
# }}}
