#!/bin/bash
# configures and installs the requirements for running node-ugate
# run 'sudo chmod +x install.sh && ./install.sh' to run the installation
clear
res=
hn=ugate
pwo=chip
pw=
uname -a
echo -n "Enter the CURRENT password for \"$USER\" [chip]: "
read -s res
if [ -n "$res" ]; then
  pwo=$res
fi
echo "$pwo" | sudo -S echo ""
echo -n "Enter a NEW password for \"$USER\": "
read -s pw
if [ -z "$pw" ]; then
  echo "Password required. Exiting install..."
  exit 1
fi
echo ""
echo -n "Enter a new hostname for CHIP [ugate]: "
read res
if [ -n "$res" ]; then
  hn=$res
fi

# WiFi setup
ssid=
ssidp=
echo "=============================="
nmcli device wifi list
echo "=============================="
readarray -t ssids < <(nmcli -f ssid device wifi list ifname wlan0 | grep -o '^\S*')
# first element in array is "SSID"
ssids[0]="*** Skip ***"
PS3="Please select a SSID by number: "
select ssid in "${ssids[@]}"; do
  for item in "${ssids[@]}"; do
    if [[ $item == $ssid ]]; then
      break 2
    fi
  done
done
if [ "$ssid" != "${ssids[0]}" ]; then
  echo -n "Enter the password to connect to \"$ssid\": "
  read -s ssidp
  if [ -z "$ssidp" ]; then
    echo "SSID password required. Exiting install..."
    exit 1
  fi
  # remove existing (if present) and add
  #sudo nmcli device disconnect wlan0
  sudo nmcli con delete id "$ssid" &> /dev/null
  sudo nmcli device wifi connect "$ssid" password "$ssidp" ifname wlan0
  echo ""
fi

# update/upgrade system
yn=("Y" "N")
yna=
echo "=============================="
PS3="Update/Upgrade system using apt-get (1 or 2): "
select yna in "${yn[@]}"; do
  for item in "${yn[@]}"; do
    if [[ $item == $yna ]]; then
      break 2
    fi
  done
done
if [ "$yna" = 1 ]; then
  sudo apt-get update && sudo apt-get -y upgrade
fi

# Enable HTTPS/TLS
yn=("Y" "N")
yna=
echo "=============================="
PS3="Add required self-signed certificate for HTTPS/TLS: "
select yna in "${yn[@]}"; do
  for item in "${yn[@]}"; do
    if [[ $item == $yna ]]; then
      break 2
    fi
  done
done
if [ "$yna" = 1 ]; then
  sudo openssl req -x509 -sha256 -newkey rsa:2048 -keyout /etc/ssl/private/key.pem -out /etc/ssl/certs/cert.pem -days 18250 -nodes
  echo "Generated /etc/ssl/private/key.pem and /etc/ssl/certs/cert.pem"
fi
