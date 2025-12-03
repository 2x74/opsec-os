#!/bin/bash
PACKAGES="base-system kde5 sddm xorg tor firejail keepassxc bleachbit wireshark firefox gnupg2 zulucrypt-gui tcpdump openvpn wireguard-tools apparmor macchanger dnscrypt-proxy vim git kwrite cmatrix fastfetch"

sudo ./mklive.sh \
    -o OpSec-OS-0.1-x86_64.iso \
    -p "$PACKAGES" \
    -T "OpSec OS" \
    -a x86_64
