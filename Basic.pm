
package Statistics::Basic;

use strict;
use warnings;
use Carp;

use Number::Format;
use Statistics::Basic::Covariance;
use Statistics::Basic::Correlation;
use Statistics::Basic::LeastSquareFit;
use Statistics::Basic::Mean;
use Statistics::Basic::Median;
use Statistics::Basic::Mode;
use Statistics::Basic::StdDev;
use Statistics::Basic::Variance;
use Statistics::Basic::Vector;
use Statistics::Basic::ComputedVector;

our $VERSION = '1.6600';
our $fmt = new Number::Format;

$ENV{NOFILL} ||= 0;
$ENV{DEBUG}  ||= 0;
$ENV{IPRES}  ||= 2;

# probably best to not set a default
# $ENV{TOLER} ||= 0.000_000_000_1; # differences smaller this will test equal for the overloaded objects

use base 'Exporter';

#our @EXPORT      = ();
our @EXPORT_OK   = (qw(
    vector computed
    mean average avg
    median
    mode
    variance var
    stddev
    covariance cov
    correlation cor corr
    leastsquarefit LSF lsf
    handle_missing_values
    FILL NOFILL
));
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

1;

sub computed { my $r = eval { Statistics::Basic::ComputedVector->new(@_) } or croak $@; return $r }

sub vector   { my $r = eval { Statistics::Basic::Vector->new(@_)   } or croak $@; return $r }
sub mean     { my $r = eval { Statistics::Basic::Mean->new(@_)     } or croak $@; return $r }
sub median   { my $r = eval { Statistics::Basic::Median->new(@_)   } or croak $@; return $r }
sub mode     { my $r = eval { Statistics::Basic::Mode->new(@_)     } or croak $@; return $r }
sub variance { my $r = eval { Statistics::Basic::Variance->new(@_) } or croak $@; return $r }
sub stddev   { my $r = eval { Statistics::Basic::StdDev->new(@_)   } or croak $@; return $r }

sub covariance     { my $r = eval { Statistics::Basic::Covariance->new(     $_[0], $_[1] ) } or croak $@; return $r }
sub correlation    { my $r = eval { Statistics::Basic::Correlation->new(    $_[0], $_[1] ) } or croak $@; return $r }
sub leastsquarefit { my $r = eval { Statistics::Basic::LeastSquareFit->new( $_[0], $_[1] ) } or croak $@; return $r }

sub handle_missing_values {
    my ($v1,$v2) = @_;

    my $v3 = eval { computed($v1) } or croak $@;
    my $v4 = eval { computed($v2) } or croak $@;

    $v3->set_filter(sub {
        my @v = $v2->query;
        map {$_[$_]} grep { defined $v[$_] and defined $_[$_] } 0 .. $#_;
    });

    $v4->set_filter(sub {
        my @v = $v1->query;
        map {$_[$_]} grep { defined $v[$_] and defined $_[$_] } 0 .. $#_;
    });

    return ($v3,$v4);
}

*average = *mean;
*avg     = *mean;
*var     = *variance;

*cov  = *covariance;
*cor  = *correlation;
*corr = *correlation;
*lsf  = *leastsquarefit;
*LSF  = *leastsquarefit;

1;
