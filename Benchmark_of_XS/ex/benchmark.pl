#!/usr/bin/env perl
use strict;
use warnings;

use lib '/tmp/Benchmark_of_XS/blib/lib';
use lib '/tmp/Benchmark_of_XS/blib/arch';

use Benchmark qw(cmpthese timethese);
use Benchmark::of::XS;
use GIS::Distance;
use GIS::Distance::Fast;

# When benchmarking, need to have it call import/unimport before the
# code is executed.
my $orig_timethis_sub = \&Benchmark::timethis;
{
    no warnings 'redefine';
    *Benchmark::timethis = sub {
        my $label = $_[2];
        if ('perl' eq $label) {
            Benchmark::of::XS->unimport;
        }
        elsif ('xs' eq $label) {
            Benchmark::of::XS->import;
        }

        $orig_timethis_sub->(@_);
    };
}

# lon/lat -> lon/lat
my @coord = (-118.243103, 34.159545, -73.987427, 40.853293);

my $geo = Geo::Distance->new;
my $gis = GIS::Distance->new;

sub geo {
    my $d = $geo->distance(mile => @coord);
}

sub gis {
    # Uses lat/lon instead of lon/lat
    my $d = $gis->distance(@coord[ 1, 0, 3, 2 ]);
    return $d->mile;
}

my %gis_formula = (
    hsin  => 'Haversine',
    polar => 'Polar',
    cos   => 'Cosine',
    gcd   => 'GreatCircle',
    mt    => 'MathTrig',
    tv    => 'Vincenty',
);

for my $formula (qw(hsin tv polar cos gcd mt)) {
    print "---- [ Formula: $formula ] ------------------------------------\n";

    $geo->formula($formula);
    $gis->formula($gis_formula{$formula});

    Benchmark::of::XS->unimport;
    printf "perl     - distance from LA to NY: %s miles\n", geo();

    Benchmark::of::XS->import;
    printf "xs       - distance from LA to NY: %s miles\n", geo();

    printf "gis_fast - distance from LA to NY: %s miles\n", gis();
    print "\n";

    cmpthese - 1, {
        perl     => \&geo,
        xs       => \&geo,
        gis_fast => \&gis,
    };
    print "\n";
}
