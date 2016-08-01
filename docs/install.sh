#!/bin/bash
# configures and installs the requirements for running node-ugate
# run 'sudo chmod +x install.sh && ./install.sh' to run the installation
res=
hn=ugate
pwo=chip
pw=
ssid=
ssidp=
echo -n "Enter the CURRENT password for \"$USER\" [chip] > "
read -s res
if [ -n "$res" ]; then
  pwo=$res
fi
echo -n "Enter a NEW password for \"$USER\" > "
read -s pw
if [ -z "$pw" ]; then
  echo "Password required. Exiting install..."
  exit 1
fi
echo -n "Enter a new hostname for CHIP [ugate] > "
read res
if [ -n "$res" ]; then
  hn=$res
fi
echo "=============================="
nmcli device wifi list
echo "=============================="
echo -n "Enter a SSID name to connect to from the connections above > "
read ssid
if [ -z "$ssid" ]; then
  echo "SSID required. Exiting install..."
  exit 1
fi
echo -n "Enter the password to connect to $ssid > "
read -s ssidp
if [ -z "$ssidp" ]; then
  echo "SSID password required. Exiting install..."
  exit 1
fi
echo "$pwo" | sudo -S nmcli delete id "$ssid" &> /dev/null
sudo nmcli device wifi connect "$ssid" password "$ssidp" ifname wlan0
