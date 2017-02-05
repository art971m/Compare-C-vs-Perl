use strict;
use warnings;

use Test::More tests => 4;
BEGIN { use_ok('CvsPerl') };

is(&CvsPerl::is_even(0), 1);
is(&CvsPerl::is_even(1), 0);
is(&CvsPerl::is_even(2), 1);
