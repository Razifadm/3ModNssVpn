#!/bin/sh

# Download controller
wget -O /usr/lib/lua/luci/controller/ttl64.lua \
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/main/usr/lib/lua/luci/controller/ttl64.lua >/dev/null 2>&1

# Download view
wget -O /usr/lib/lua/luci/view/admin_status/ttl64.htm \
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/main/usr/lib/lua/luci/view/admin_status/ttl64.htm >/dev/null 2>&1

# Download bin modipv4.sh
wget -O /usr/bin/modipv4.sh \
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/main/usr/bin/modipv4.sh >/dev/null 2>&1

# Download bin meodemtemp
wget -O /usr/bin/modemtemp \
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/main/usr/bin/modemtemp >/dev/null 2>&1

#Buang Rules nft sedia ada
rm -f /etc/nftables.d/*.nft >/dev/null 2>&1
sleep 2

# Download ttl64.nft
wget -O /etc/nftables.d/ttl64.nft \
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/main/etc/nftables.d/ttl64.nft >/dev/null 2>&1

# Bagi permission execute pada bin
chmod +x /usr/bin/modipv4.sh >/dev/null 2>&1
chmod +x /usr/bin/modemtemp >/dev/null 2>&1

echo "✅ 3Mod installed"
# Padam skrip ini sendiri
rm -f "$0"
