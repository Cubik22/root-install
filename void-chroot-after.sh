#!/bin/sh

# execute after installation and in chroot

# set hostname
echo "voidlollo" > /etc/hostname

# set options in /etc/rc.conf
cat << EOF >> /etc/rc.conf

HARDWARECLOCK="UTC"
KEYMAP="us"
TTYS=3
CGROUP_MODE=hybrid
EOF

# integrate alsa in pipewire
mkdir -p /etc/alsa/conf.d
ln -s /usr/share/alsa/alsa.conf.d/50-pipewire.conf /etc/alsa/conf.d
ln -s /usr/share/alsa/alsa.conf.d/99-pipewire-default.conf /etc/alsa/conf.d

# create brightness rule so video users can change brightness
mkdir -p /etc/udev/rules.d
echo "RUN+=\"/bin/chgrp video /sys/class/backlight/intel_backlight/brightness\"" > /etc/udev/rules.d/backlight.rules
echo "RUN+=\"/bin/chmod g+w /sys/class/backlight/intel_backlight/brightness\"" >> /etc/udev/rules.d/backlight.rules

# set swappiness value
mkdir -p /etc/sysctl.d
echo "vm.swappiness=30" > /etc/sysctl.d/99-swappiness.conf

# enable periodic trim with cron
mkdir -p /etc/cron.weekly
cat << EOF > /etc/cron.weekly/fstrim
#!/bin/sh

fstrim /
EOF
chmod u+x /etc/cron.weekly/fstrim

# Todo in chroot

# execute root_install.sh
./root_install.sh

# link doas to sudo (already done in root_install.sh)
#ln -s /usr/bin/doas /usr/bin/sudo

# set timezone
ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime

# link services
ln -s /etc/sv/dbus /etc/runit/runsvdir/default/
ln -s /etc/sv/iwd /etc/runit/runsvdir/default/
ln -s /etc/sv/bluetoothd /etc/runit/runsvdir/default/

# create swap file
dd if=/dev/zero of=/swapfile bs=1G count=4 status=progress
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

# create fstab file from the mounted system
cp /proc/mounts /etc/fstab

# modify /etc/fstab
# remove everything except /mnt and /mnt/boot
# set them to / and /boot 0 1 and 0 2
# use blkid to get UUID and set UUID= instead of path
# add /tmp in ram and /swapfile
# tmpfs /tmp tmpfs defaults,nosuid,nodev 0 0
# /swapfile none swap defaults 0 0

# set root password
#passwd

# create user
#useradd -m -G wheel,audio,video,input,bluetooth lollo
#passwd lollo

# edit /etc/default/grub (set GRUB_DISTRIBUTOR)

# install grub
#grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

# after changing /etc/default/grub run update-grub

# ensure all installed packages are configured properly
#xbps-reconfigure -fa

# exit chroot
#exit
# reboot with shutdown or normal
#shutdown -r now
#reboot