#!/usr/bin/env bash

if [ "$DEBUG" == "1" ]; then
    set -x
fi

set -e

echo "[cont-init.d] 00-config.sh - Starting..."

# 1) openvpn.conf yoksa ovpn_genconfig ile oluşturun
if [ ! -f "$OPENVPN/openvpn.conf" ]; then
  echo "[cont-init.d] No openvpn.conf found. Generating..."

  ovpn_genconfig

  echo "[cont-init.d] openvpn.conf created, now init pki..."

  ovpn_initpki nopass
fi

# 2) dnsmasq.conf yoksa oluşturun
if [ ! -f "$DNSMASQ/dnsmasq.conf" ]; then
  echo "[cont-init.d] Creating default dnsmasq.conf..."

  cat << EOF > "$DNSMASQ/dnsmasq.conf"
server=127.0.0.11
server=1.1.1.1
server=1.0.0.1
interface=tun0
bind-dynamic
log-facility=-
log-queries
EOF
fi

echo "[cont-init.d] 00-config.sh - Done"
