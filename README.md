# amiga-wifi232-ntp
Set the Amiga clock by using a WiFi232 serial modem.
Tested on an Amiga CDTV running Workbench 1.3 with a SCSI card and a BlueSCSI v1.
## Requirements
Requires ARexx. [I used version 1.15 available from Archive.org.](https://archive.org/download/CommodoreAmigaApplicationsADF/ARexx%20v1.15%20%281990%29%28Hawes%2C%20William%29%5BWB%5D.zip)
## Usage
From AmigaDOS, issue the command:
```
rx ntpwifi232.rexx
```
## Todo
There's very little error checking being done. If you put this in a startup sequence without a modem attached, it will likely hang your system. There's also more work to be done for converting the UTC time to a local timezone.
