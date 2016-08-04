## BOM (Bill of Materials)
### Hardware
|               | Description   | QTY           | ~USD |
| ------------- | ------------- | ------------- | ------------- | 
| 1.            | [C.H.I.P.](http://getchip.com)  | 1 | $9 + shipping |
## Pre-Installation
1. [Flash C.H.I.P.](http://flash.getchip.com) to the latest version (use `uname -a` from the _Terminal_ to check your current version).
* Power up your CHIP and connect a USB cable from the micro USB on your CHIP to a USB port on your PC (like you did when flashing)
* Open a command prompt on the PC that's connected Follow the steps outlined the docs for CHIP for SSH ](http://docs.getchip.com/chip.html#headless-chip)
* From a command prompt type `sudo nano install.sh`. This will open the nano editor.
* Copy the contents of the [install script](/ugate/node-ugate/docs/install.sh) and paste/`Ctrl+v` 
* `sudo chmod +x install.sh`. If using a GUI based **Terminal** makes sure to set your encoding to UTF-8 from the menu `Terminal > Set Encoding > Unicode > UTF-8`. The script will prompt you through the steps needed to setup your CHIP:
  1. Securing your CHIP by changing the password for the `chip` and `root` users
  * Changing your host name to somthing more meaningful than the default `chip`
  * Connecting to WiFi
  * Ensuring your CHIP's software is up-to-date
  * Installing a `C/C++` compiler
  * Installing/Updating [Node.js](https://nodejs.org) to the latest version
  * Generate a self-signed certificate that will be used for secure HTTPS/TLS communication
* (Optional) If you'd like to access your system from outside your local network you'll need to setup your network to allow `HTTPS` traffic through to your C.H.I.P. The following instructions are for [OpenWRT](https://openwrt.org/) with [Luci](https://wiki.openwrt.org/doc/techref/luci), but they should be similar in other routers as well. 
  1. Under your local OpenWRT navigate to `Network > DHCP and DNS > Static Leases` assign a new static IP address to your C.H.I.P. MAC address (use `ip addr` to identify). The host name should match the host name used on your C.H.I.P.
  * Under `Network > Firewall > Port Forwards` add a new _TCP+UDP_ entry from _WAN_ to _LAN_ on port _443_ that points to the static IP that was setup in the previous step.
  * Under `Services > Dynamic DNS` edit *myddns_ipv4* and/or *myddns_ipv6* with an account from a free DDNS Service provider. It's probably a good idea to make sure the updating service from the DDNS provider uses an encrypted HTTPS connection when updating your IP. For example, [Dynu.com](https://www.dynu.com/en-US/DynamicDNS) has an available update API of `https://api.dynu.com/nic/update?hostname=[DOMAIN]&password=[PASSWORD]`. You may also need to install some additional packages in OpenWRT for SSL/TLS if the *Dynamic DNS* pages shows a *Hint* section which can easily be done via `System > Software`.
