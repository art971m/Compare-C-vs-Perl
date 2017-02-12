#!/usr/bin/env perl
use strict;
use warnings;

# use lib '../lib';
# use lib './lib';
# use lib '/tmp/Geo-Distance-XS-0.13/lib';
use lib '/tmp/Geo-Distance-XS-0.13/blib/lib';
use lib '/tmp/Geo-Distance-XS-0.13/blib/arch';

use Benchmark qw(:hireswallclock cmpthese timethese);
use Excel::Writer::XLSX;
use Geo::Distance::XS;
use GIS::Distance;
use GIS::Distance::Fast;

use Data::Dumper;

use constant {
    COUNT => 4000000,
};

my $workbook = Excel::Writer::XLSX->new( '/tmp/benchmark.xlsx' );
my $worksheet = $workbook->add_worksheet();
my $xlsx_row = 0;

my $math  = Geo::Distance::XS->new();

my ( $number1, $number2 ) = ( 1.2, 1.5 );
my $results = timethese(COUNT,
    {
        'multiplication perl' =>
            sub { $math->multiply_perl( $number1, $number2 ) },
        'multiplication xs' =>
            sub { $math->multiply_xs( $number1, $number2 ) },
    },
    'none'
);
my $rows = cmpthese($results, 'all');
add_benchmark_report('Multiplication', $results, $rows);



$number1 = 20;
$results = timethese(COUNT,
    {
        'factorial perl' =>
            sub { $math->factorial_perl( $number1 ) },
        'factorial xs' =>
            sub { $math->factorial_xs( $number1 ) },
    },
    'none'
);
$rows = cmpthese($results, 'all');
add_benchmark_report('Factorial', $results, $rows);





sub add_benchmark_report{
    my ($name, $results, $rows) = @_;

    my (@full_report, @full_row);
    
    my $row = shift @{$rows};
    push @full_row, shift @{$row};
    push @full_row, 'Wallclock';
    push @full_row, @{$row};
    push @full_report, \@full_row;

    for my $row (@{$rows}) {
        my @full_row;
        my $sub_name = shift @{$row};
        push @full_row, $sub_name;
        push @full_row, sprintf("%.4f", $results->{$sub_name}->real());
        push @full_row, @{$row};
        push @full_report, \@full_row;
    }


    $worksheet->write($xlsx_row, 0, $name);
    for my $full_row (@full_report) {
        $xlsx_row++;
        my $counter = 0;
        for my $col (@{$full_row}) {
            $worksheet->write( $xlsx_row, $counter, $col);
            $counter++;
        }
    }

    $xlsx_row++;
    $xlsx_row++;
    return;
}