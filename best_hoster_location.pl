use strict;
use warnings;

use IO::File;
use Net::Ping;
use Net::IP;

use Data::Dumper   qw(Dumper);
use JSON::XS       qw(decode_json encode_json);
use POSIX          qw(ceil strftime);
use File::Basename qw(dirname);
use YAML::XS       qw(LoadFile);
use Log::Log4perl  qw(:easy);

my $work_dir = dirname( __FILE__ );

warn 'work_dir = ' . Dumper( $work_dir );

my $conf = LoadFile( $work_dir . '/script_settings.yml' );
$conf->{ hosters_asn_path }  = $work_dir . '/db/hosters_asn.yml';                                                  # путь к файлу с описанием хостера и его ASN
$conf->{ hosters_asn }       = LoadFile( $conf->{ hosters_asn_path } );                                            # список хостеров и их ASN
$conf->{ asn }               = $conf->{ hosters_asn }->{ $conf->{ hoster_name } };                                 # ASN номер хостера
$conf->{ log_file }          = sprintf( $work_dir . "/log/%s\_best_hoster_location.log", $conf->{ hoster_name } ); # путь к файлу логов
$conf->{ country_list_file } = $work_dir . '/db/contry_code.yml';                                                  # путь к asn файлу
$conf->{ result_save_path }  = $work_dir . "/result/%s\_$conf->{hoster_name}.json";                                # путь к файлу результатов
$conf->{ hoster_asn_file }   = sprintf( $work_dir . "/info_by_asn/%s.json", $conf->{ asn } );                      # путь к файлу результатов
$conf->{ country_list }      = LoadFile( $conf->{ country_list_file } );
Log::Log4perl->easy_init(
    {
        file   => ">>  $conf->{ log_file }",
        layout => '[%p] %d - %R %m%n'
    }
);

INFO( 'conf = ' . Dumper( $conf ) );
INFO( '= = = = = START = = = = =' );
my $hoster_info = read_asn_file( $conf->{ hoster_asn_file } );

foreach my $country ( keys %$hoster_info ) {
    foreach my $info ( @{ $hoster_info->{ $country }->{ info } } ) {
        my $ips = get_ips_array( $info->{ netblock } );

        foreach my $ip ( @$ips ) {
            INFO( "$info->{ country }::ip = $ip" );
            my @pings = get_ping( $ip );
            push( @{ $hoster_info->{ $country }->{ pings } }, @pings );
            my $avg_ping = calculate_avg_ping( \@pings );
            if ( defined $avg_ping && !defined $hoster_info->{ $country }->{ hops } && $avg_ping <= $conf->{ max_ping } ) {
                $hoster_info->{ $country }->{ hops } = traceroute( $ip );
            }
        }
    }
    delete $hoster_info->{ $country }->{ info };
    $hoster_info->{ $country }->{ avg_ping } = calculate_avg_ping( $hoster_info->{ $country }->{ pings } );
    $country = $conf->{ country_list }->{ $country };
}

print_to_file( sprintf( $conf->{ result_save_path }, 'FULL' ), $hoster_info );

foreach my $country ( keys %$hoster_info ) {
    delete $hoster_info->{ $country }->{ pings };
    if ( !defined $hoster_info->{ $country }->{ avg_ping } ) {
        delete $hoster_info->{ $country };
        next;
    }
    delete $hoster_info->{ $country } if ( $hoster_info->{ $country }->{ avg_ping } > $conf->{ max_ping } );
}

print_to_file( sprintf( $conf->{ result_save_path }, 'BEST' ), $hoster_info );

INFO( ' = = = = = FINISH = = = = =' );

exit;

sub get_ping {
    my $ip = shift;

    my @ping_results;

    foreach ( 1 .. $conf->{ number_pings_to_one_ip } ) {
        my ( $got_response, $ping ) = Net::Ping->new()->ping( $ip );
        sleep( 0.5 );
        if ( $got_response ) {
            push( @ping_results, sprintf( "%.3f", $ping * 1000 ) );
        } else {
            push( @ping_results, undef );
        }
    }

    INFO( 'ping_results = ' . Dumper( \@ping_results ) );

    return @ping_results;
}

sub traceroute {
    my $ip = shift;

    my $hops         = undef;
    my $trace_result = `traceroute $ip`;
    my @trace_rows   = split( /\n/, $trace_result );
    $hops = $1 if ( $trace_rows[ $#trace_rows ] =~ m/^\s*(\d{1,2})\s{2}.*$/g );

    INFO( "traceroute hops = " . Dumper( $hops ) );
    return $hops;
}

sub get_ips_array {
    my $netblock = shift;

    my @ips;
    my $result;

    my $ip_obj = Net::IP->new( $netblock );
    push @ips, $ip_obj->ip() while ( ++$ip_obj );

    foreach ( 1 .. $conf->{ number_ip_poll } ) {
        push( @$result, $ips[ int rand scalar @ips ] );
    }

    return $result;
}

sub print_to_file {
    my $file   = shift;
    my $result = shift;

    unlink( $file );
    my $filehandle = IO::File->new( ">> $file" );

    if ( defined $filehandle ) {
        print $filehandle encode_json( $result ) . "\n";
    }
    $filehandle->close;
}

sub read_asn_file {
    my $file = shift;

    my $info_by_asn;
    my $fh = IO::File->new();
    if ( $fh->open( "< $file" ) ) {
        $info_by_asn .= $_ while ( <$fh> );
    }
    $fh->close;

    my $grouped_by_country;
    my $hash = decode_json( $info_by_asn );

    foreach my $info ( @{ $hash->{ prefixes } } ) {
        push( @{ $grouped_by_country->{ $info->{ country } }->{ info } }, $info );
    }

    return $grouped_by_country;
}

sub calculate_avg_ping {
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
