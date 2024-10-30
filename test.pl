use Data::Dumper;

my $osname = 'MSWin32';
traceroute('91.103.140.176');




sub traceroute {
    my $ip   = shift;

    my $hops = undef;
    my $trace_cmd;

    if ( $osname eq 'MSWin32' ) {
        $trace_cmd = "tracert $ip";
    } else {
        $trace_cmd = "traceroute -I $ip";
    }
    my $trace_result = `$trace_cmd`;
    my @trace_rows   = split( /\n/, $trace_result );
    @trace_rows = grep { /^\s*\d{1,}\s*/ } @trace_rows;

    warn 'trace_result = ' . $trace_result;
    $hops = $1 if ( $trace_rows[ $#trace_rows ] =~ m/^\s*(\d{1,2})\s{2}.*$/g );

    warn 'hops = ' . $hops;
    return $hops;
}