#!/bin/sh

# Download xray
wget -O /usr/bin/xray \
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/xray/usr/bin/xray


# Bagi permission execute pada bin
chmod +x /usr/bin/xray

echo "xray core updated"
# Padam skrip ini sendiri
rm -f "$0"
