
package Statistics::Basic::_overloader;

use strict;
use warnings;

use Number::Format;
use overload
    '""' => \&interpolate,
    '0+' => \&numberize,

    fallback => 1; # tries to do what it would have done if this wasn't present.


our $fmt;

sub interpolate { 
    my $this = shift;
}

sub numberize { 
    my $this = shift;

    $fmt ||= new Number::Format;

    $fmt->format_number( $this->query, 2 );
}

1;
