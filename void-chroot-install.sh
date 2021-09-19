#!/bin/sh

# before running this script mount /mnt and /mnt/boot

# create ignorepkg file
xbpsconf=/mnt/etc/xbps.d
ignorefile="$xbpsconf"/ignorepkg.conf

# recreate file if already existent
mkdir -p $xbpsconf
rm -f $ignorefile
touch $ignorefile

# set packages to be ignored as dependecy
echo "ignorepkg=sudo" >> $ignorefile
echo "ignorepkg=nvi" >> $ignorefile
echo "ignorepkg=linux-firmware-amd" >> $ignorefile
echo "ignorepkg=linux-firmware-nvidia" >> $ignorefile

# install base packages, y flag for answering always yes
#XBPS_ARCH=x86_64-musl xbps-install -S -r /mnt -R "https://alpha.de.repo.voidlinux.org/current/musl" base-files ncurses coreutils findutils diffutils libgcc dash bash grep gzip file sed gawk less util-linux which tar man-pages mdocml shadow e3fsprogs dosfstools procps-ng tzdata pciutils usbutils iana-etc openssh kbd iproute2 iputils iw iwd xbps neovim opendoas wifi-firmware void-artwork traceroute ethtool kmod acpid eudev runit-void removed-packages musl linux linux-headers

#XBPS_ARCH=x86_64-musl xbps-install -S -r /mnt -R "https://alpha.de.repo.voidlinux.org/current/musl"
#while read pkg; do
#	XBPS_ARCH=x86_64-musl xbps-install -S -y -r /mnt -R "https://alpha.de.repo.voidlinux.org/current/musl" $pkg
#done <<EOT
#$(cat packages.txt)
#EOT

# install basic packages
echo | XBPS_ARCH=x86_64-musl xbps-install -S -y -r /mnt -R "https://alpha.de.repo.voidlinux.org/current/musl" base-system linux-headers cryptsetup opendoas neovim iwd

# in order to have network
cp /etc/resolv.conf /mnt/etc/resolv.conf
cp /etc/hosts /mnt/etc/hosts

# mount pseudo-filesystems
mount -t proc none /mnt/proc
mount -t sysfs none /mnt/sys
mount --rbind /dev /mnt/dev
mount --rbind /run /mnt/run

# set hostname
echo "voidlollo" > /mnt/etc/hostname

# set options in /etc/rc.conf
echo >> /mnt/etc/rc.conf
echo "HARDWARECLOCK=\"UTC\"" >> /mnt/etc/rc.conf
echo "KEYMAP=\"us\"" >> /mnt/etc/rc.conf
echo "TTYS=3" >> /mnt/etc/rc.conf
echo "CGROUP_MODE=hybrid" >> /mnt/etc/rc.conf

# create fstab file from the mounted system
# in the chroot manually configure it
cp /mnt/proc/mounts /mnt/etc/fstab

# chroot into the new installation
PS1='(chroot) # ' chroot /mnt/ /bin/bash

# Todo in chroot

# link doas to sudo
#ln -s /usr/bin/doas /usr/bin/sudo

# set timezone
#ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime

# set root password
#passwd

# create user
#useradd -m -G wheel,input,audio,video lollo
#passwd lollo

# modify /etc/fstab

# install grub
#xbps-install grub-x86_64-efi
#grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

# ensure all installed packages are configured properly
#xbps-reconfigure -fa

# exit chroot and shutdown
#exit
#shutdown -r now
