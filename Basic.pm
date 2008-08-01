
package Statistics::Basic;

use strict;
use warnings;

use Carp;

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

use base 'Exporter';

our @EXPORT      = ();
our @EXPORT_OK   = (qw(mean average avg));
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

1;

sub mean {
    return Statistics::Basic::Mean->new( $_[0] ) if ref $_[0];
    return Statistics::Basic::Mean->new( [@_] );
}
*average = *mean;
*avg     = *mean;
