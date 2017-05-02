#!/bin/sh

# Change this line according to your system
prefix="/srv/chroot/xenial_i386"

mount -o bind /sys ${prefix}/sys
mount -o bind /var/lib/dbus ${prefix}/var/lib/dbus
mount --rbind /dev ${prefix}/dev
mount -t proc none ${prefix}/proc

