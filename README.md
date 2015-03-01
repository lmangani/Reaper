```
 __   __           ___      ___            ___                     _ __                  
 \ \ / /   ___    |_ _|    | _ \   ___    | _ \    ___    __ _    | __ \   ___     _ _  
  \ V /   / _ \    | |     |  _/  |___|   |   /   / -_)  / _` |   | :__/  / -_)   | '_| 
  _\_/_   \___/   |___|   _|_|_   _____   |_|_\   \___|  \__,_|   |_|     \___|   |_| \  
_| """"|_|"""""|_|"""""|_| """ |_|     |_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""| 
"`-0-0-'"`-1-0-'"`-0-1-'"`-0-0-'"`-0-0-'"`-0-1-'"`-1-1-'"`-1-0-'"`-0-1-'"`-0-1-'"`-0-0-' 
```

The SIP Voice Quality Report Reaper sniffs RTCP and RTP packets and generates SIP PUBLISH messages with voice quality reports in accordance with [RFC6035](http://www.rfc-editor.org/rfc/rfc6035.txt)

The tool is designed to sniff SIP/RTP/RTCP packets on a network and generate correlated voice quality reports.  


```
------(*)-------(*)-------[net]
       |         ^
       V         |
   [tcmpdump]    |
       |       [PUBLISH]
   [-reaper-]    |
 [SIP|RTP|RTCP]  |
   |   |    |    |
   |   |____|____|
   V   ^    ^
  [leg-correlation]
  ```
  
In order to work properly, both RTP/RTCP voice packets and SIP signalling packets *MUST* be sniffed.

The tool is written in Java with some C code to customize tcpdump so that it can be used as a Berkeley Packet Filter for the Reaper.


To manually build Reaper from command line use:
```
# ./rebuild.sh
```

To build using ant:
```
# ant all
```

A shell script is provided to generate an installable debian package: 

```
# build.sh
# dpkg -i reaper.deb
```
After you install the package, you'll need to edit the configuration in ``/opt/reaper/config/reaper.properties``

 1. Set readInterface to the interface you want to monitor. *(e.g. eth0)*
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
