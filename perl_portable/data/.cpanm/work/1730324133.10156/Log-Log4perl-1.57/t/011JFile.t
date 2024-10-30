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

our $LOG_DISPATCH_PRESENT = 0;

BEGIN { 
    eval { require Log::Dispatch; };
    if($@) {
       plan skip_all => "only with Log::Dispatch";
    } else {
       $LOG_DISPATCH_PRESENT = 1;
       plan tests => 1;
    }
};

my $WORK_DIR = tmpdir();
my $test_logfile = File::Spec->catfile($WORK_DIR, 'test2.log');

my $conf = <<CONF;
log4j.category.cat1      = INFO, myAppender

log4j.appender.myAppender=org.apache.log4j.FileAppender
log4j.appender.myAppender.File=$test_logfile
log4j.appender.myAppender.layout=org.apache.log4j.PatternLayout
log4j.appender.myAppender.layout.ConversionPattern=%-5p %c - %m%n
CONF

Log::Log4perl->init(\$conf);

my $logger = Log::Log4perl->get_logger('cat1');

$logger->debug("debugging message 1 ");
$logger->info("info message 1 ");      
$logger->warn("warning message 1 ");   
$logger->fatal("fatal message 1 ");   


my ($result, $expected);

$expected = <<EOL;
INFO  cat1 - info message 1 
WARN  cat1 - warning message 1 
FATAL cat1 - fatal message 1 
EOL

{local $/ = undef;
 open (F, "$test_logfile") || die $!;
 $result = <F>;
 close F;
}
is ($result, $expected);

reset_logger();
done_testing;

sub reset_logger {
  local $Log::Log4perl::Config::CONFIG_INTEGRITY_CHECK = 0; # to close handles and allow temp files to go
  Log::Log4perl::init(\'');
}
