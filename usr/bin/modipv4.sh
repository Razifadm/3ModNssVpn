#!/bin/sh

TTL_FILE="/etc/nftables.d/ttl64.nft"
TTL_DISABLED="/etc/nftables.d/ttl64.nft.disabled"
TTL_TABLE="ttl64"
INTERFACE="qmodem_4_1"

restart_services() {
  logger -t TTL64 "Restarting services..."
  /etc/init.d/firewall restart >/dev/null 2>&1
  /etc/init.d/network restart >/dev/null 2>&1
  sleep 8
  /etc/init.d/qmodem_network restart >/dev/null 2>&1
  sleep 1

  if ! ifstatus "$INTERFACE" | grep -q '"up": true'; then
    logger -t TTL64 "INFO: $INTERFACE not up, attempting ifup..."
    ifup "$INTERFACE"
    sleep 1
  fi

  logger -t TTL64 "DEBUG: PDP type is $(uci get qmodem.4_1.pdp_type)"
  logger -t TTL64 "DEBUG: Interface status: $(ifstatus $INTERFACE | grep -E '\"up\"|\"device\"')"
}

mod() {
  [ -f "$TTL_DISABLED" ] && mv "$TTL_DISABLED" "$TTL_FILE"

  uci set firewall.@defaults[0].flow_offloading='0'
  uci set firewall.@defaults[0].flow_offloading_hw='0'
  uci commit firewall >/dev/null 2>&1

  uci set qmodem.'4_1'.pdp_type='ip'
  uci commit qmodem

  logger -t TTL64 "MODE: MOD (TTL active, Flow offloading disabled)"
  restart_services
}

nss() {
  [ -f "$TTL_FILE" ] && mv "$TTL_FILE" "$TTL_DISABLED" && \
  nft delete table inet "$TTL_TABLE" >/dev/null 2>&1

  uci set firewall.@defaults[0].flow_offloading='1'
  uci set firewall.@defaults[0].flow_offloading_hw='1'
  uci commit firewall >/dev/null 2>&1

  uci set qmodem.'4_1'.pdp_type='ipv4v6'
  uci commit qmodem

  logger -t TTL64 "MODE: NSS (TTL removed, NSS enabled)"
  restart_services
}

vpn() {
  [ -f "$TTL_DISABLED" ] && mv "$TTL_DISABLED" "$TTL_FILE"

  uci set firewall.@defaults[0].flow_offloading='1'
  uci set firewall.@defaults[0].flow_offloading_hw='1'
  uci commit firewall >/dev/null 2>&1

  uci set qmodem.'4_1'.pdp_type='ip'
  uci commit qmodem


  logger -t TTL64 "MODE: VPN (TTL active, NSS)"
  restart_services
}

case "$1" in
  mod) mod ;;
  nss) nss ;;
  vpn) vpn ;;
  *) echo "Usage: $0 {mod|nss|vpn}" ;;
esac
