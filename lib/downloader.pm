package lib::downloader;

use strict;
use warnings;
no warnings "uninitialized";

use LWP::Simple;
use Data::Dumper qw(Dumper);

sub new {
    my $class = shift;
    my $self  = shift;

    $class = ref $class if ref $class;
    bless $self, $class;

    return $self;
}

sub download_asn_file {
    my $self = shift;

    my $content = get( $self->{ asn_file_url } );

    if ( defined $content ) {
        $self->{ log }->info( 'info_by_asn file successfully updated' );
        $self->{ file }->write_to_file( { file_path => $self->{ asn_file_path }, content => $content } );
    }
    $self->{ log }->info( 'info_by_asn file not updated' );
}

1;
