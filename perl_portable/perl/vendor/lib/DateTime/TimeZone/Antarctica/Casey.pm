# This file is auto-generated by the Perl DateTime Suite time zone
# code generator (0.08) This code generator comes with the
# DateTime::TimeZone module distribution in the tools/ directory

#
# Generated from /tmp/S2_G3OrWui/antarctica.  Olson data version 2024a
#
# Do not edit this file directly.
#
package DateTime::TimeZone::Antarctica::Casey;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '2.62';

use Class::Singleton 1.03;
use DateTime::TimeZone;
use DateTime::TimeZone::OlsonDB;

@DateTime::TimeZone::Antarctica::Casey::ISA = ( 'Class::Singleton', 'DateTime::TimeZone' );

my $spans =
[
    [
DateTime::TimeZone::NEG_INFINITY, #    utc_start
62104147200, #      utc_end 1969-01-01 00:00:00 (Wed)
DateTime::TimeZone::NEG_INFINITY, #  local_start
62104147200, #    local_end 1969-01-01 00:00:00 (Wed)
0,
0,
'-00',
    ],
    [
62104147200, #    utc_start 1969-01-01 00:00:00 (Wed)
63391485600, #      utc_end 2009-10-17 18:00:00 (Sat)
62104176000, #  local_start 1969-01-01 08:00:00 (Wed)
63391514400, #    local_end 2009-10-18 02:00:00 (Sun)
28800,
0,
'+08',
    ],
    [
63391485600, #    utc_start 2009-10-17 18:00:00 (Sat)
63403398000, #      utc_end 2010-03-04 15:00:00 (Thu)
63391525200, #  local_start 2009-10-18 05:00:00 (Sun)
63403437600, #    local_end 2010-03-05 02:00:00 (Fri)
39600,
0,
'+11',
    ],
    [
63403398000, #    utc_start 2010-03-04 15:00:00 (Thu)
63455421600, #      utc_end 2011-10-27 18:00:00 (Thu)
63403426800, #  local_start 2010-03-04 23:00:00 (Thu)
63455450400, #    local_end 2011-10-28 02:00:00 (Fri)
28800,
0,
'+08',
    ],
    [
63455421600, #    utc_start 2011-10-27 18:00:00 (Thu)
63465526800, #      utc_end 2012-02-21 17:00:00 (Tue)
63455461200, #  local_start 2011-10-28 05:00:00 (Fri)
63465566400, #    local_end 2012-02-22 04:00:00 (Wed)
39600,
0,
'+11',
    ],
    [
63465526800, #    utc_start 2012-02-21 17:00:00 (Tue)
63612748800, #      utc_end 2016-10-21 16:00:00 (Fri)
63465555600, #  local_start 2012-02-22 01:00:00 (Wed)
63612777600, #    local_end 2016-10-22 00:00:00 (Sat)
28800,
0,
'+08',
    ],
    [
63612748800, #    utc_start 2016-10-21 16:00:00 (Fri)
63656384400, #      utc_end 2018-03-10 17:00:00 (Sat)
63612788400, #  local_start 2016-10-22 03:00:00 (Sat)
63656424000, #    local_end 2018-03-11 04:00:00 (Sun)
39600,
0,
'+11',
    ],
    [
63656384400, #    utc_start 2018-03-10 17:00:00 (Sat)
63674539200, #      utc_end 2018-10-06 20:00:00 (Sat)
63656413200, #  local_start 2018-03-11 01:00:00 (Sun)
63674568000, #    local_end 2018-10-07 04:00:00 (Sun)
28800,
0,
'+08',
    ],
    [
63674539200, #    utc_start 2018-10-06 20:00:00 (Sat)
63688435200, #      utc_end 2019-03-16 16:00:00 (Sat)
63674578800, #  local_start 2018-10-07 07:00:00 (Sun)
63688474800, #    local_end 2019-03-17 03:00:00 (Sun)
39600,
0,
'+11',
    ],
    [
63688435200, #    utc_start 2019-03-16 16:00:00 (Sat)
63705812400, #      utc_end 2019-10-03 19:00:00 (Thu)
63688464000, #  local_start 2019-03-17 00:00:00 (Sun)
63705841200, #    local_end 2019-10-04 03:00:00 (Fri)
28800,
0,
'+08',
    ],
    [
63705812400, #    utc_start 2019-10-03 19:00:00 (Thu)
63719280000, #      utc_end 2020-03-07 16:00:00 (Sat)
63705852000, #  local_start 2019-10-04 06:00:00 (Fri)
63719319600, #    local_end 2020-03-08 03:00:00 (Sun)
39600,
0,
'+11',
    ],
    [
63719280000, #    utc_start 2020-03-07 16:00:00 (Sat)
63737424060, #      utc_end 2020-10-03 16:01:00 (Sat)
63719308800, #  local_start 2020-03-08 00:00:00 (Sun)
63737452860, #    local_end 2020-10-04 00:01:00 (Sun)
28800,
0,
'+08',
    ],
    [
63737424060, #    utc_start 2020-10-03 16:01:00 (Sat)
63751323600, #      utc_end 2021-03-13 13:00:00 (Sat)
63737463660, #  local_start 2020-10-04 03:01:00 (Sun)
63751363200, #    local_end 2021-03-14 00:00:00 (Sun)
39600,
0,
'+11',
    ],
    [
63751323600, #    utc_start 2021-03-13 13:00:00 (Sat)
63768873660, #      utc_end 2021-10-02 16:01:00 (Sat)
63751352400, #  local_start 2021-03-13 21:00:00 (Sat)
63768902460, #    local_end 2021-10-03 00:01:00 (Sun)
28800,
0,
'+08',
    ],
    [
63768873660, #    utc_start 2021-10-02 16:01:00 (Sat)
63782773200, #      utc_end 2022-03-12 13:00:00 (Sat)
63768913260, #  local_start 2021-10-03 03:01:00 (Sun)
63782812800, #    local_end 2022-03-13 00:00:00 (Sun)
39600,
0,
'+11',
    ],
    [
63782773200, #    utc_start 2022-03-12 13:00:00 (Sat)
63800323260, #      utc_end 2022-10-01 16:01:00 (Sat)
63782802000, #  local_start 2022-03-12 21:00:00 (Sat)
63800352060, #    local_end 2022-10-02 00:01:00 (Sun)
28800,
0,
'+08',
    ],
    [
63800323260, #    utc_start 2022-10-01 16:01:00 (Sat)
63813974400, #      utc_end 2023-03-08 16:00:00 (Wed)
63800362860, #  local_start 2022-10-02 03:01:00 (Sun)
63814014000, #    local_end 2023-03-09 03:00:00 (Thu)
39600,
0,
'+11',
    ],
    [
63813974400, #    utc_start 2023-03-08 16:00:00 (Wed)
DateTime::TimeZone::INFINITY, #      utc_end
63814003200, #  local_start 2023-03-09 00:00:00 (Thu)
DateTime::TimeZone::INFINITY, #    local_end
28800,
0,
'+08',
    ],
];

sub olson_version {'2024a'}

sub has_dst_changes {0}

sub _max_year {2034}

sub _new_instance {
    return shift->_init( @_, spans => $spans );
}



1;
