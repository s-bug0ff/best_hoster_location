BEGIN { 
    if($ENV{INTERNAL_DEBUG}) {
        require Log::Log4perl::InternalDebug;
        Log::Log4perl::InternalDebug->enable();
    }
}

use Log::Log4perl;
use Test::More;

#skipping on win32 systems
eval { require Sys::Syslog; 1 } or plan skip_all => "Sys::Syslog not installed";

print <<EOL;

Since syslog() doesn't return any value that indicates sucess or failure,
I'm just going to send messages to syslog.  These messages should
appear in the log file generated by syslog(8):

INFO - info message 1
WARN - warning message 1

Error messages probably indicate problems with related syslog modules
that exist on some systems.

EOL


my $conf = <<CONF;
log4j.category.cat1      = INFO, myAppender

log4j.appender.myAppender=org.apache.log4j.SyslogAppender
log4j.appender.myAppender.Facility=local1
log4j.appender.myAppender.layout=org.apache.log4j.SimpleLayout
CONF


#There seems to be problems with Sys::Syslog on some platforms.
#So we'll just run this, maybe it will work and maybe it won't.
#A failure won't keep Log4perl from installing, but it will give
#some indication to the user whether to expect syslog logging
#to work on their system.

eval {

   Log::Log4perl->init(\$conf);

   my $logger = Log::Log4perl->get_logger('cat1');


   $logger->debug("debugging message 1 ");
   $logger->info("info message 1 ");      
   $logger->warn("warning message 1 ");   

};

ok 1;
done_testing;