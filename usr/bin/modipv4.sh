#!/bin/sh
INTERFACE="qmodem_4_1"

restart_services() {
  logger -t TTL64 "Restarting services..."
  /etc/init.d/firewall restart >/dev/null 2>&1
  sleep 8
  /etc/init.d/qmodem_network restart >/dev/null 2>&1
  sleep 1
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

nss() {
  uci set firewall.@defaults[0].flow_offloading='1'
  uci set firewall.@defaults[0].flow_offloading_hw='1'
  uci commit firewall >/dev/null 2>&1

  uci set qmodem.'4_1'.pdp_type='ipv4v6'
  uci commit qmodem

  logger -t TTL64 "MODE: NSS (ipv4v6 enable, NSS enabled)"
  restart_services
}

vpn() {
  uci set firewall.@defaults[0].flow_offloading='1'
  uci set firewall.@defaults[0].flow_offloading_hw='1'
  uci commit firewall >/dev/null 2>&1

  uci set qmodem.'4_1'.pdp_type='ip'
  uci commit qmodem


  logger -t TTL64 "MODE: VPN (TTL active, NSS)"
  restart_services
}

case "$1" in
  nss) nss ;;
  vpn) vpn ;;
  *) echo "Usage: $0 {nss|vpn}" ;;
esac
