#!/bin/sh

TTL_FILE="/etc/nftables.d/ttl64.nft"
TTL_DISABLED="/etc/nftables.d/ttl64.nft.disabled"
TTL_TABLE="ttl64"

mod() {
  # Aktifkan TTL
  [ -f "$TTL_DISABLED" ] && mv "$TTL_DISABLED" "$TTL_FILE"

  # Matikan flow offloading
  uci set firewall.@defaults[0].flow_offloading='0'
  uci set firewall.@defaults[0].flow_offloading_hw='0'
  uci commit firewall >/dev/null 2>&1
  
  # Set PDP type ke ipv4 dalam section modem-device '4_1'
  uci set qmodem.'4_1'.pdp_type='ip'
  uci commit qmodem
  # Restart servis
  /etc/init.d/qmodem_network restart >/dev/null 2>&1
  /etc/init.d/firewall restart >/dev/null 2>&1
  /etc/init.d/network restart >/dev/null 2>&1

  logger -t TTL64 "MODE: MOD (TTL active, Flow offloading disabled)"



}

nss() {
  # Matikan TTL
  [ -f "$TTL_FILE" ] && mv "$TTL_FILE" "$TTL_DISABLED" && \
  nft delete table inet "$TTL_TABLE" >/dev/null 2>&1

  # Hidupkan flow offloading
  uci set firewall.@defaults[0].flow_offloading='1'
  uci set firewall.@defaults[0].flow_offloading_hw='1'
  uci commit firewall >/dev/null 2>&1
  
  # Set PDP type ke ipv4 dalam section modem-device '4_1'
  uci set qmodem.'4_1'.pdp_type='ipv4v6'
  uci commit qmodem

  # Restart servis
  /etc/init.d/qmodem_network restart >/dev/null 2>&1
  /etc/init.d/firewall restart >/dev/null 2>&1
  /etc/init.d/network restart >/dev/null 2>&1

  logger -t TTL64 "MODE: NSS (TTL removed, Flow offloading enabled)"


}

vpn() {
  # Aktifkan TTL
  [ -f "$TTL_DISABLED" ] && mv "$TTL_DISABLED" "$TTL_FILE"

  # Hidupkan flow offloading
  uci set firewall.@defaults[0].flow_offloading='1'
  uci set firewall.@defaults[0].flow_offloading_hw='1'
  uci commit firewall >/dev/null 2>&1

  # Set PDP type ke ipv4 dalam section modem-device '4_1'
  uci set qmodem.'4_1'.pdp_type='ip'
  uci commit qmodem

  # Restart servis
  /etc/init.d/qmodem_network restart >/dev/null 2>&1
  /etc/init.d/firewall restart >/dev/null 2>&1
  /etc/init.d/network restart >/dev/null 2>&1

  logger -t TTL64 "MODE: VPN (TTL active, Flow offloading enabled, PDP=ipv4)"
}

case "$1" in
  mod) mod ;;
  nss) nss ;;
  vpn) vpn ;;
  *) echo "Usage: $0 {mod|nss|vpn}" ;;
esac
