use strict;
use warnings;

use Test::More tests => 9;
BEGIN { use_ok('CvsPerl') };

is(&CvsPerl::is_even(0), 1);
is(&CvsPerl::is_even(1), 0);
is(&CvsPerl::is_even(2), 1);

my $i;
$i = -1.5; &CvsPerl::round($i); is( $i, -2.0 );
$i = -1.1; &CvsPerl::round($i); is( $i, -1.0 );
$i = 0.0; &CvsPerl::round($i);  is( $i,  0.0 );
$i = 0.5; &CvsPerl::round($i);  is( $i,  1.0 );
$i = 1.2; &CvsPerl::round($i);  is( $i,  1.0 );
