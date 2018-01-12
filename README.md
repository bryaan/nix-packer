# About

This is a [Packer](http://packer.io) definition for [NixOS](http://nixos.org). It builds a [Vagrant](http://www.vagrantup.com/) box for various NixOS versions.

You will need to add:
  /usr/local/bin/fish
to /etc/shells.

Then run:
  chsh -s /usr/local/bin/fish
to make fish your default shell.


# TODO Could be bc ssh_private_key in packer-template is actually the key 
to use to connect to the machine. ie the key specified in its authd_keys
https://github.com/hashicorp/packer/blob/master/builder/googlecompute/step_create_ssh_key.go
Nvm according to that it is for the instance.


# So run sshd in verbose or enable logging or both


# Resources

[NixOS Config Options](https://nixos.org/nixos/manual/options.html)

[NixOS SSHd Config](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/networking/ssh/sshd.nix)

[Nix Networking Config](https://github.com/NixOS/nixos/blob/master/modules/tasks/network-interfaces.nix)

[Vagrant Settings](https://www.vagrantup.com/docs/vagrantfile/machine_settings.html)

[NixOS ISOs](https://nixos.org/channels/)

# Setup

### Create SSH Keys

```
ssh-keygen -t rsa -b 4096
id_vagrant
no password
```

If you want to specify another file change `ssh_private_key_file` in `packer-template.json`, and also the key in `Vagrantfile`.

# Build Templates

```bash
./build-stable.sh
```

# Build Image

```bash
PACKER_LOG=1 packer build packer_builds/nixos-18.03-x86_64.json
```

# Usage

Change NixOS version in Vargrantfile.

```
$ packer build packer_builds/nixos-17.09-x86_64.json

$ vagrant up / ssh / halt / destroy
```

$ systemctl start display-manager


TODO change disk_size to primary size?

TODO Root account has no password set.  Double check this isnt a problem.
Or if we should set to tough random throw away pass.

TODO replace `ssh_username` in packer-template.json with variable.


TODO Setup SWAP in packer, visit git home for config


The size we are using is just way too big, no way it could be without seriously massive compression which i just dont see happening. So something is up with disk.
1. its not actually formatting the entire disk.  should be able to see this by doing the working version.
2. Could be that one of the plugins isnt properly handling the setting, but i dont think they matter. 
Just try getting into machine and examiningin disks.

df -H  clearly shows no disk space issues, unless its trying to write to readonly space, or rather /nix/store which i dont think should be readonly.

!!!!!!!!!  /nix/.rw-store which is a tmpfs of 2.1G is at 100% this is prob it.


nixops ssh machine

https://github.com/zefhemel/nixops-mac-setup/blob/master/install-nix.sh


TODO On CLASS and KMachines
https://nixos.org/nixos/manual/options.html#opt-power.ups.enable


TODO Root account has empty password

# Building

If you want to customize the box, there are a couple
[variables](http://www.packer.io/docs/templates/user-variables.html) you can
pass to Packer:

* `swap_size` - The size of the swap partition in megabytes. If this is empty (the
  default), no swap partition is created.
* `disk_size` - The total size of the hard disk in megabytes (defaults
  to 2000).
* `graphical` - Set this to true to get a graphical desktop

There are also a couple of variables that only affect the virtual-box build:

* `memmory_size` - The amount of RAM in megabytes (defaults to 1024).
* `cpus` - The number of CPUs (defaults to 1).

Example:

``` bash
$ sh ./build-stable.sh    \
    -var 'cpus=2'         \
    -var 'swap_size=2000'
```
