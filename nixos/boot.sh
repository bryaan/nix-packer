set -e
set -x

# Assuming a single disk (/dev/sda).
# TODO Check: I Beleive this uses all avaialable disk space.
MB="1048576"
DISK_SIZE=$(fdisk -l | grep ^Disk | grep -v loop | awk -F" "  '{ print $5 }' | head -n 1)
DISK_SIZE=$(($DISK_SIZE / $MB))

printf "GRAPHICAL: $GRAPHICAL\n"
printf "DISK_SIZE: $DISK_SIZE\n"

# Create partitions.
if [ -z "$SWAP" ]; then
  echo "n
p
1


a
w
" | fdisk /dev/sda
else
  PRIMARY_SIZE=$(($DISK_SIZE - $SWAP))
  echo "n
p
1

+${PRIMARY_SIZE}M
a
n
p
2


w
" | fdisk /dev/sda
  mkswap -L swap /dev/sda2
  swapon /dev/sda2
fi

# Create filesystem
mkfs.ext4 -j -L nixos /dev/sda1

# Mount filesystem
mount LABEL=nixos /mnt

# Generate hardware config.
nixos-generate-config --root /mnt

### Download configuration ###
# TODO Just copy the whole directory over?
curl http://$HTTP_IP:$HTTP_PORT/configuration.nix > /mnt/etc/nixos/configuration.nix
curl http://$HTTP_IP:$HTTP_PORT/guest.nix > /mnt/etc/nixos/guest.nix
curl http://$HTTP_IP:$HTTP_PORT/graphical.nix > /mnt/etc/nixos/graphical.nix
curl http://$HTTP_IP:$HTTP_PORT/text.nix > /mnt/etc/nixos/text.nix
curl http://$HTTP_IP:$HTTP_PORT/users.nix > /mnt/etc/nixos/users.nix
curl http://$HTTP_IP:$HTTP_PORT/vagrant-hostname.nix > /mnt/etc/nixos/vagrant-hostname.nix
curl http://$HTTP_IP:$HTTP_PORT/vagrant-network.nix > /mnt/etc/nixos/vagrant-network.nix
curl http://$HTTP_IP:$HTTP_PORT/vagrant.nix > /mnt/etc/nixos/vagrant.nix

# mkdir -p /mnt/etc/nixos/misc
curl --create-dirs http://$HTTP_IP:$HTTP_PORT/misc/ssh-keys.nix > /mnt/etc/nixos/misc/ssh-keys.nix

# # TODO This should be done in a more elegant manner.  Why not look
# # at Graphical envvar in .nix files?
# # TODO Check that this is being set by packer config.
# if [ -z "$GRAPHICAL" ]; then
  # Makes it a text env.
  sed -i 's/graphical\.nix/text.nix/' /mnt/etc/nixos/configuration.nix
# fi

### Install ###
nixos-install 

### Reboot ###
reboot -f
