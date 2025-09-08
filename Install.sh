#!/bin/sh

# Download controller
wget -O /usr/lib/lua/luci/controller/ttl64.lua \
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/Qwrt/usr/lib/lua/luci/controller/ttl64.lua

# Download view
wget -O /usr/lib/lua/luci/view/admin_status/ttl64.htm \
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/Qwrt/usr/lib/lua/luci/view/admin_status/ttl64.htm

# Download bin modipv4.sh
wget -O /usr/bin/modipv4.sh \
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/Qwrt/usr/bin/modipv4.sh

# Download bin modemtemp 
wget -O /usr/bin/modemtemp \
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/Qwrt/usr/bin/modemtemp

#delete unnecessaary interfaces
uci -q delete network.wan6
uci -q delete network.wan
uci -q delete network.ipsec_server

#delete pakage
#opkg remove --force-removal-of-dependent-packages leigod-acc


# Download firewall.user ttl fw3
#wget -O /etc/firewall.user \
#https://raw.githubusercontent.com/Razifadm/3ModNssVpn/Fw3/etc/firewall.user

# Bagi permission execute pada bin
chmod +x /usr/bin/modipv4.sh
chmod +x /usr/bin/modemtemp

echo "✅ 3Mod installed"
# Padam skrip ini sendiri
rm -f "$0"
