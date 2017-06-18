package Benchmark::of::XS;

use strict;
use warnings;

use Carp qw(croak);
use Geo::Distance;
use XSLoader;

our $VERSION    = '0.1';
our $XS_VERSION = $VERSION;
$VERSION = eval $VERSION;

XSLoader::load(__PACKAGE__, $XS_VERSION);

my ($orig_distance_sub, $orig_formula_sub);
BEGIN {
    $orig_distance_sub = \&Geo::Distance::distance;
    $orig_formula_sub  = \&Geo::Distance::formula;
}

my %formulas; @formulas{qw(hsin cos mt tv gcd polar alt)} = (1, 2, 2..6);
our @FORMULAS = sort keys %formulas;

sub import {
    no warnings qw(redefine);
    no strict qw(refs);

    *Geo::Distance::distance = \&{__PACKAGE__.'::distance'};
    *Geo::Distance::formula = sub {
        my $self = shift;
        if (@_) {
            my $formula = shift;
            croak "Invalid formula: $formula"
                unless exists $formulas{$formula};
            $self->{formula} = $formula;
            $self->{formula_index} = $formulas{$formula};
        }
        return $self->{formula};
    };
}

# Fall back to pure perl after calling 'no Geo::Distance::XS'.
sub unimport {
    no warnings qw(redefine);

    *Geo::Distance::formula  = $orig_formula_sub;
    *Geo::Distance::distance = $orig_distance_sub;
}



sub new {
    my ($class) = @_;
    return bless {}, __PACKAGE__;
}

sub multiply_perl {
    my ($self, $number1, $number2) = @_;
    return $number1 * $number2;
}

sub factorial_perl {
    my ($self, $number) = @_;
    
    my $result = 1;
    $result *= $number-- while ($number > 0);

    return $result;

}

sub split_perl {
    my ($self, $delimiter, $string) = @_;

    my @splited;
    my ($j, $last_i) = (0, 0);
    my $len = length($string) - 1;
    for my $i (0 .. $len ) {
        if(substr($string, $i, 1) eq $delimiter) {
            push @splited, substr($string, $j, $i - $j);
            $j = $i + 1;
        }
        $last_i = $i;
    }

    if (substr($string, $len, 1) eq $delimiter) {
        push @splited, q{};
    }

    if ($last_i >= $j) {
        push @splited, substr($string, $j, $last_i - $j + 1);
    }

    return @splited;
}

sub substr_perl {
    my ($self, $expr, $ofset, $length) = @_;
    my @str_as_array = split //, $expr;
    my @result_str_as_array = @str_as_array[$ofset .. ($ofset + $length - 1)];
    return join q{}, @result_str_as_array;
}
