
package Statistics::Basic::Vector;

use strict;
use warnings;
use Carp;

$ENV{DEBUG} ||= 0;

1;

# new {{{
sub new {
    my $this = shift;

    $this = bless {}, $this;

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

# fix_size {{{
sub fix_size {
    my $this = shift;
    my $x = 0;

    return $x unless defined $this->{s} and $this->{s} > 0;

    while( int(@{ $this->{v}}) > $this->{s} ) {
        shift @{ $this->{v} };
        $x = 1;
    }

    while( int(@{ $this->{v}}) < $this->{s} ) {
        push @{ $this->{v} }, 0;
        $x = 1;
    }

    warn "[fix_size vector] [@{ $this->{v} }]\n" if $ENV{DEBUG} >= 2;

    return $x;
}
# }}}
# set_size {{{
sub set_size {
    my $this = shift;
    my $size = shift;
    my $norm = not shift;

    croak "strange size" if $size < 1;

    $this->{s} = $size;
    $this->fix_size if $norm;
}
# }}}
# size {{{
sub size {
    my $this = shift;

    return 0 unless ref($this->{v});
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

    $this->{s}++;
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

    } elsif( ref($vector) eq "Statistics::Basic::Vector") {
        $this->{s} = $vector->{s};
        $this->{v} = $vector->{v}; # this is really a clone I'd say ...

    } elsif( defined $vector ) {
        croak "argument to set_vector() too strange";
    }

    if( defined $set_size ) {
        $this->set_size( $set_size );
    }

    warn "[set_vector vector] [@{ $this->{v} }]\n" if $ENV{DEBUG} >= 2 and ref($this->{v});
}
# }}}

__END__
# Below is stub documentation for your module. You better edit it!

=head1 NAME

    Statistics::Basic::Mean

=head1 SYNOPSIS

A machine to calculate the mean of a given vector.

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
