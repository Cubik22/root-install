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
echo "ignorepkg=linux-firmware-nvidia" >> $ignorefile

# install basic packages
echo | XBPS_ARCH=x86_64-musl xbps-install -S -y -r /mnt -R "https://alpha.de.repo.voidlinux.org/current/musl" base-system cronie opendoas grub-x86_64-efi neovim iwd openresolv

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
cat << EOF >> /mnt/etc/rc.conf

HARDWARECLOCK="UTC"
KEYMAP="us"
TTYS=3
CGROUP_MODE=hybrid
EOF

# create fstab file from the mounted system
# in the chroot manually configure it
cp /mnt/proc/mounts /mnt/etc/fstab

# create brightness rule so video users can change brightness
mkdir -p /mnt/etc/udev/rules.d
echo "RUN+=\"/bin/chgrp video /sys/class/backlight/intel_backlight/brightness\"" > /mnt/etc/udev/rules.d/backlight.rules
echo "RUN+=\"/bin/chmod g+w /sys/class/backlight/intel_backlight/brightness\"" >> /mnt/etc/udev/rules.d/backlight.rules

# set swappiness value
mkdir -p /mnt/etc/sysctl.d
echo "vm.swappiness=30" > /mnt/etc/sysctl.d/99-swappiness.conf

# enable periodic trim with cron
mkdir -p /mnt/etc/cron.weekly
cat << EOF > /mnt/etc/cron.weekly/fstrim
#!/bin/sh

fstrim /
EOF
chmod u+x /mnt/etc/cron.weekly/fstrim

# chroot into the new installation
PS1='(chroot) # ' chroot /mnt/ /bin/bash

# Todo in chroot

# execute root_install.sh

# edit /etc/default/grub (set GRUB_DISTRIBUTOR)

# link doas to sudo (already done in root_install.sh)
#ln -s /usr/bin/doas /usr/bin/sudo

# set timezone
#ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime

# link also dbus and iwd
#ln -s /etc/sv/<service> /etc/runit/runsvdir/default/

# set root password
#passwd

# create user
#useradd -m -G wheel,input,audio,video lollo
#passwd lollo

# create swap file
#dd if=/dev/zero of=/swapfile bs=1G count=4 status=progress
#chmod 600 /swapfile
#mkswap /swapfile
#swapon /swapfile

# modify /etc/fstab
# remove everything except /mnt and /mnt/boot 
# set them to / and /boot 0 1 and 0 2
# use blkid to get UUID and set UUID=
#tmpfs /tmp tmpfs defaults,nosuid,nodev 0 0
#/swapfile none swap defaults 0 0

# install grub
#grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

# after changing /etc/default/grub run update-grub

# ensure all installed packages are configured properly
#xbps-reconfigure -fa

# exit chroot and shutdown
#exit
#shutdown -r now
