#!/bin/sh

# ===============================================
# === Check 1: NFTables vs IPTables ===
# ===============================================

# Checking firewall nftable or iptables
if ! command -v nft >/dev/null 2>&1; then
    echo "ERROR!! this script need nftable, aborting..."
    exit 1
fi
echo "Installing Configuration"

# ===============================================
# === NFTables =================================
# ===============================================

# Delete rules nft in /etc/nftables.d
echo "Installing ttl step 2"
rm -f /etc/nftables.d/*.nft

# Downloading ttl64.nft
echo "Applying Nftables rules"
wget -O /etc/nftables.d/ttl64.nft \
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/Ipv6yes/etc/nftables.d/ttl64.nft

# Semak status muat turun
if [ $? -ne 0 ]; then
    echo "Please check your internet connection!!."
    exit 1
fi
echo "Configuration..."

# -----------------------------------------------

# ===============================================
# === Check 2: Qmodem ===========================
# ===============================================

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
/etc/init.d/firewall restart >/dev/null 2>&1
/etc/init.d/qmodem_network restart >/dev/null 2>&1
sleep 1
/etc/init.d/qmodem_network restart >/dev/null 2>&1
sleep 1

echo "ipv6 TTL Installed completely!🎉"

#del
rm -f "$0"
