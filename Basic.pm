
package Statistics::Basic;

use strict;
use Carp;
use Basic::CoVariance;
use Basic::Correlation;
use Basic::LeastSquareFit;
use Basic::Mean;
use Basic::Median;
use Basic::Mode;
use Basic::StdDev;
use Basic::Variance;
use Basic::Vector;

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
