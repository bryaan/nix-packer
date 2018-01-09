#!/bin/sh

# This file is called by a `provisioner` in packer-template.json
# when nixos-install has completed successfully.

set -e
set -x

# Upgrade.
nixos-rebuild switch --upgrade

# Cleanup any previous generations and delete old packages.
nix-collect-garbage -d

#################
# General cleanup
#################

# https://www.cammckenzie.com/blog/index.php/2013/12/06/cleanup-whitespace-on-partitions-before-compression/
# # TODO Zero free space to aid VM compression
# # For some reason this comes before below in link. not sure if it matters or works for NixOS on VBox.
# dd if=/dev/zero of=/EMPTY bs=1M
# rm -f /EMPTY

# Clear history
unset HISTFILE
if [ -f /root/.bash_history ]; then
  rm /root/.bash_history
fi
if [ -f /home/vagrant/.bash_history ]; then
  rm /home/vagrant/.bash_history
fi

# Clear temporary folder
rm -rf /tmp/*

# Truncate the logs.
# find /var/log -type f | while read f; do echo -ne '' > $f; done;


# TODO Zero the unused space.
# Just a quick tip to help reduce the size of compressed partitions; 
# particularly useful if imaging a drive for cloning etc. 
#
# Whiteout root
# count=`df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}'`
# let count--
# dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count;
# rm /tmp/whitespace;

# I got these from elsewhere so they may not apply for NixOS, but they prob do.

# # Whiteout /boot
# count=`df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}'`;
# let count--
# dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count;
# rm /boot/whitespace;

# # Whiteout swap
# swappart=`cat /proc/swaps | tail -n1 | awk -F ' ' '{print $1}'`
# swapoff $swappart;
# dd if=/dev/zero of=$swappart;
# mkswap $swappart;
# swapon $swappart;# Whiteout root
# count=`df --sync -kP / | tail -n1 | awk -F ' ' '{print $4}'`;
# let count--
# dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count;
# rm /tmp/whitespace;

