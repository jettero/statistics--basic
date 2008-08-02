
package Statistics::Basic;

use strict;
use warnings;
use Carp;

use Number::Format;
use Statistics::Basic::CoVariance;
use Statistics::Basic::Correlation;
use Statistics::Basic::LeastSquareFit;
use Statistics::Basic::Mean;
use Statistics::Basic::Median;
use Statistics::Basic::Mode;
use Statistics::Basic::StdDev;
use Statistics::Basic::Variance;
use Statistics::Basic::Vector;

our $VERSION = "0.5";
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
));
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

1;

sub vector   { return Statistics::Basic::Vector->new( $_[0] )   if ref $_[0]; return Statistics::Basic::Vector->new( [@_] );     }
sub mean     { return Statistics::Basic::Mean->new( $_[0] )     if ref $_[0]; return Statistics::Basic::Mean->new( [@_] );     }
sub median   { return Statistics::Basic::Median->new( $_[0] )   if ref $_[0]; return Statistics::Basic::Median->new( [@_] );   }
sub mode     { return Statistics::Basic::Mode->new( $_[0] )     if ref $_[0]; return Statistics::Basic::Mode->new( [@_] );     }
sub variance { return Statistics::Basic::Variance->new( $_[0] ) if ref $_[0]; return Statistics::Basic::Variance->new( [@_] ); }
sub stddev   { return Statistics::Basic::StdDev->new( $_[0] )   if ref $_[0]; return Statistics::Basic::StdDev->new( [@_] ); }

*average = *mean;
*avg     = *mean;
*var     = *variance;
