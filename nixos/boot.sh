# set -e

export HTTP_IP=$H
export HTTP_PORT=$P
export DISK_SIZE=$D
[[ -v S ]] && export SWAP=$S # Optional [TODO impl option]
export NIXOS_CHANNEL=$C

# Get all avaialable disk space.
# B_TO_MB="1024"  #"1048576"
# DISK_SIZE=$(fdisk -l | grep ^Disk | grep -v loop | awk -F" "  '{ print $5 }' | head -n 1)
# # DISK_SIZE=$(($DISK_SIZE / $B_TO_MB))

# DISK_SIZE=81920
# SWAP=2000

# Calc Prmary Partition Size
PRIMARY_SIZE=$(($DISK_SIZE - $SWAP))

# This screws up the typing sewunce for some reason?  But that comes before?
# echo "GRAPHICAL: $GRAPHICAL"
# echo "DISK_SIZE: $DISK_SIZE"
# echo "PRIMARY_SIZE: $PRIMARY_SIZE"
# echo "SWAP: $SWAP"
# echo ''

# sleep 10
# echo ''

# Create partitions
# if [ -z "$SWAP" ]; then
	#   echo "n
	# p
	# 1
	#
	#
	# a
	# w
	# " | fdisk /dev/sda

# sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/sda
#   o # clear the in memory partition table
#   n # new partition
#   p # primary partition
#   1 # partition number 1
#     # default - start at beginning of disk
#     # default, extend partition to end of disk
#   a # make a partition bootable
#   p # print the in-memory partition table
#   w # write the partition table
#   q # and we're done # might not need this in nixos
# EOF

# else

# Looks like it needs to not be tabbed in more than 2 spaces. TODO Try just the EOF
# The sed script strips off all the comments so that we can
# document what we're doing in-line with the actual commands
# Note that a blank line (commented as "defualt" will send a empty
# line terminated with a newline to take the fdisk default.
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/sda
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk
  +${PRIMARY_SIZE}M # PRIMARY_SIZE MB boot parttion
  n # new partition
  p # primary partition
  2 # partion number 2
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  a # make a partition bootable
  1 # partition number 1
  p # print the in-memory partition table
  w # write the partition table
  # q # and we're done # might not need this in nixos
EOF

  # sleep 15

  mkswap -L swap /dev/sda2
  swapon /dev/sda2
# fi

# Create filesystem
mkfs.ext4 -j -L nixos /dev/sda1

# Mount filesystem
mount LABEL=nixos /mnt

# Generate hardware config
nixos-generate-config --root /mnt

### Download configuration ###
curl http://$HTTP_IP:$HTTP_PORT/configuration.nix > /mnt/etc/nixos/configuration.nix
curl http://$HTTP_IP:$HTTP_PORT/guest.nix > /mnt/etc/nixos/guest.nix
curl http://$HTTP_IP:$HTTP_PORT/graphical.nix > /mnt/etc/nixos/graphical.nix
curl http://$HTTP_IP:$HTTP_PORT/text.nix > /mnt/etc/nixos/text.nix
curl http://$HTTP_IP:$HTTP_PORT/users.nix > /mnt/etc/nixos/users.nix
curl http://$HTTP_IP:$HTTP_PORT/vagrant-hostname.nix > /mnt/etc/nixos/vagrant-hostname.nix
curl http://$HTTP_IP:$HTTP_PORT/vagrant-network.nix > /mnt/etc/nixos/vagrant-network.nix
curl http://$HTTP_IP:$HTTP_PORT/vagrant.nix > /mnt/etc/nixos/vagrant.nix

mkdir -p /mnt/etc/nixos/misc
curl http://$HTTP_IP:$HTTP_PORT/misc/ssh-keys.nix > /mnt/etc/nixos/misc/ssh-keys.nix

# TODO Just copy the whole directory over?
# Copy All
# curl --create-dirs http://$HTTP_IP:$HTTP_PORT/ > /mnt/etc/nixos/


# # TODO This should be done in a more elegant manner.  Why not look
# # at Graphical envvar in .nix files?
# # TODO Check that this is being set by packer config. Its not being set as env var.
# if [ -z "$GRAPHICAL" ]; then
#   # Makes it a text env.
  sed -i 's/graphical\.nix/text.nix/' /mnt/etc/nixos/configuration.nix
# fi

### Install ###
# Jobs may be improving single file download speed.
nixos-install \
  --max-jobs 20 \
  --cores 0  \
  --show-trace
  # --option fallback true \
  # --option keep-going true \
  # --option build-fallback true


# # TODO see if this works to move typing vars in packer to pulling them here:
# DISK_SIZE=$(cat .disk_size)
# SWAP_SIZE=$(cat .swap_size)


### Cleanup ###
# TODO The chroot may wall allow the scritpt to work with /etc instead of /mnt/etc
# curl "http://$HTTP_IP:$HTTP_PORT/misc/post-install.sh" | nixos-install --chroot
curl http://$HTTP_IP:$HTTP_PORT/misc/post-install.sh > /mnt/etc/nixos/misc/post-install.sh

# chmod +x
# sh /mnt/etc/nixos/misc/post-install.sh
cat /mnt/etc/nixos/misc/post-install.sh | nixos-install --chroot

# 8103 10.1.2.2 or 10.0.2.2

# "provisioners": [
#   {
#     "type": "shell",
#     "execute_command": "chmod +x {{.Path}}; sudo sh {{.Path}}",
#     "script": "install-scripts/post-install.sh"
#   }
# ],

### Reboot ###
# reboot

# Cant start sshd without reboot, bc we are still in the
# iso/build config, not our target config.

# Seems if we reboot that postinstall.sh will never run.


# TODO When in text mode, without either of these it does not finish without manual reboot.
# reboot
# systemctl start sshd




