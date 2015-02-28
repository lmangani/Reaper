The SIP Voice Quality Report Reaper sniffs RTCP and RTP packets and generates
SIP PUBLISH messages with voice quality reports.  It does this in accordance
with the following RFC:

http://www.rfc-editor.org/rfc/rfc6035.txt

The tool is designed to sniff packets on a network and generate voice quality
reports most likely to another network.  The advantage of using the mode where
RTP packets are sniffed is most devices don't support voice quality reports
and the Reaper can be used to analyze a segment of the network so that
fingers can be pointed.

```
------(*)-------(*)-------[net]
       |         ^
       V         |
   [tcmpdump]    |
       |       [PUBLISH]
   [-reaper-]    |
 [SIP|RTP|RTCP]  |
   |   |    |    |
   L___|____|____|
       V    ^    
  [leg-correlation]
  ```
  
There is a shell script to generate an installable deb file and it has been
tested on some Ubuntu distros.

In order to work properly, the RTP voice packets and the SIP signalling packets
must be on the same network.

The tool is written in Java with some C code to customize tcpdump so that it
can be used as a Berkeley Packet Filter for the Reaper.


To manually build Reaper from command line use:
```
# ./rebuild.sh
```

To build using ant:
```
# ant all
```

A ``build.sh`` shell script is provided to generate an installable debian package: 

```
# dpkg -i reaper.deb
```
After you install the package, you'll need to edit the configuration in ``/opt/reaper/config/reaper.properties``

 1. Set readInterface to the interface you want to monitor. e.g. eth0
 2. Set writeIp to the IP for the NIC to write to the Collector
 3. Set CollectorIp to the Collector IP
 4. Set CollectorPort to the Collector port if they aren't using 5060
 5. Set the collectorUsername if the Collector cares what that is.

After that, restart the reaper:
```
# /etc/init.d/reaper restart
```
Filtered packets get a one line print in ``/opt/reaper/log/bpf.err`` 

Call state prints in ``/opt/reaper/log/out`` 

A very pimitive and simple web server is available on ``http://127.0.0.1:8060/`` on the
probe where you can see active calls and some current call stats
