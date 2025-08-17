#!/bin/sh

# Download controller
wget -O /usr/lib/lua/luci/controller/ttl64.lua \
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/Fw3/usr/lib/lua/luci/controller/ttl64.lua

# Download view
wget -O /usr/lib/lua/luci/view/admin_status/ttl64.htm \
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/Fw3/usr/lib/lua/luci/view/admin_status/ttl64.htm

# Download bin modipv4.sh
wget -O /usr/bin/modipv4.sh \
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/Fw3/usr/bin/modipv4.sh

# Download firewall.user ttl fw3
wget -O /etc/firewall.user \
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/Fw3/etc/firewall.user

# Bagi permission execute pada bin
chmod +x /usr/bin/modipv4.sh

echo "✅ 3Mod installed"
# Padam skrip ini sendiri
rm -f "$0"
