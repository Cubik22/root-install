#!/bin/sh

# get the current directory
root_install="$(pwd)"/files

# adding global environment variables
cat "${root_install}"/environment >> /etc/

# setting locales
cat "${root_install}"/locale.conf > /etc/

# rc initialization file
cat "${root_install}"/rc.conf > /etc/

# grub config file generator
cat "${root_install}"/grub > /etc/default/

# acpid handler
cat "${root_install}"/handler.sh > /etc/acpi/

mkdir -p /etc/bash/bashrc.d

# bash completion script
cat "${root_install}"/bash_completion.sh > /etc/bash/bashrc.d/

# bash complete alias
cat "${root_install}"/complete_alias > /usr/share/bash-completion/

mkdir -p /etc/iwd

# iwd config file
cp "${root_install}"/main.conf /etc/iwd/main.conf

# doas config file
cat "${root_install}"/doas.conf > /etc/doas.conf

chown -c root:root /etc/doas.conf
chmod -c 0400 /etc/doas.conf

ln -s "$(which doas)" /usr/bin/sudo
