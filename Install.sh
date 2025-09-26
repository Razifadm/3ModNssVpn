#!/bin/sh

# Buang semua .nft dalam /etc/nftables.d
rm -f /etc/nftables.d/*.nft

#buang ttl64 lua dan htm
#rm -f /usr/lib/lua/luci/controller/ttl64.lua
#rm -f /usr/lib/lua/luci/view/admin_status/ttl64.htm
#rm -f

# Download ttl64.nft
wget -O /etc/nftables.d/ttl64.nft \
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/Ipv6yes/etc/nftables.d/ttl64.nft

#uci set qmodem.'4_1'.pdp_type='ipv4v6'
#uci commit qmodem
/etc/init.d/firewall restart >/dev/null 2>&1
/etc/init.d/qmodem_network restart >/dev/null 2>&1

echo "ipv6 0mbhotspot Installed, qmodem restarted"

#Del
rm -f "$0"
