/* NTPWiFi232 @paulrickards 2023-Apr-02 */

/* Use a WiFi232 serial modem or Hayes Chronograph to fetch
   the current NTP time and set the clock. */

IF (~OPEN( 'serial', 'SER:UNIT=0/BAUD=9600/FLOW=HARD', 'RW' )) THEN DO
    SAY('Could not fetch NTP time: failed to open serial port.')
    EXIT 0
END
WRITELN( 'serial', 'ATRD' )

line = ''
prevline = ''
running = 1

DO WHILE ( running )
    if (EOF('serial')) THEN running = 0
    ELSE char = READCH('serial')
    line = line || char
    if (LEFT(line, 2) = 'OK') THEN running = 0
    if (C2D(char)=10) THEN DO
        prevline = STRIP( line, 'T', D2C(10))
        line = ''
    END
END

CLOSE( 'serial' )

year  = SUBSTR(prevline, 1, 2)
month = SUBSTR(prevline, 4, 2)
day   = SUBSTR(prevline, 7, 2)

hour  = SUBSTR(prevline, 10, 2)
min   = SUBSTR(prevline, 13, 2)
sec   = SUBSTR(prevline, 16, 2)

/* Time is returned in UTC. Timezone should be applied here. */
/* NB: more to do here.. */
offset = -4
hour = hour + offset

SELECT
    WHEN month='01' THEN monthtxt='Jan'
    WHEN month='02' THEN monthtxt='Feb'
    WHEN month='03' THEN monthtxt='Mar'
    WHEN month='04' THEN monthtxt='Apr'
    WHEN month='05' THEN monthtxt='May'
    WHEN month='06' THEN monthtxt='Jun'
    WHEN month='07' THEN monthtxt='Jul'
    WHEN month='08' THEN monthtxt='Aug'
    WHEN month='09' THEN monthtxt='Sep'
    WHEN month='10' THEN monthtxt='Oct'
    WHEN month='11' THEN monthtxt='Nov'
    WHEN month='12' THEN monthtxt='Dec'
    OTHERWISE DO
      SAY('Error fetching NTP time.')
      EXIT
      END
    END

args = day'-'monthtxt'-'year' 'hour':'min':'sec
SAY('Setting time to NTP source: 'args)

ADDRESS COMMAND 'date' args
ADDRESS COMMAND 'setclock save'
