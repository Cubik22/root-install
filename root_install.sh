#!/bin/sh

# get the current directory
root_install="$(pwd)"/files

# adding global environment variables
cat "${root_install}"/environment >> /etc/environment

# setting locales
cat "${root_install}"/locale.conf > /etc/locale.conf

# rc initialization file
cat "${root_install}"/rc.conf > /etc/rc.conf

# grub config file generator
cat "${root_install}"/grub > /etc/default/grub

# acpid handler
cat "${root_install}"/handler.sh > /etc/acpi/handler.sh

mkdir -p /etc/bash/bashrc.d

# bash completion script
cat "${root_install}"/bash_completion.sh > /etc/bash/bashrc.d/bash_completion.sh

# bash complete alias
cat "${root_install}"/complete_alias > /usr/share/bash-completion/complete_alias

mkdir -p /etc/iwd

# iwd config file
cp "${root_install}"/main.conf /etc/iwd/main.conf

# doas config file
cat "${root_install}"/doas.conf > /etc/doas.conf

chown -c root:root /etc/doas.conf
chmod -c 0400 /etc/doas.conf

ln -s "$(which doas)" /usr/bin/sudo
