use strict;
use warnings;
use Geo::Distance::XS;
use Test::More;

my $geo = Geo::Distance::XS->new;
isa_ok $geo, 'Geo::Distance::XS', 'new';
can_ok $geo, qw(
	multiply_perl
	multiply_xs
);

done_testing;
