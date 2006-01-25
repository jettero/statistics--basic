# vi:fdm=marker fdl=0
# $Id: Basic.pm,v 1.1 2006-01-25 22:20:40 jettero Exp $ 

package Statistics::Basic;

use strict;
no warnings;
use Carp;

our $VERSION = "0.41.3";

1;

__END__
# Below is stub documentation for your module. You better edit it!

=head1 NAME

    Statistics::Basic A collection of very basic statistics formulae for vectors.

=head1 SYNOPSIS

    # for use with one vector:
    Statistics::Basic::Mean;
    Statistics::Basic::Median;
    Statistics::Basic::Mode;
    Statistics::Basic::Variance;
    Statistics::Basic::StdDev;

    # for use with two vectors:
    Statistics::Basic::CoVariance;
    Statistics::Basic::Correlation;

=head1 EXAMPLES

    my $mean = Statistics::Basic::Mean->new($array_ref)->query;

    print "$mean\n";  # hooray

    # That works, but I needed to calculate a LOT of means for a lot of
    # arrays of the same size.  Furthermore, I needed them to operate FIFO
    # style.  So, they do:

    my $mo = new Statistics::Basic::Mean([1..3]);

    print $mo->query, "\n"; # the avearge of 1, 2, 3 is 2
          $mo->insert(4);   # Keeps the vector the same size automatically
    print $mo->query, "\n"; # so, the average of 2, 3, 4 is 3

    # You might need to keep a running average, so I included a growing
    # insert

          $mo->ginsert(5);  # Expands the vector size by one and appends a 5
    print $mo->query, "\n"; # so, the average is of 2, 3, 4, 5 is 7/2

    # And last, you might need the mean of [3, 7] after all the above

          $mo->set_vector([2,3]);  # *poof*, the vector is 2, 3!
    print $mo->query, "\n"; # and the average is now 5/2!  Tadda!

    # These functions all work pretty much the same for ::StdDev and
    # ::Variance but they work slightly differently for CoVariance and
    # Correlation.

    # Not suprisingly, the correlation of [1..3] and [1..3] is 1.0

    my $co = new Statistics::Basic::Correlation( [1..3], [1..3] );

    print $co->query, "\n";

    # Cut the correlation of [1..3, 7] and [1..3, 5] is less than 1

          $co->ginsert( 7, 5 );
    print $co->query, "\n";

=head1 BUGS

Besides the lack of documentation?  Well, I'm sure there's a bunch.
I've tried to come up with a comprehensive suite of tests, but it's
difficult to think of everything.

If you spot any bugs, please tell me.

=head1 ENV VARIABLES

=head2 DEBUG

Try setting $ENV{DEBUG}=1; or $ENV{DEBUG}=2; to see the internals.

Also, from your bash prompt you can 'DEBUG=1 perl ./myprog.pl' to
enable debugging dynamically.

=head2 UNBIAS

This module uses the sum(X - mean(X))/N definition of variance.
If you wish to use the unbiased, sum(X-mean(X)/(N-1) definition, then 
set the $ENV{UNBIAS}=1;

# And if you thought that was useful, then give a shout out to:
# Robert McGehee <xxxxxxxx@wso.williams.edu>, for he requested it.

=head1 AUTHOR

Please contact me with ANY suggestions, no matter how pedantic.

Jettero Heller <japh@voltar-confed.org>

=head1 COPYRIGHT

GPL!  I included a gpl.txt for your reading enjoyment.

Though, additionally, I will say that I'll be tickled if you were to
include this package in any commercial endeavor.  Also, any thoughts to
the effect that using this module will somehow make your commercial
package GPL should be washed away.

I hereby release you from any such silly conditions.

This package and any modifications you make to it must remain GPL.  Any
programs you (or your company) write shall remain yours (and under
whatever copyright you choose) even if you use this package's intended
and/or exported interfaces in them.

=head1 SEE ALSO

Most of the documentation is very thin.  Sorry.  The modules with their
own documentation (no matter how thin) are listed below.

Statistics::Basic::LeastSquareFit

=cut
