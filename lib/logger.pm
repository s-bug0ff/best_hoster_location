package lib::logger;

use strict;
use warnings;
no warnings "uninitialized";

use Data::Dumper  qw(Dumper);
use Log::Log4perl qw(:easy);

sub new {
    my $class = shift;
    my $self  = shift;

    $class = ref $class if ref $class;
    bless $self, $class;

    Log::Log4perl->easy_init(
        {
            file   => ">>  $self->{ log_path }",
            layout => '[%p] %d - %Rms %m%n'
        }
    );

    return $self;
}

sub error {
    my $self = shift;
    my $msg  = shift;

    ERROR( $msg );
}

sub info {
    my $self = shift;
    my $msg  = shift;

    INFO( $msg );
}

sub debug {
    my $self = shift;
    my $msg  = shift;

    DEBUG( $msg ) if $self->{ debug };
}

sub warning {
    my $self = shift;
    my $msg  = shift;

    WARN( $msg );
}

sub fatal {
    my $self = shift;
    my $msg  = shift;

    FATAL( $msg );
}

1;
