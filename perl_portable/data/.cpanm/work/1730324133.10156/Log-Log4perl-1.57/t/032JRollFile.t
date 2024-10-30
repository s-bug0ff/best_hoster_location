BEGIN { 
    if($ENV{INTERNAL_DEBUG}) {
        require Log::Log4perl::InternalDebug;
        Log::Log4perl::InternalDebug->enable();
    }
}

use Log::Log4perl;
use Test::More;
use File::Spec;
use lib File::Spec->catdir(qw(t lib));
use Log4perlInternalTest qw(tmpdir);

eval {
    require Log::Dispatch::FileRotate;
    Log::Dispatch::FileRotate->VERSION(1.10); 1
} or plan skip_all => "only with Log::Dispatch::FileRotate 1.10";

my $WORK_DIR = tmpdir();

my $conf = <<CONF;
log4j.category.cat1      = INFO, myAppender

log4j.appender.myAppender=org.apache.log4j.RollingFileAppender
log4j.appender.myAppender.File=@{[File::Spec->catfile($WORK_DIR, 'rolltest.log')]}
#this will roll the file after one write
log4j.appender.myAppender.MaxFileSize=1024
log4j.appender.myAppender.MaxBackupIndex=2
log4j.appender.myAppender.layout=org.apache.log4j.PatternLayout
log4j.appender.myAppender.layout.ConversionPattern=%-5p %c - %m%n

CONF

Log::Log4perl->init(\$conf);

my $logger = Log::Log4perl->get_logger('cat1');

$logger->debug("x" x 1024 . "debugging message 1 ");
$logger->info("x" x 1024  . "info message 1 ");      
$logger->warn("x" x 1024  . "warning message 1 ");   
$logger->fatal("x" x 1024 . "fatal message 1 ");   

my $rollfile = File::Spec->catfile($WORK_DIR, 'rolltest.log.2');

open F, $rollfile or die "Cannot open $rollfile";
my $result = <F>;
close F;
like($result, qr/^INFO  cat1 - x+info message 1/);

#MaxBackupIndex is 2, so this file shouldn't exist
ok(! -e File::Spec->catfile($WORK_DIR, 'rolltest.log.3'));

reset_logger();
done_testing;

sub reset_logger {
  local $Log::Log4perl::Config::CONFIG_INTEGRITY_CHECK = 0; # to close handles and allow temp files to go
  Log::Log4perl::init(\'');
}
