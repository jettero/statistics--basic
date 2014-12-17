
package Number::Format;

# NOTE: I couldn't reproduce the locale issues reported in 
# 
# https://rt.cpan.org/Ticket/Display.html?id=100943&results=5e852469797988f08410e6f642a6a5c8
# http://www.cpantesters.org/cpan/report/88d524a8-6322-11e4-b29a-6ad5dfbfc7aa
# 
# I was trying things like LC_ALL=de_DE.utf8; sudo locale-gen de_DE.utf8
# and it was messing up my vim sessions, but not the tests …
# 
# The test problem is Number::Format though, so I'm just hacking into that
# namespace to fix the tests.
#

$DECIMAL_POINT      = '.';  # decimal point symbol for numbers
$THOUSANDS_SEP      = ',';  # thousands separator for numbers
$POSITIVE_SIGN      = '';   # string to add for non-negative monetary
$NEGATIVE_SIGN      = '-';  # string to add for negative monetary
