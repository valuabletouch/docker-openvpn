#!/usr/bin/env bash

set -e

echo "[cont-init.d] 00-config.sh - Starting..."

# 1) openvpn.conf yoksa ovpn_genconfig ile oluşturun
if [ ! -f "$OPENVPN_CONF" ]; then
  echo "[cont-init.d] No openvpn.conf found. Generating..."

  ovpn_genconfig

  echo "[cont-init.d] openvpn.conf created, now init pki..."

  ovpn_initpki nopass
fi

# 2) dnsmasq.conf yoksa oluşturun
if [ ! -f "${DNSMASQ_CONF}" ]; then
  echo "[cont-init.d] Creating default dnsmasq.conf..."

  cat << EOF > "${DNSMASQ_CONF}"
server=127.0.0.11
interface=tun0
bind-interfaces
log-facility=-
log-queries
EOF
fi

echo "[cont-init.d] 00-config.sh - Done"
