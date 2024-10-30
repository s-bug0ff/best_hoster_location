use strict;
use warnings;
no warnings "uninitialized";

use lib qw(.);
use lib::conf;
use lib::logger;
use lib::net;
use lib::file;
use lib::downloader;
use lib::util;

use Data::Dumper qw(Dumper);

my $conf    = lib::conf->new();
my $objects = init_obj( $conf );

$objects->{ log }->info( '= = = = = START = = = = =' );
$objects->{ log }->debug( Dumper( $conf ) );

$objects->{ downloader }->download_asn_file() if ( $conf->{ script_settings }->{ try_update_asn_file } );

my $hoster_info = $objects->{ util }->group_asn_by_country(
    $objects->{ file }->read_file( { file_path => $conf->{ asn_file_path }, need_decode => 1 } ) );

foreach my $country ( keys %$hoster_info ) {
    foreach my $info ( @{ $hoster_info->{ $country }->{ info } } ) {
        my $ips
            = $objects->{ util }->get_random_ip_pool( $objects->{ net }->get_all_all_ip_by_netblock( $info->{ netblock } ) );

        foreach my $ip ( @$ips ) {
            my $avg_ping = $objects->{ net }->ping( $ip );
            push( @{ $hoster_info->{ $country }->{ pings } }, $avg_ping );
            if ( defined $avg_ping ) {
                if ( !defined $hoster_info->{ $country }->{ hops } && $avg_ping <= $conf->{ script_settings }->{ max_avg_ping } ) {
                    $hoster_info->{ $country }->{ hops } = $objects->{ net }->traceroute( $ip );
                }
            }
            $objects->{ log }->info( "[$country]ip = $ip; avg_ping ~ $avg_ping; hops ~ $hoster_info->{ $country }->{ hops }" );
        }
    }
    delete $hoster_info->{ $country }->{ info };
    $hoster_info->{ $country }->{ avg_ping }
        = $objects->{ util }->calculate_avg_ping( $hoster_info->{ $country }->{ pings } );
}

$objects->{ file }->write_to_file(
    { file_path => $conf->{ full_result_save_path }, content => $hoster_info, need_encode => 1, pretty => 1 } );

foreach my $country ( keys %$hoster_info ) {
    delete $hoster_info->{ $country }->{ pings };
    if ( !defined $hoster_info->{ $country }->{ avg_ping } ) {
        delete $hoster_info->{ $country };
        next;
    }
    delete $hoster_info->{ $country }
        if ( $hoster_info->{ $country }->{ avg_ping } > $conf->{ script_settings }->{ max_avg_ping } );
}

$objects->{ file }->write_to_file(
    { file_path => $conf->{ best_result_save_path }, content => $hoster_info, need_encode => 1, pretty => 1 } );

$objects->{ log }->info( ' = = = = = FINISH = = = = =' );

exit;

sub init_obj {
    my $conf = shift;

    my $logger_obj
        = lib::logger->new( { debug => $conf->{ script_settings }->{ debug }, log_path => $conf->{ log_path } } );

    my $util_obj = lib::util->new(
        { number_ip_poll => $conf->{ script_settings }->{ number_pings_to_one_ip }, log => $logger_obj } );

    my $net_obj = lib::net->new(
        {
            number_pings_to_one_ip => $conf->{ script_settings }->{ number_pings_to_one_ip },
            log                    => $logger_obj,
            util                   => $util_obj,
            osname                 => $conf->{ osname }
        }
    );

    my $file_obj = lib::file->new( { log => $logger_obj, util => $util_obj } );

    my $downloader_obj = undef;
    if ( $conf->{ script_settings }->{ try_update_asn_file } ) {
        $downloader_obj = lib::downloader->new(
            {
                asn_file_path => $conf->{ asn_file_path },
                asn_file_url  => $conf->{ asn_file_url },
                file          => $file_obj,
                log           => $logger_obj,
                util          => $util_obj,
            }
        );
    }

    return {
        log        => $logger_obj,
        util       => $util_obj,
        net        => $net_obj,
        file       => $file_obj,
        downloader => $downloader_obj
    };
}
