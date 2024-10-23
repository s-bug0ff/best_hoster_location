package lib::conf;

use strict;
use warnings;
no warnings "uninitialized";

use lib qw(.);
use lib::file;

use Data::Dumper   qw(Dumper);
use File::Basename qw(dirname);
use Cwd            qw(abs_path);

sub new {
    my $class = shift;
    my $self  = _init_conf();

    $class = ref $class if ref $class;
    bless $self, $class;

    return $self;
}

sub _init_conf {
    my $conf;

    $conf->{ work_dir }             = dirname( abs_path( $0 ) );
    $conf->{ script_settings_path } = sprintf( '%s/script_settings.yml', $conf->{ work_dir } ); # путь к файлу настроек
    $conf->{ hosters_asn_path }     = sprintf( '%s/db/hosters_asn.yml',  $conf->{ work_dir } ); # путь к файлу списока хостеров и их ASN
    $conf->{ script_settings }      = lib::file->new( $conf )->load_yaml( $conf->{ script_settings_path } );
    $conf->{ hosters_asn }          = lib::file->new( $conf )->load_yaml( $conf->{ hosters_asn_path } );
    $conf->{ asn_file_url }         = sprintf( 'https://ipinfo.io/widget/demo/%s?dataset=asn',
        $conf->{ hosters_asn }->{ $conf->{ script_settings }->{ hoster_name } } );
    $conf->{ asn_file_path } = sprintf(
        '%s/info_by_asn/%s.json',
        $conf->{ work_dir },
        $conf->{ hosters_asn }->{ $conf->{ script_settings }->{ hoster_name } }
    );
    $conf->{ log_path }
        = sprintf( '%s/log/%s_best_hoster_location.log', $conf->{ work_dir }, $conf->{ script_settings }->{ hoster_name } );

    $conf->{ full_result_save_path }
        = sprintf( '%s/result/FULL_%s.json', $conf->{ work_dir }, $conf->{ script_settings }->{ hoster_name } );
    $conf->{ best_result_save_path }
        = sprintf( '%s/result/BEST_%s.json', $conf->{ work_dir }, $conf->{ script_settings }->{ hoster_name } );

    return $conf;
}

1;
