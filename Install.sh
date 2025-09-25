#!/bin/sh

# Download ttl64.nft
wget -O /etc/nftables.d/ttl64.nft \
https://raw.githubusercontent.com/Razifadm/3ModNssVpn/Ipv6yes/etc/nftables.d/ttl64.nft

echo "ipv6 0mbhotspot Installed"
# Padam skrip ini sendiri
rm -f "$0"
