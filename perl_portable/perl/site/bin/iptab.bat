@rem = '--*-Perl-*--
@set "ErrorLevel="
@if "%OS%" == "Windows_NT" @goto WinNT
@perl -x -S "%0" %1 %2 %3 %4 %5 %6 %7 %8 %9
@set ErrorLevel=%ErrorLevel%
@goto endofperl
:WinNT
@perl -x -S %0 %*
@set ErrorLevel=%ErrorLevel%
@if NOT "%COMSPEC%" == "%SystemRoot%\system32\cmd.exe" @goto endofperl
@if %ErrorLevel% == 9009 @echo You do not have Perl in your PATH.
@goto endofperl
@rem ';
#!perl
#line 16

use Net::IP;
use strict;

print "+----------------------------------------------+
| addrs   bits   pref   class  mask            |
+----------------------------------------------+
";

my ($ip,$size,$class,$bits,$len);

my $ip = new Net::IP('0');

for my $len (reverse (0..32))
{

	$ip->set("0.0.0.0/$len");

	$size = $ip->size();
	
	if ($size >=1048576) # 1024*1024
	{
		$size /= 1048576;
		$size .= 'M';
	}
	elsif ($size >= 1024)
	{
		$size /= 1024;
		$size .= 'K';
	};		
	
	$len = $ip->prefixlen();
	$bits = 32 - $len;
	
	if ($bits >= 24)
	{
		$class = 2**($bits-24);
		$class.= 'A';
	}
	elsif ($bits >= 16)
	{
		$class = 2**($bits-16);
		$class.= 'B';
	}	
	elsif ($bits >= 8)
	{
		$class = 2**($bits-8);
		$class.= 'C';
	}	

	printf ("| %5s %6s %6s %7s  %-15s |\n",
		$size,$bits,'/'.$len,$class,$ip->mask());
	

};

print "+----------------------------------------------+\n";
__END__
:endofperl
@set "ErrorLevel=" & @goto _undefined_label_ 2>NUL || @"%COMSPEC%" /d/c @exit %ErrorLevel%
