#!/bin/sh

# Download controller
wget -O /usr/lib/lua/luci/controller/ttl64.lua \
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/main/usr/lib/lua/luci/controller/ttl64.lua

# Download view
wget -O /usr/lib/lua/luci/view/admin_status/ttl64.htm \
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/main/usr/lib/lua/luci/view/admin_status/ttl64.htm

# Download bin modipv4.sh
wget -O /usr/bin/modipv4.sh \
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/main/usr/bin/modipv4.sh

# Download bin meodemtemp
wget -O /usr/bin/modemtemp\
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/main/usr/bin/modemtemp

# Bagi permission execute pada bin
chmod +x /usr/bin/modipv4.sh
chmod +x /usr/bin/modemtemp

echo "✅ 3Mod installed"
# Padam skrip ini sendiri
rm -f "$0"
