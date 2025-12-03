#!/bin/sh
ROOTFS="$1"

# Enable services only if they exist
for service in sddm dbus NetworkManager bluetoothd apparmor dnscrypt-proxy; do
    if [ -d "$ROOTFS/etc/sv/$service" ]; then
        chroot "$ROOTFS" ln -sf /etc/sv/$service /etc/runit/runsvdir/default/
        echo "Enabled service: $service"
    else
        echo "Warning: Service $service not found, skipping"
    fi
done
