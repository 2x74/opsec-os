#!/bin/bash
# OpSec OS Build Script
# ALL ASSETS OF OPSEC OS (incl. but not limited to logo and slogan) ARE MADE BY LUNA ■■■■■ (surname redacted).
# NO COPYRIGHT... YET... OR MAYBE EVER...

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}   OpSec OS ISO Build Script${NC}"
echo -e "${GREEN}======================================${NC}"
echo

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: This script must be run as root${NC}"
    echo "Usage: sudo ./build-opsec.sh"
    exit 1
fi

# Check if mklive.sh exists
if [ ! -f "./mklive.sh" ]; then
    echo -e "${RED}Error: mklive.sh not found in current directory${NC}"
    exit 1
fi

# Check if overlays directory exists
if [ ! -d "./overlays/opsec" ]; then
    echo -e "${YELLOW}Warning: overlays/opsec directory not found${NC}"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Make mklive.sh executable
chmod +x ./mklive.sh

echo -e "${GREEN}Starting ISO build...${NC}"
echo

# Build the ISO
./mklive.sh \
    -o opsec-live.iso \
    -I overlays/opsec/ \
    -T "OpSec OS" \
    -r "https://repo-default.voidlinux.org/current" \
    -r "https://repo-default.voidlinux.org/current/nonfree" \
    -r "https://repo-default.voidlinux.org/current/multilib" \
    -p "xorg kde5 sddm konsole flatpak dialog NetworkManager efibootmgr grub-x86_64-efi tor firejail keepassxc bleachbit wireshark firefox gnupg2 zulucrypt-gui tcpdump openvpn wireguard-tools apparmor macchanger dnscrypt-proxy vim git kwrite cmatrix fastfetch pipewire wireplumber bluez bluedevil" \
    -S "dbus sddm NetworkManager bluetoothd"

# Bluetoothd is the only service that is removable from services. All packages except essentials (xorg, kde5, sddm, konsole, dialog, NetworkManager, efibootmgr, grub-x86_64-efi, pipewire, wireplumber) can be removed. Multilib, and nonfree can be removed from the repos. 'Current' is the main repo, and shouldn't be removed unless you want an airgapped system, something like that.

# Check if build was successful
if [ $? -eq 0 ]; then
    echo
    echo -e "${GREEN}======================================${NC}"
    echo -e "${GREEN}   Build completed successfully!${NC}"
    echo -e "${GREEN}======================================${NC}"
    echo
    if [ -f "opsec-live.iso" ]; then
        ISO_SIZE=$(du -h opsec-live.iso | cut -f1)
        echo -e "${GREEN}ISO file: ${NC}opsec-live.iso"
        echo -e "${GREEN}Size: ${NC}$ISO_SIZE"
        echo
        echo -e "${YELLOW}You can now write this ISO to a USB drive with:${NC}"
        echo "  dd if=opsec-live.iso of=/dev/sdX bs=4M status=progress"
        echo "  (replace /dev/sdX with your USB device)"
    fi
else
    echo
    echo -e "${RED}======================================${NC}"
    echo -e "${RED}   Build failed!${NC}"
    echo -e "${RED}======================================${NC}"
    echo -e "${RED}Check the output above for errors${NC}"
    exit 1
fi
