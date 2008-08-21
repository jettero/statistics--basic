
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

our $VERSION = "1.5";
our $fmt = new Number::Format;

$ENV{DEBUG} ||= 0;
$ENV{IPRES} ||= 2;

use base 'Exporter';

our @EXPORT      = ();
our @EXPORT_OK   = (qw(
    vector
    mean average avg
    median
    mode
    variance var
    stddev
    covariance cov
    correlation cor corr
    leastsquarefit LSF lsf
));
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

1;

sub vector   { my $r = eval { ref($_[0]) ? Statistics::Basic::Vector->new( $_[0] )   : Statistics::Basic::Vector->new( [@_] );   }; croak $@ if $@; $r }
sub mean     { my $r = eval { ref($_[0]) ? Statistics::Basic::Mean->new( $_[0] )     : Statistics::Basic::Mean->new( [@_] );     }; croak $@ if $@; $r }
sub median   { my $r = eval { ref($_[0]) ? Statistics::Basic::Median->new( $_[0] )   : Statistics::Basic::Median->new( [@_] );   }; croak $@ if $@; $r }
sub mode     { my $r = eval { ref($_[0]) ? Statistics::Basic::Mode->new( $_[0] )     : Statistics::Basic::Mode->new( [@_] );     }; croak $@ if $@; $r }
sub variance { my $r = eval { ref($_[0]) ? Statistics::Basic::Variance->new( $_[0] ) : Statistics::Basic::Variance->new( [@_] ); }; croak $@ if $@; $r }
sub stddev   { my $r = eval { ref($_[0]) ? Statistics::Basic::StdDev->new( $_[0] )   : Statistics::Basic::StdDev->new( [@_] );   }; croak $@ if $@; $r }

sub covariance     { my $r = eval { Statistics::Basic::Covariance->new( $_[0],$_[1] ) };     croak $@ if $@; $r}
sub correlation    { my $r = eval { Statistics::Basic::Correlation->new( $_[0],$_[1] ) };    croak $@ if $@; $r}
sub leastsquarefit { my $r = eval { Statistics::Basic::LeastSquareFit->new( $_[0],$_[1] ) }; croak $@ if $@; $r}

*average = *mean;
*avg     = *mean;
*var     = *variance;

*cov  = *covariance;
*cor  = *correlation;
*corr = *correlation;
*lsf  = *leastsquarefit;
*LSF  = *leastsquarefit;
