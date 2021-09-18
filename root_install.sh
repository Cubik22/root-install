#!/bin/sh

# get the current directory
root_install=$(pwd)

# adding global environment variables
cat "${root_install}"/environment >> /etc/environment

# setting locales
cat "${root_install}"/locale.conf > /etc/locale.conf

# grub config file generator
#cat "${root_install}"/grub > /etc/default/grub

mkdir -p /etc/iwd

# iwd config file
cp "${root_install}"/main.conf /etc/iwd/main.conf

# doas config file
cat "${root_install}"/doas.conf > /etc/doas.conf

chown -c root:root /etc/doas.conf
chmod -c 0400 /etc/doas.conf

ln -s "$(which doas)" /usr/bin/sudo
