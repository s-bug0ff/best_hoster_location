package lib::file;

use strict;
use warnings;
no warnings "uninitialized";

use Data::Dumper qw(Dumper);
use YAML::XS     qw(LoadFile);
use JSON::XS     qw(decode_json);
use IO::File;

sub new {
    my $class = shift;
    my $self  = shift;

    $class = ref $class if ref $class;
    bless $self, $class;

    return $self;
}

sub load_yaml {
    my $self = shift;
    my $file = shift;

    return LoadFile( $file );
}

sub read_file {
    my $self   = shift;
    my $params = shift;

    my $content;

    my $filehandle = IO::File->new();
    if ( $filehandle->open( "< $params->{ file_path }" ) ) {
        $content .= $_ while ( <$filehandle> );
    }
    $filehandle->close;

    $content = $self->json_decode( $content ) if ( $params->{ need_decode } );

    return $content;
}

sub write_to_file {
    my $self   = shift;
    my $params = shift;

    $params->{ content } = $self->json_encode( { content => $params->{ content }, pretty => $params->{ pretty } } )
        if ( $params->{ need_encode } );

    unlink( $params->{ file_path } );
    my $filehandle = IO::File->new( ">> $params->{ file_path }" );
    if ( defined $filehandle ) {
        print $filehandle $params->{ content };
    }
    $filehandle->close;
}

sub json_decode {
    my $self    = shift;
    my $content = shift;

    my $decoded_content;
    eval { $decoded_content = decode_json( $content ) };
    if ( $@ ) {
        $self->{ log }->warning( "can't decode JSON, return as is" );
        return $content;
    }

    return $decoded_content;
}

sub json_encode {
    my $self   = shift;
    my $params = shift;

    my $json_obj = JSON::XS->new();

    $json_obj->pretty( 1 ) if ( $params->{ pretty } );

    my $encoded_content = eval { $json_obj->encode( $params->{ content } ) };
    if ( $@ ) {
        $self->{ log }->warning( "can't encode JSON, return as is" );
        $self->{ log }->debug( Dumper( $@ ) );
        return $params->{ content };
    }

    return $encoded_content;
}

1;
