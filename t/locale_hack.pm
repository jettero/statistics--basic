use Statistics::Basic ();
# Make sure Number::Format is using a decimal point.
# See https://rt.cpan.org/Ticket/Display.html?id=100943
$Statistics::Basic::fmt = Number::Format->new(-decimal_point => '.');
1;
