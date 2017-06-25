use strict;
use warnings;
use feature 'say';
use lib qw{blib/lib blib/arch};
use XSFun qw(:all);
say add_numbers(1, 2);
say add_numbers(1.4, 3.2);
say add_numbers_perl(1, 2);
say add_numbers_perl(1.4, 3.2);