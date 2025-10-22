#!/bin/sh

# Download controller
wget -O /usr/lib/lua/luci/controller/ttl64.lua \
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/beta/usr/lib/lua/luci/controller/ttl64.lua >/dev/null 2>&1

# Download view
wget -O /usr/lib/lua/luci/view/admin_status/ttl64.htm \
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/beta/usr/lib/lua/luci/view/admin_status/ttl64.htm >/dev/null 2>&1

# Download bin modipv4.sh
wget -O /usr/bin/modipv4.sh \
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/beta/usr/bin/modipv4.sh >/dev/null 2>&1

# Download bin modemtemp
wget -O /usr/bin/modemtemp \
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/beta/usr/bin/modemtemp >/dev/null 2>&1

# Download Wanip
wget -O /usr/bin/wanip \
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/beta/usr/bin/wanip >/dev/null 2>&1

# Buang Rules nft sedia ada
rm -f /etc/nftables.d/*.nft >/dev/null 2>&1
sleep 1

# Download ttl64.nft
wget -O /etc/nftables.d/ttl64.nft \
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/beta/etc/nftables.d/ttl64.nft >/dev/null 2>&1

# Bagi permission pada bin
chmod +x /usr/bin/modipv4.sh >/dev/null 2>&1
chmod +x /usr/bin/modemtemp >/dev/null 2>&1
chmod +x /usr/bin/wanip >/dev/null 2>&1

# restart firewall
/etc/init.d/firewall restart >/dev/null 2>&1

#qmodem setup
# Semak jika fail konfigurasi qmodem wujud. Fail utama adalah /etc/config/qmodem.
if [ ! -f /etc/config/qmodem ]; then
    echo "This system doesnt use qmodem, aborting next step"
    exit 1
fi
echo "This system using qmodem, applying qmodem setting APN ipv4v6"

# ===============================================
# ===  Qmodem UCI and Restart ===
# ===============================================

# set pdp type to ipv4v6
uci set qmodem.'4_1'.pdp_type='ipv4v6'
uci commit qmodem
echo "Qmodem set APN to ipv4v6"

# Restart Services
echo "Restarting services"
/etc/init.d/qmodem_network restart >/dev/null 2>&1
sleep 1
/etc/init.d/qmodem_network restart >/dev/null 2>&1
sleep 1


echo "✅ 3Mod installed"
# Padam skrip ini sendiri
rm -f "$0"
