# Before 'make install' is performed this script should be runnable with
# 'make test'. After 'make install' it should work as 'perl CvsPerl.t'

#########################

# change 'tests => 2' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test::More tests => 2;
BEGIN { use_ok('CvsPerl') };
ok(1,1);
#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

is( &CvsPerl::foo(1, 2, "Hello, world!"), 7 );
is( &CvsPerl::foo(1, 2, "0.0"), 7 );
ok( abs(&CvsPerl::foo(0, 0, "-3.4") - 0.6) <= 0.01 );
