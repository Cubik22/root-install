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

# create fstab file from the mounted system
# in the chroot manually configure it
cp /proc/mounts /etc/fstab

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
