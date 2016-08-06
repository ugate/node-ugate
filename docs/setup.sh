#!/bin/bash
LC_ALL=en_US.UTF-8
# configures and installs the requirements for running node-ugate
# run 'sudo chmod +x install.sh && ./install.sh' to run the installation
clear
res=
rboot=
uname -a
cat << "EOF"
===========================================================================

                          ▒▒▒       ▒▒▒       ▒▒░
                          ▒▒▒       ▒▒▒       ▒▒░
                          ▒▒▒       ▒▒▒       ▒▒░
                   ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
                   ▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒
                   ▒▒░                              ░▒▒
             ▒▒▒▒▒▒▒▒░                              ░▒▒▒▒▒▒▒▒▒
                   ▒▒░       ▒▒▒▒                   ░▒▒
                   ▒▒░     ▒▒▒▒▒▒▒▒                 ░▒▒
                   ▒▒░     ▒▒▒▒▒▒▒▒░                ░▒▒
                   ▒▒░      ▒▒▒▒▒▒▒▒▒▒              ░▒▒
             ▒▒▒▒▒▒▒▒░       ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
                   ▒▒░                              ░▒▒
                   ▒▒░                              ░▒▒
                   ▒▒░                              ░▒▒
             ▒▒▒▒▒▒▒▒░                              ░▒▒▒▒▒▒▒▒▒
                   ▒▒░                              ░▒▒
                   ▒▒░                              ░▒▒
                   ▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒
                   ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
                          ▒▒▒        ▒▒▒       ▒▒▒
                          ▒▒▒        ▒▒▒       ▒▒▒
                          ▒▒▒        ▒▒▒       ▒▒▒

                   ____      _   _      ___       ____
                  / ___|    | | | |    |_ _|     |  _ \
                 | |        | |_| |     | |      | |_) |
                 | |___   _ |  _  |  _  | |      | |__/
                  \____| (_)|_| |_| (_)|___| (_) |_|   (_)
===========================================================================
                  _______ _______ _______ _     _  _____
                  |______ |______    |    |     | |_____]
                  ______| |______    |    |_____| |
===========================================================================
EOF

# password for the current user
while [[ -z "$pwo" ]]; do
  read -s -p "Enter a CURRENT password for \"$USER\" (default=\"chip\"): " pwo
  if [[ -z "$pwo" ]]; then
    pwo=chip
  fi
  echo "*** validating password ***"
  sudo -k
if sudo -lS &> /dev/null <<- _EOF_
$pwo
_EOF_
  then
    echo 'Password confirmed!'
  else
    echo '☠ Invalid password!'
    pwo=""
  fi
done

# change $USER password
echo "==========================================================================="
cpw () {
  yn=("*** Skip ***" "Change password for \"$1\"")
  yna=
  pwx=
  pwc=
  PS3="Enter 1 or 2: "
  select yna in "${yn[@]}"; do
    for item in "${yn[@]}"; do
      if [[ $item == $yna ]]; then
        break 2
      fi
    done
  done
  if [[ $yna == "${yn[1]}" ]]; then
    while [[ -z "$pwx" || "$pwx" != "$pwc" || ${#pwx} -lt 8 ]]; do
      if [ "$pwx" != "$pwc" ]; then
        echo ""
        echo "☠ New pasword and retyped password do not match!"
      elif [[ -n "$pwx" && ${#pwx} -lt 8 ]]; then
        echo ""
        echo "☠ New password is too short (min 8 characters)!"
      fi
      read -s -p "Enter a NEW password for \"$1\": " pwx
      echo ""
      read -s -p "Retype NEW password for \"$1\": " pwc
    done
    echo ""
    if [[ "$1" == "$USER" ]]; then
      pwu=$pwx
    else
      pwr=$pwx
    fi
    if sudo passwd $1 &> /dev/null <<- _EOF_
$pwx
$pwx
_EOF_
    then
      echo "Password changed for $1!"
    else
      echo "☠ Failed to change password for $1! "$?
    fi
  fi
}
cpw "$USER"
echo "---------------------------------------------------------------------------"
cpw "root"

# update host files
echo "==========================================================================="
hn=$(grep -o -m 1 '\b[a-z]*\b' /etc/hosts)
yn=("*** Skip ***" "Change host name from \"$hn\"")
yna=
PS3="Enter 1 or 2: "
select yna in "${yn[@]}"; do
  for item in "${yn[@]}"; do
    if [[ $item == $yna ]]; then
      break 2
    fi
  done
done
if [[ $yna == "${yn[1]}" ]]; then
  read -p "Enter a NEW hostname for CHIP: " res
  if [[ -n "$res" ]]; then
    yn=("*** Skip ***" "Replace \"$hn\" with \"$res\" in \"/etc/hostname\" and \"/etc/hosts\"")
    yna=
    PS3="Enter 1 or 2: "
    select yna in "${yn[@]}"; do
      for item in "${yn[@]}"; do
        if [[ $item == $yna ]]; then
          break 2
        fi
      done
    done
    if [[ $yna == "${yn[1]}" ]]; then
      echo "---------------------------------------------------------------------------"
      echo "/etc/hostname contents:"
      sudo sed -i "s/${hn}/${res}/ig" /etc/hostname
      cat /etc/hostname
      echo "---------------------------------------------------------------------------"
      echo "/etc/hosts contents:"
      sudo sed -i "s/${hn}/${res}/ig" /etc/hosts
      cat /etc/hosts
      hn=$res
    fi
  fi
fi

# WiFi setup
echo "==========================================================================="
nmcli device wifi list
echo "---------------------------------------------------------------------------"
ssid=
ssidp=
readarray -t ssids < <(nmcli -f ssid device wifi list ifname wlan0 | grep -o '^\S*')
# first element in array is "SSID"
ssids[0]="*** Skip ***"
PS3="Please select a WiFi SSID to connect to (use list #): "
select ssid in "${ssids[@]}"; do
  for item in "${ssids[@]}"; do
    if [[ $item == $ssid ]]; then
      break 2
    fi
  done
done
if [ "$ssid" != "${ssids[0]}" ]; then
  while [[ -z "$ssidp" || ${#ssidp} -lt 8 ]]; do
    if [[ -n "$ssidp" && ${#ssidp} -lt 8 ]]; then
      echo "☠ Pasword for \"$ssid\" is too short (${#ssid} is less than min of 8 characters)!"
    fi
    read -s -p "Enter the password to connect to \"$ssid\": " ssidp
  done
  echo ""
  # remove existing (if present) and add
  #sudo nmcli device disconnect wlan0
  sudo nmcli con delete id "$ssid" &> /dev/null
  sudo nmcli device wifi connect "$ssid" password "$ssidp" ifname wlan0
  echo ""
fi

# update/upgrade system
echo "==========================================================================="
yn=("*** Skip ***" "Update/Upgrade system using apt-get")
yna=
PS3="Enter 1 or 2: "
select yna in "${yn[@]}"; do
  for item in "${yn[@]}"; do
    if [[ $item == $yna ]]; then
      break 2
    fi
  done
done
if [[ $yna == "${yn[1]}" ]]; then
  sudo apt-get update && sudo apt-get -y upgrade
fi

# install build-essential
echo "==========================================================================="
yn=("*** Skip ***" "Install required \"build-essential\" for C/C++ compilation")
yna=
PS3="Enter 1 or 2: "
select yna in "${yn[@]}"; do
  for item in "${yn[@]}"; do
    if [[ $item == $yna || -z "$yna" ]]; then
      break 2
    fi
  done
done
if [[ $yna == "${yn[1]}" ]]; then
  sudo apt-get -y install build-essential
fi

# install build-essential
echo "==========================================================================="
echo "By default /dev/i2c-1 (I2C on bus 1) is \"disabled\" in CHIP's DTB."
echo "Enabling i2c-1 will allow you to use the TWI1-SDA/TWI1-SCK pins on your CHIP."
echo "This process requires an update to /boot/sun5i-r8-chip.dtb"
yn=("*** Skip ***" "Update CHIP's DTB to enable /dev/i2c-1")
yna=
PS3="Enter 1 or 2: "
select yna in "${yn[@]}"; do
  for item in "${yn[@]}"; do
    if [[ $item == $yna || -z "$yna" ]]; then
      break 2
    fi
  done
done
if [[ $yna == "${yn[1]}" ]]; then
  mkdir -p
  sudo apt install device-tree-compiler
  sudo cp /boot/sun5i-r8-chip.dtb /boot/sun5i-r8-chip.dtb.bak.$(date -d "today" +"%Y%m%d%H%M")
  sudo fdtput -t s /boot/sun5i-r8-chip.dtb "/aliases" "i2c1" "/soc@01c00000/i2c@01c2b000"
  sudo fdtput -t s /boot/sun5i-r8-chip.dtb "/soc@01c00000/i2c@01c2b000" "status" "okay"
  sudo fdtput -t s /boot/sun5i-r8-chip.dtb "/soc@01c00000/i2c@01c2b000" "pinctrl-names" "default"
  sudo fdtput -t s /boot/sun5i-r8-chip.dtb "/soc@01c00000/i2c@01c2b000" "pinctrl-0" "/soc@01c00000/pinctrl@01c20800/i2c1@0"
  rboot=1
fi

# install node.js
echo "==========================================================================="
yn=("*** Skip ***" "Install/Update required Node.js")
yna=
PS3="Enter 1 or 2: "
select yna in "${yn[@]}"; do
  for item in "${yn[@]}"; do
    if [[ $item == $yna ]]; then
      break 2
    fi
  done
done
if [[ $yna == "${yn[1]}" ]]; then
  echo "Detecting latest Node.js version..."
  nodever=
  nodevernew=
  nodepth=$(which node)
  nodeurl="https://nodejs.org/dist/latest/"
  nodeurl=$nodeurl$(sudo curl -sS -L "$nodeurl" | grep -o -m 1 'node-v[0-9]*\.[0-9]*\.[0-9]*-linux-armv7l\.tar\.xz' | head -1)
  nodeop="Install"
  if [[ -n "$nodepth" ]]; then
    nodever=$(node -v)
    nodever=${nodever//[!0-9\.]/}
    nodevernew=$(grep -o '[0-9]*\.[0-9]*\.[0-9]*' <<< $nodeurl)
    nodeop="Upgrade Node.js from $nodever to"
    nodepth=${nodepth%"bin/node"}
  else
    nodepth=/usr/local/
  fi
  if [[ "$nodever" == "$nodevernew" ]]; then
    echo "Node.js is up to date with version $nodever"
  else
    yn=("*** Skip ***" "$nodeop \"$nodeurl\"")
    yna=
    PS3="Enter 1 or 2: "
    select yna in "${yn[@]}"; do
      for item in "${yn[@]}"; do
        if [[ $item == $yna ]]; then
          break 2
        fi
      done
    done
    if [[ $yna == "${yn[1]}" ]]; then
      if [[ -n "$nodepth" && -n "$nodever" ]]; then
        # remove existing node and npm
        sudo rm -rf $nodepth{lib/node{,/.npm,_modules},bin,share/man}/{npm*,node*,man1/node*}
      fi
      sudo curl -o /tmp/nodejs.tar.xz "$nodeurl"
      echo "Installing Node.js to $nodepth"
      sudo tar -C $nodepth --strip-components 1 -xJf /tmp/nodejs.tar.xz
      echo "Installed Node.js "$(node -v)" with npm "$(npm -v)
    fi
  fi
fi

# generate self-signed certificate for node.js HTTPS/TLS connections
yn=("*** Skip ***" "Generate required self-signed certificate for HTTPS/TLS")
yna=
echo "==========================================================================="
PS3="Enter 1 or 2: "
select yna in "${yn[@]}"; do
  for item in "${yn[@]}"; do
    if [[ $item == $yna ]]; then
      break 2
    fi
  done
done
if [[ $yna == "${yn[1]}" ]]; then
  sudo openssl req -x509 -sha256 -newkey rsa:2048 -keyout /etc/ssl/private/key.pem -out /etc/ssl/certs/cert.pem -days 18250 -nodes
  echo "Generated /etc/ssl/private/key.pem and /etc/ssl/certs/cert.pem"
fi

# reboot?
echo "==========================================================================="
if [[ $rboot == 1 ]]; then
  echo "CHIP needs to reboot for setup to complete..."
  yn=("*** Skip ***" "Reboot CHIP")
  yna=
  PS3="Enter 1 or 2: "
  select yna in "${yn[@]}"; do
    for item in "${yn[@]}"; do
      if [[ $item == $yna || -z "$yna" ]]; then
        break 2
      fi
    done
  done
  if [[ $yna == "${yn[1]}" ]]; then
    sudo reboot
  fi
else
  echo "Setup is complete and your CHIP is ready for use!"
fi
echo "==========================================================================="
exit 0 #Exit with success
