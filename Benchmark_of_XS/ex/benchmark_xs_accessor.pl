#!/usr/bin/env perl
use strict;
use warnings;

use Benchmark
    qw(:hireswallclock cmpthese timethese timethis timediff timestr);

BEGIN {

    package PerlAccessor;

    sub new {
        my $class = shift @_;
        my $self = bless {@_}, __PACKAGE__;

        return $self;
    }

    sub x0 {
        my ( $self, $val ) = @_;
        $self->{x0} = $val if ( defined $val );
        return $self->{x0};
    }

    sub x1 {
        my ( $self, $val ) = @_;
        $self->{x1} = $val if ( defined $val );
        return $self->{x1};
    }

    sub x2 {
        my ( $self, $val ) = @_;
        $self->{x2} = $val if ( defined $val );
        return $self->{x2};
    }

    sub x3 {
        my ( $self, $val ) = @_;
        $self->{x3} = $val if ( defined $val );
        return $self->{x3};
    }

    sub x4 {
        my ( $self, $val ) = @_;
        $self->{x4} = $val if ( defined $val );
        return $self->{x4};
    }

    sub x5 {
        my ( $self, $val ) = @_;
        $self->{x5} = $val if ( defined $val );
        return $self->{x5};
    }

    sub x6 {
        my ( $self, $val ) = @_;
        $self->{x6} = $val if ( defined $val );
        return $self->{x6};
    }

    sub x7 {
        my ( $self, $val ) = @_;
        $self->{x7} = $val if ( defined $val );
        return $self->{x7};
    }

    sub x8 {
        my ( $self, $val ) = @_;
        $self->{x8} = $val if ( defined $val );
        return $self->{x8};
    }

    sub x9 {
        my ( $self, $val ) = @_;
        $self->{x9} = $val if ( defined $val );
        return $self->{x9};
    }
    1;

    package XS_Accessor;
    use Class::XSAccessor
        accessors   => [qw{x0 x1 x2 x3 x4 x5 x6 x7 x8 x9}],
        constructor => 'new';
    1;

}

my %input = (
    x0 => 'var0',
    x1 => 'var1',
    x2 => 'var2',
    x3 => 'var3',
    x4 => 'var4',
    x5 => 'var5',
    x6 => 'var6',
    x7 => 'var7',
    x8 => 'var8',
    x9 => 'var9'
);
my $pa = PerlAccessor->new(%input);
my $xs = XS_Accessor->new(%input);

sub benchmark_perl_create {
    my $pa = PerlAccessor->new(%input);
    return $pa;
}

sub benchmark_xs_create {
    my $xs = XS_Accessor->new(%input);
    return $xs;
}

sub benchmark_perl_access {
    my @output = (
        $pa->x0(), $pa->x1(), $pa->x2(), $pa->x3(), $pa->x4(), $pa->x5(),
        $pa->x6(), $pa->x7(), $pa->x8(), $pa->x9(),
    );

    return \@output;
}

sub benchmark_xs_access {
    my @output = (
        $xs->x0(), $xs->x1(), $xs->x2(), $xs->x3(), $xs->x4(), $xs->x5(),
        $xs->x6(), $xs->x7(), $xs->x8(), $xs->x9(),
    );
    return \@output;
}

my $count = 1000000;

timethese(
    $count,
    {   perl_create => \&benchmark_perl_create,
        xs_create    => \&benchmark_xs_create,
    },
    'all'
);

timethese(
    $count,
    {   perl_access => \&benchmark_perl_access,
        xs_access   => \&benchmark_xs_access,
    },
    'all'
);

