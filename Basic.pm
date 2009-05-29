
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

our $VERSION = 1.6007;
our $fmt = new Number::Format;

$ENV{DEBUG} ||= 0;
$ENV{IPRES} ||= 2;

# probably best to not set a default
# $ENV{TOLER} ||= 0.000_000_000_1; # differences smaller this will test equal for the overloaded objects

use base 'Exporter';

our @EXPORT      = ();
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
    filter_missing_values
));
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

1;

sub computed { my $r = eval { ref($_[0]) ? Statistics::Basic::ComputedVector->new( $_[0] )   : Statistics::Basic::ComputedVector->new( [@_] );   }; croak $@ if $@; $r }

sub vector   { my $r = eval { ref($_[0]) ? Statistics::Basic::Vector->new( $_[0] )   : Statistics::Basic::Vector->new( [@_] );   }; croak $@ if $@; $r }
sub mean     { my $r = eval { ref($_[0]) ? Statistics::Basic::Mean->new( $_[0] )     : Statistics::Basic::Mean->new( [@_] );     }; croak $@ if $@; $r }
sub median   { my $r = eval { ref($_[0]) ? Statistics::Basic::Median->new( $_[0] )   : Statistics::Basic::Median->new( [@_] );   }; croak $@ if $@; $r }
sub mode     { my $r = eval { ref($_[0]) ? Statistics::Basic::Mode->new( $_[0] )     : Statistics::Basic::Mode->new( [@_] );     }; croak $@ if $@; $r }
sub variance { my $r = eval { ref($_[0]) ? Statistics::Basic::Variance->new( $_[0] ) : Statistics::Basic::Variance->new( [@_] ); }; croak $@ if $@; $r }
sub stddev   { my $r = eval { ref($_[0]) ? Statistics::Basic::StdDev->new( $_[0] )   : Statistics::Basic::StdDev->new( [@_] );   }; croak $@ if $@; $r }

sub covariance     { my $r = eval { Statistics::Basic::Covariance->new( $_[0],$_[1] ) };     croak $@ if $@; $r}
sub correlation    { my $r = eval { Statistics::Basic::Correlation->new( $_[0],$_[1] ) };    croak $@ if $@; $r}
sub leastsquarefit { my $r = eval { Statistics::Basic::LeastSquareFit->new( $_[0],$_[1] ) }; croak $@ if $@; $r}

sub filter_missing_values {
    my ($v1,$v2) = @_;
    my $v3 = eval { computed($v1) }; croak $@ if $@;
    my $v4 = eval { computed($v2) }; croak $@ if $@;

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
