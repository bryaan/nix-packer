# set -e
# Could it be nix can actually continue past errors somehow?
# TODO check if there is a setting for install-nixos

# Get all avaialable disk space.
B_TO_MB="1024"  #"1048576"
# DISK_SIZE=$(fdisk -l | grep ^Disk | grep -v loop | awk -F" "  '{ print $5 }' | head -n 1)
# DISK_SIZE=$(($DISK_SIZE / $B_TO_MB))
# TODO Getting 4048 for size set to 50000???

DISK_SIZE=50000
SWAP=45000

# Calc Prmary Partition Size
# TODO Take abs value
PRIMARY_SIZE=$(($DISK_SIZE - $SWAP))

# echo "GRAPHICAL: $GRAPHICAL"
# echo "DISK_SIZE: $DISK_SIZE"
# echo "PRIMARY_SIZE: $PRIMARY_SIZE"
# echo "SWAP: $SWAP"

# sleep 10

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
	  p # print the in-memory partition table
	  w # write the partition table
	  q # and we're done # might not need this in nixos
	EOF

  sleep 30

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
# # TODO Check that this is being set by packer config.
# if [ -z "$GRAPHICAL" ]; then
#   # Makes it a text env.
#   sed -i 's/graphical\.nix/text.nix/' /mnt/etc/nixos/configuration.nix
# fi

### Install ###
nixos-install

### Reboot ###
reboot -f


