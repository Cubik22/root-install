#!/bin/sh

root_drive="/dev/nvme0n1p5"
boot_drive="/dev/nvme0n1p1"

echo "y" | mkfs.ext4 $root_drive

mount $root_drive /mnt

mkdir /mnt/boot
mount $boot_drive /mnt/boot

lsblk
