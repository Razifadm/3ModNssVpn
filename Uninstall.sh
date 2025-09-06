#!/bin/sh
#Remove controller
rm -f /usr/lib/lua/luci/controller/ttl64.lua

#Remove view
rm -f /usr/lib/lua/luci/view/admin_status/ttl64.htm

#Remove bin
#rm -f /usr/bin/modipv4.sh
#rm -f /usr/bin/modemtemp

#Remove nftable rule
#rm -f /etc/nftables.d/ttl64.nft

echo "✅ 3Mod uninstalled"
#Padam skrip ini sendiri
rm -f "$0"
