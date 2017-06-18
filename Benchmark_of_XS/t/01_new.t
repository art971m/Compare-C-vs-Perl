use strict;
use warnings;
use Benchmark::of::XS;
use Test::More tests => 2;

my $geo = new_ok( 'Benchmark::of::XS' );
can_ok $geo, qw(
	multiply_perl
	multiply_xs

    factorial_perl
	factorial_xs

	split_perl
	split_xs

	substr_perl
	substr_xs
);