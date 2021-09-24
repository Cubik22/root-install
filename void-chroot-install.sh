#!/bin/sh

# before running this script mount /mnt and /mnt/boot
# clone this repository already in /mnt (/mnt/root)

# set xbps variables
xbpsconf=/mnt/etc/xbps.d
ignorefile="$xbpsconf"/ignorepkg.conf

# create xbpsconf directory
mkdir -p $xbpsconf

# set packages to be ignored as dependecy
echo "ignorepkg=sudo" > $ignorefile
echo "ignorepkg=btrfs-progs" >> $ignorefile
echo "ignorepkg=xfsprogs" >> $ignorefile
echo "ignorepkg=f2fs-tools" >> $ignorefile
echo "ignorepkg=wpa_supplicant" >> $ignorefile
echo "ignorepkg=dhcpcd" >> $ignorefile
echo "ignorepkg=nvi" >> $ignorefile
echo "ignorepkg=linux-firmware-amd" >> $ignorefile
#echo "ignorepkg=linux-firmware-nvidia" >> $ignorefile

# install basic packages
echo | XBPS_ARCH=x86_64-musl xbps-install -S -y -r /mnt -R "https://alpha.de.repo.voidlinux.org/current/musl" -R "https://mirrors.servercentral.com/voidlinux/current/musl" -R "https://alpha.us.repo.voidlinux.org/current/musl" $(cat xbps-packages-base.txt)

# install devel packages
echo | XBPS_ARCH=x86_64-musl xbps-install -S -y -r /mnt -R "https://alpha.de.repo.voidlinux.org/current/musl" -R "https://mirrors.servercentral.com/voidlinux/current/musl" -R "https://alpha.us.repo.voidlinux.org/current/musl" $(cat xbps-packages-devel.txt)

# in order to have network (setted manually after)
#cp /etc/resolv.conf /mnt/etc/resolv.conf
#cp /etc/hosts /mnt/etc/hosts

# mount pseudo-filesystems
mount -t proc none /mnt/proc
mount -t sysfs none /mnt/sys
mount --rbind /dev /mnt/dev
mount --rbind /run /mnt/run

# chroot into the new installation
PS1='(chroot)# ' chroot /mnt/ /bin/bash
