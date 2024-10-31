package lib::net;

use strict;
use warnings;
no warnings "uninitialized";

use Data::Dumper qw(Dumper);
use Net::IP;

sub new {
    my $class = shift;
    my $self  = shift;

    $class = ref $class if ref $class;
    bless $self, $class;

    return $self;
}

sub get_all_ip_by_netblock {
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

    my $ping_cmd;
    if ( $self->{ osname } eq 'MSWin32' ) {
        $ping_cmd = "ping -n $self->{number_pings_to_one_ip} $ip";
    } else {
        $ping_cmd = "ping -c $self->{number_pings_to_one_ip} $ip";
    }

    my $ping_results = `$ping_cmd`;
    my ( $min_ping, $avg_ping, $max_ping );
    my @ping_rows = split( /\n/, $ping_results );

    if ( $self->{ osname } eq 'MSWin32' ) {
        ( $min_ping, $max_ping, $avg_ping ) = ( $1, $2, $3 ) if ( $ping_rows[ $#ping_rows ] =~ m/\s*=\s*(\d*)\s*.*\s*=\s*(\d*)\s*.*\s*=\s*(\d*)\s*.*/g );
    } else {
        ( $min_ping, $avg_ping, $max_ping ) = ( $1, $2, $3 )
            if ( $ping_rows[ $#ping_rows ] =~ m/\s*=\s*(\d*\.\d*)\/(\d*\.\d*)\/(\d*\.\d*)/g );
    }

    $self->{ log }->debug( 'min_ping = ' . $min_ping );
    $self->{ log }->debug( 'max_ping = ' . $max_ping );
    $self->{ log }->debug( 'avg_ping = ' . $avg_ping );

    return $avg_ping;
}

sub traceroute {
    my $self = shift;
    my $ip   = shift;

    my $hops = undef;
    my $trace_cmd;

    if ( $self->{ osname } eq 'MSWin32' ) {
        $trace_cmd = "tracert $ip";
    } else {
        $trace_cmd = "traceroute -I $ip";
    }
    my $trace_result = `$trace_cmd`;
    my @trace_rows   = split( /\n/, $trace_result );
    @trace_rows = grep { /^\s*\d{1,}\s*/ } @trace_rows;

    $self->{ log }->debug( 'trace_result = ' . $trace_result );
    $hops = $1 if ( $trace_rows[ $#trace_rows ] =~ m/^\s*(\d{1,2})\s{2}.*$/g );

    return $hops;
}

1;
