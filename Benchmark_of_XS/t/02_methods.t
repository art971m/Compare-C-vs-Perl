use strict;
use warnings;
use Benchmark::of::XS;
use Test::More tests => 8;

use constant { TOLERANCE => 1e-13 };


my $test_xs = Benchmark::of::XS->new;

my ( $string, $expected, $got );
$string   = q{ab;cd};
$expected = [ q{ab}, q{cd} ];
$got      = [ $test_xs->split_perl( q{;}, $string ) ];
is_deeply( $got, $expected, 'split_perl 1' );
$got = [ $test_xs->split_xs( q{;}, $string ) ];
is_deeply( $got, $expected, 'split_xs 1' );

$string   = q{;ab;cd;ef;;};
$expected = [ q{}, q{ab}, q{cd}, q{ef}, q{}, q{} ];
$got      = [ $test_xs->split_perl( q{;}, $string ) ];
is_deeply( $got, $expected, 'split_perl 2' );
$got = [ $test_xs->split_xs( q{;}, $string ) ];
is_deeply( $got, $expected, 'split_xs 2' );


my ( $number1, $number2 );
$number1  = 1.2;
$number2  = 1.5;
$expected = 1.8;
$got      = $test_xs->multiply_perl( $number1, $number2 );
ok( are_equal( $got, $expected ), 'multiply_perl' );

$got = $test_xs->multiply_xs( $number1, $number2 );
ok( are_equal( $got, $expected ), 'multiply_xs' );


$number1  = 4;
$expected = 24;
$got      = $test_xs->factorial_perl($number1);
ok( are_equal( $got, $expected ), 'factorial_perl' );

$got = $test_xs->factorial_xs($number1);
ok( are_equal( $got, $expected ), 'factorial_xs' );

# Subs #
sub are_equal {
    my ( $a, $b ) = @_;
    return ( abs( $a - $b ) < TOLERANCE );
}
