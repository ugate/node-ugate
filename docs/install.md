## BOM (Bill of Materials)
### Hardware
|               | Description   | QTY           | ~USD |
| ------------- | ------------- | ------------- | ------------- | 
| 1.            | [C.H.I.P.](http://getchip.com)  | 1 | $9 + shipping |
## Pre-Installation
1. [Flash C.H.I.P.](http://flash.getchip.com) to the latest version (use `uname -a` from the _Terminal_ to check your current version) and execute an `sudo apt-get update` and `sudo apt-get upgrade` before proceeding.
* Connect C.H.I.P. to your existing WiFi network using `Computer Things! > Settings > Network Connections` or the :signal_strength: icon in the upper right corner of screen.
* Follow the steps outlined on NTC's blog for [Secure-A-C.H.I.P](http://blog.nextthing.co/secure-a-chip) (including changing the suggested _root_ password using `sudo passwd root`). Make sure you note the host name you change your C.H.I.P. to. Proceeding references in this guide will assume the host name will be *ugate* although it can be something else.
* (Optional) If you'd like to access your system from outside your local network you'll need to setup your network to allow `HTTPS` traffic through to your C.H.I.P. The following instructions are for [OpenWRT](https://openwrt.org/) with [Luci](https://wiki.openwrt.org/doc/techref/luci), but they should be similar in other routers as well. 
  1. Under your local OpenWRT navigate to `Network > DHCP and DNS > Static Leases` assign a new static IP address to your C.H.I.P. MAC address (use `ip addr` to identify). The host name should match the host name used on your C.H.I.P.
  * Under `Network > Firewall > Port Forwards` add a new _TCP+UDP_ entry from _WAN_ to _LAN_ on port _443_ that points to the static IP that was setup in the previous step.
  * From C.H.I.P. download [the most current version of Node.js for ARMv7](https://nodejs.org/en/download/current/). NOTE: Clicking on the download button on Node's website from CH.I.P. may download an incompatible version. Also, using `sudo apt-get install nodejs` may download an older version than what's available.
  * Execute the following command to install node/npm in `/usr/local/node` and `/usr/local/npm` (replacing X.X.X with the version that was downloaded): `tar -C /usr/local --strip-components 1 -xJf /home/chip/Downloads/node-vX.X.X-linux-armv7l.tar.xz`
* (Optional) `ssh` is enabled on C.H.I.P. by default, but another great option is to install a [VNC server](https://en.wikipedia.org/wiki/Virtual_Network_Computing) so you have remote access to the C.H.I.P. GUI. [TightVNC](http://www.tightvnc.com/) seems to be a popular VNC client/server. To install the server on C.H.I.P. 
  1. From the _Terminal_ enter `sudo apt-get install tightvncserver`.
  * Run the server by entering `tightvncserver` (asks for a password and creates a startup script).
  * [install the client](http://www.tightvnc.com/download.php) on your remote computer.
  * You should now be able to access your C.H.I.P. **ugate:5901** from the client.
