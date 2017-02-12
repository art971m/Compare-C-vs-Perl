#!/usr/bin/env perl
use strict;
use warnings;

# use lib '../lib';
# use lib './lib';
# use lib '/tmp/Geo-Distance-XS-0.13/lib';
use lib '/tmp/Geo-Distance-XS-0.13/blib/lib';
use lib '/tmp/Geo-Distance-XS-0.13/blib/arch';

use Benchmark qw(:hireswallclock cmpthese timethese);
use Geo::Distance::XS;
use GIS::Distance;
use GIS::Distance::Fast;

use Data::Dumper;

use constant {
    COUNT => 4000000,
};

my $math  = Geo::Distance::XS->new();
my ( $number1, $number2 ) = ( 1.2, 1.5 );

cmpthese(
    COUNT,
    {   'multiplication perl' =>
            sub { $math->multiply_perl( $number1, $number2 ) },
        'multiplication xs' =>
            sub { $math->multiply_xs( $number1, $number2 ) },
    },
    'all'
);

