#!/usr/bin/env perl
use strict;
use warnings;

# use lib '../lib';
# use lib './lib';
# use lib '/tmp/Geo-Distance-XS-0.13/lib';
use lib '/tmp/Geo-Distance-XS-0.13/blib/lib';
use lib '/tmp/Geo-Distance-XS-0.13/blib/arch';

use Benchmark qw(:hireswallclock cmpthese timethese timethis timediff timestr);
use Excel::Writer::XLSX;
use Geo::Distance::XS;
use GIS::Distance;
use GIS::Distance::Fast;

use Devel::Size qw(size total_size);
use Proc::ProcessTable;

use Data::Dumper;

#############################################################################
# ldap_xs_create: 120.132 wallclock secs ( 2.41 usr +  4.80 sys =  7.21 CPU) @  0.14/s (n=1)
# ldap_create: 130.179 wallclock secs (12.34 usr + 19.81 sys = 32.15 CPU) @  0.03/s (n=1)

# ldap_xs_search: 6.0718 wallclock secs ( 0.60 usr +  0.99 sys =  1.59 CPU) @  0.63/s (n=1)
# ldap_search: 18.4984 wallclock secs (15.62 usr +  0.00 sys = 15.62 CPU) @  0.06/s (n=1)

# ldap_xs_update: 35.3147 wallclock secs ( 2.37 usr +  4.38 sys =  6.75 CPU) @  0.15/s (n=1)
# ldap_update: 59.8192 wallclock secs ( 9.33 usr + 19.24 sys = 28.57 CPU) @  0.04/s (n=1)

# ldap_xs_delete: 153.281 wallclock secs ( 4.78 usr + 11.55 sys = 16.33 CPU) @  0.06/s (n=1)
# ldap_delete: 250.63 wallclock secs (29.77 usr + 49.96 sys = 79.73 CPU) @  0.01/s (n=1)


          
########
# LDAP #
########
use constant {
    BASE          => 'ou=users,dc=ubs,dc=com',
    DN_FORMAT     => 'ubsUserID=user%s,ou=users,dc=ubs,dc=com',
    ENTRY_COUNT   => 100000,
    OBJECTCLASSES => [qw( top ubsUserObjectClass )],
    ATTR_USERID   => 'ubsUserID',
    ATTR_DESC     => 'description',
};

use constant {
    DN_FORMAT     => ATTR_USERID . '=user%s,' . BASE,
    FILTER_FORMAT => ATTR_USERID . '=user%s',
};

use Net::LDAP qw();
use Net::LDAP::Entry qw();
use Net::LDAPxs qw();
use Net::LDAPxs::Entry qw();
use Net::LDAPxs::Exception qw();

#####################
#### Net::LDAPxs ####
my $ldap_xs = Net::LDAPxs->new( 'localhost', port => 1389 );
my $mesg = $ldap_xs->bind( 'cn=Directory Manager', password => 'password' );
$mesg->code && die "failed to bind: ", $mesg->errstr;

my $t_ldap_xs_create = timethis(1, sub {
    for my $i ( 1 .. ENTRY_COUNT ) {
        my $dn = sprintf DN_FORMAT, $i;
        my $result = $ldap_xs->add(
            $dn,
            attrs => {
                objectClass => OBJECTCLASSES,
                description => $i,
            }
        );
        $result->code && warn "failed to add entry: ", $result->errstr;
    }
}, 'ldap_xs_create');

my $t_ldap_xs_search = timethis(1, sub {
    $mesg = $ldap_xs->search(
        base   => BASE,
        scope => 'one',
        filter => '(objectClass=*)',
    );
    $mesg->isa('Net::LDAPxs::Exception') && die $mesg->errstr;
}, 'ldap_xs_search');

my $t_ldap_xs_update = timethis(1, sub {
    for my $entry ( $mesg->entries() ) {

        my $result = $ldap_xs->modify(
            $entry->dn(),
            add => { (ATTR_DESC) => 'description2' },
        );

        $result->code && warn "failed to update entry: ", $result->errstr;
    }
}, 'ldap_xs_update');

my $t_ldap_xs_delete = timethis(1, sub {
    for my $i ( 1 .. ENTRY_COUNT ) {
        my $filter = sprintf FILTER_FORMAT, $i;
        $mesg = $ldap_xs->search(
            base   => BASE,
            filter => $filter,
        );
        $mesg->isa('Net::LDAPxs::Exception') && die $mesg->errstr;

        for my $entry ( $mesg->entries() ) {
            my $result = $ldap_xs->delete( $entry->dn() );
            $result->code && warn "failed to del entry: ", $result->errstr;
        }

    }
}, 'ldap_xs_delete');


#####################
##### Net::LDAP #####
my $ldap = Net::LDAP->new( 'localhost', port => 1389 );
$mesg = $ldap->bind( 'cn=Directory Manager', password => 'password' );
$mesg->code && die "failed to bind: ", $mesg->error;

my $t_ldap_create = timethis(1, sub {
    for my $i ( 1 .. ENTRY_COUNT ) {
        my $dn = sprintf DN_FORMAT, $i;
        my $entry = Net::LDAP::Entry->new(
            $dn,
            objectClass => OBJECTCLASSES,
            description => $i,
        );
        my $result = $ldap->add($entry);
        $result->code && warn "failed to add entry: ", $result->error;
    }
}, 'ldap_create');

my $t_ldap_search = timethis(1, sub {
    $mesg = $ldap->search(
        base   => BASE,
        scope => 'one',
        filter => '(objectClass=*)',
    );
    $mesg->code && die $mesg->error;
}, 'ldap_search');

my $t_ldap_update = timethis(1, sub {
    for my $entry ( $mesg->entries() ) {
        $entry->add((ATTR_DESC) => 'description2');
        my $result = $entry->update($ldap);
        $result->code && warn "failed to update entry: ", $result->error;
    }
}, 'ldap_update');

my $t_ldap_delete = timethis(1, sub {
    for my $i ( 1 .. ENTRY_COUNT ) {
        my $filter = sprintf FILTER_FORMAT, $i;
        $mesg = $ldap->search(
            base   => BASE,
            filter => $filter,
        );
        $mesg->code && die $mesg->error;

        for my $entry ( $mesg->entries() ) {
            my $result = $ldap->delete($entry);
            $result->code && warn "failed to del entry: ", $result->error;
        }
    }
}, 'ldap_delete');

print "\n\n";

cmpthese({
    ldap_create => $t_ldap_create,
    ldap_xs_create => $t_ldap_xs_create,
}, 'all' );

cmpthese({
    ldap_search => $t_ldap_search,
    ldap_xs_search => $t_ldap_xs_search,
}, 'all' );

cmpthese({
    ldap_update => $t_ldap_update,
    ldap_xs_update => $t_ldap_xs_update,
}, 'all' );

cmpthese({
    ldap_delete => $t_ldap_delete,
    ldap_xs_delete => $t_ldap_xs_delete,
}, 'all' );

# print Dumper $t_ldap_create;
# print Dumper $t_ldap_xs_create;
# print Dumper timediff($t_ldap_create, $t_ldap_xs_create);
# print Dumper timestr(timediff($t_ldap_create, $t_ldap_xs_create));
exit;

#############################################################################

########
#  #
########
use constant {
    COUNT => 4000000,
};

my $workbook  = Excel::Writer::XLSX->new('/tmp/benchmark.xlsx');
my $worksheet = $workbook->add_worksheet();
my $xlsx_row  = 0;

my $math = Geo::Distance::XS->new();

my ( $number1, $number2 ) = ( 1.2, 1.5 );
my $results = timethese( COUNT,
    {   'multiplication perl' =>
            sub { $math->multiply_perl( $number1, $number2 ) },
        'multiplication xs' =>
            sub { $math->multiply_xs( $number1, $number2 ) },
    },
    'none'
);

print Dumper $results; die "FFFFFFFFFFFFF";
my $rows = cmpthese( $results, 'all' );
add_benchmark_report( 'Multiplication', $results, $rows );


$number1 = 20;
$results = timethese( COUNT,
    {   'factorial perl' => sub { $math->factorial_perl($number1) },
        'factorial xs'   => sub { $math->factorial_xs($number1) },
    },
    'none'
);
$rows = cmpthese( $results, 'all' );
add_benchmark_report( 'Factorial', $results, $rows );


#############################################################################

########
# Subs #
########
sub add_benchmark_report {
    my ( $name, $results, $rows ) = @_;

    my ( @full_report, @full_row );

    my $row = shift @{$rows};
    push @full_row,    shift @{$row};
    push @full_row,    'Wallclock';
    push @full_row,    @{$row};
    push @full_report, \@full_row;

    for my $row ( @{$rows} ) {
        my @full_row;
        my $sub_name = shift @{$row};
        push @full_row,    $sub_name;
        push @full_row,    sprintf( "%.4f", $results->{$sub_name}->real() );
        push @full_row,    @{$row};
        push @full_report, \@full_row;
    }


    $worksheet->write( $xlsx_row, 0, $name );
    for my $full_row (@full_report) {
        $xlsx_row++;
        my $counter = 0;
        for my $col ( @{$full_row} ) {
            $worksheet->write( $xlsx_row, $counter, $col );
            $counter++;
        }
    }

    $xlsx_row++;
    $xlsx_row++;
    return;
}
