package lib::util;

use strict;
use warnings;
no warnings "uninitialized";

use POSIX        qw(ceil);
use Data::Dumper qw(Dumper);

sub new {
    my $class = shift;
    my $self  = shift;

    $class = ref $class if ref $class;
    bless $self, $class;

    return $self;
}

sub get_random_ip_pool {
    my $self = shift;
    my $ips  = shift;

    my $result;

    foreach ( 1 .. $self->{ number_ip_poll } ) {
        push( @$result, @$ips[ int rand scalar @$ips ] );
    }

    return $result;
}

sub calculate_avg_ping {
    my $self        = shift;
    my $pings_array = shift;

    my $ping_summ  = undef;
    my $ping_count = undef;

    foreach my $ping ( @$pings_array ) {
        if ( defined $ping ) {
            $ping_summ += $ping;
            $ping_count++;
        }
    }

    return defined $ping_summ && defined $ping_count ? sprintf( "%.3f", ( $ping_summ / $ping_count ) ) : undef;
}

sub group_asn_by_country {
    my $self = shift;
    my $hash = shift;

    my $grouped_by_country;
    foreach my $info ( @{ $hash->{ prefixes } } ) {
        push( @{ $grouped_by_country->{ $info->{ country } }->{ info } }, $info );
    }

    return $grouped_by_country;
}

1;