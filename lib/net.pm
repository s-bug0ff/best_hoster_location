package lib::net;

use strict;
use warnings;
no warnings "uninitialized";

use Data::Dumper qw(Dumper);
use Net::Ping;
use Net::IP;

sub new {
    my $class = shift;
    my $self  = shift;

    $class = ref $class if ref $class;
    bless $self, $class;

    return $self;
}

sub get_all_all_ip_by_netblock {
    my $self     = shift;
    my $netblock = shift;

    my @ips;

    my $ip_obj = Net::IP->new( $netblock );
    push @ips, $ip_obj->ip() while ( ++$ip_obj );

    return \@ips;
}

sub ping {
    my $self = shift;
    my $ip   = shift;

    my @ping_results;

    foreach ( 1 .. $self->{ number_pings_to_one_ip } ) {
        my ( $got_response, $ping ) = Net::Ping->new()->ping( $ip );
        sleep( 0.5 );
        if ( $got_response ) {
            push( @ping_results, sprintf( "%.3f", $ping * 1000 ) );
        } else {
            push( @ping_results, undef );
        }
    }

    $self->{ log }->debug( 'ping_results = ' . Dumper( \@ping_results ) );

    return \@ping_results;
}

sub traceroute {
    my $self = shift;
    my $ip   = shift;

    my $hops         = undef;
    my $trace_result = `traceroute $ip`;
    $self->{ log }->debug( 'trace_result = ' . $trace_result );
    my @trace_rows = split( /\n/, $trace_result );
    $hops = $1 if ( $trace_rows[ $#trace_rows ] =~ m/^\s*(\d{1,2})\s{2}.*$/g );

    return $hops;
}

1;
