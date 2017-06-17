use strict;
use warnings;
use Geo::Distance::XS;
use Test::More tests => 2;

my $geo = new_ok( 'Geo::Distance::XS' );
can_ok $geo, qw(
	multiply_perl
	multiply_xs

    factorial_perl
	factorial_xs

	split_perl
	split_xs
);