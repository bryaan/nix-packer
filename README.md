# About

This is a [Packer](http://packer.io) definition for [NixOS](http://nixos.org). It builds a [Vagrant](http://www.vagrantup.com/) box for various NixOS versions.

# Resources

[NixOS Config Options](https://nixos.org/nixos/manual/options.html)

[NixOS SSHd Config](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/networking/ssh/sshd.nix)

[Nix Networking Config](https://github.com/NixOS/nixos/blob/master/modules/tasks/network-interfaces.nix)

[Vagrant Settings](https://www.vagrantup.com/docs/vagrantfile/machine_settings.html)

[NixOS ISOs](https://nixos.org/channels/)

# Setup

### Create SSH Keys

```bash
ssh-keygen -t rsa -b 4096
~/.ssh/id_vagrant
no password
```

If you want to specify another file change `ssh_private_key_file` in `packer-template.json`, and also the key in `Vagrantfile`.


# Compile Packer Templates

```bash
./misc/render_template.rb
```

# Build Image

```bash
PACKER_LOG=1 packer build packer_builds/nixos-18.03-x86_64.json

Build Stable:
$ sh ./build-stable.sh    \
    -var 'cpus=2'         \
    -var 'swap_size=2000'
```

# Usage

Change NixOS version in Vargrantfile.

```bash
$ packer build packer_builds/nixos-17.09-x86_64.json

$ vagrant up / ssh / halt / destroy
```


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


# Common Commands

Search for packages
nix-env -qaP | grep python3-3

List all installed packages
nix-env -q

nix-env -i python3-3.3.3
But may have multiple by same name having diff features
Then use (A)ttribute value
nix-env -iA nixpkgs.python3

Update packge and dependencies
nix-env -uA nixpkgs.python3

Update all installed
nix-env -u

Remove package
nix-env -e python3-3.3.3

Update binary channel (like repo update?)
nix-channel --update

Removed packages only remove symlinks, to delete data run
nix-collect-garbage

After any nix config changes run to rebuild:
$ nixos-rebuild switch

Useful to make simple configuration changes in NixOS (ex.: network related), when no network connectivity is available:
nixos-rebuild switch --option binary-caches ""


How can I install a proprietary or unfree package?
https://nixos.wiki/wiki/FAQ


With nix, only applications should be installed into profiles. Libraries are used using nix-shell.
So we use nix-shell to create a sandbox dev env with those libs available to compiler.
https://nixos.wiki/wiki/FAQ

How to keep build-time dependencies around / be able to rebuild while being offline?
https://nixos.wiki/wiki/FAQ



TODO Why not use nix-env -i foo?
`nix-env -i foo` is slower and tends to be less precise than `nix-env -f '<nixpkgs>' -iA foo`. This is because it will evaluate all of nixpkgs searching for packages with the name foo, and install the one determined to be the latest (which may not even be the one that you want). Meanwhile, with -A, nix-env will evaluate only the given attribute in nixpkgs. This will be significantly faster, consume significantly less memory, and more likely to get you what you want.


# Serve Nix Store and Serve Nix Cache
https://nixos.org/nix/manual/#sec-sharing-packages

For example, to
mirror the current 16.09-small release:
nix copy -r --store https://cache.nixos.org/ --to file:///tmp/my-mirror \
    $(curl -L https://nixos.org/channels/nixos-16.09-small/store-paths.xz | xz -d)

# Allowing nonroot users to install packages
https://nixos.org/nix/manual/#ssec-multi-user


---------------------------------------------------------------
---------------------------------------------------------------


TODO diabled sshd

TODO Maybe the provison script is failing due to unknown .Path !!!!
bc it didnt work in the main boot body.
Figure out where file is at, and send.
Actually what should be happening is on SSH, packer SCPs the file over.
Thats is why it fills the path in then, not at boot.
So maybe it was silently failing in past, but is running.

TODO fixed everything that should be, check if vagrant up gives us destop enabled nix


Disable sshd in guest.nix so packer doesnt connect and we can try running reboot and script manually.

After install finished:
reboot

Then login and:
sudo sed -i 's/text\.nix/graphical.nix/' /etc/nixos/configuration.nix
sudo nixos-rebuild switch
sudo systemctl start display-manager

Now do one final reboot or gnome will logout after login:
reboot

WORKING !!!!!!!!!!!!!!
WORKING !!!!!!!!!!!!!!
WORKING !!!!!!!!!!!!!!
WORKING !!!!!!!!!!!!!!

culd always loginto vagrant after and tht stuff..  via script.

TODO enable sshd by modifying config.  reboot system. packer should finish connecting and build image.

TODO copy post-isntall over to nixos


TODO possibility of creating a func that checks error code of previous cmd and reruns if necc.  use for packer input stuff.


$ systemctl start sshd
$ systemctl start display-manager

---------------------------------------------------------------

TODO Move to isos.json

nixos-minimal-18.03pre125273.e30ecaa916f-x86_64-linux.iso
497f8fb87422ef0d4ebdd2d7d38cacbaf4b932fbd4c9028666819cbe471a9572

nixos-graphical-18.03pre125130.3a763b91963-x86_64-linux.iso
d6af0443c6f16e08ed26a8d119f8e62c19801aec0e643568914f8a2dc6b8c9b4

OVA Image:
nixos-18.03pre125130.3a763b91963-x86_64-linux.ova
12074bfd0dcfd62bc75c4e450b0e8441aad7cb85ed18d5a76175fa227934ec3a


builds a vbox image using raw vboxmanage commands.  could adapt to packer.
also doesnt use nixos-install
https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/virtualbox-image.nix
https://www.johbo.com/2017/building-a-nixos-image-for-virtualbox.html

!! Indeed nix-ops is a tool to setup nix on vms.  maybe it would help a lot here.


TODO SMART Disk Health Daemon
https://github.com/bjornfor/nixos-config/blob/master/cfg/smart-daemon.nix
- Also find equivalent if otherwise for SSDs

TODO nix-repl

[solved] Test that if the local cache is down that build will still work.
It does work.

TODO Make work with no SWAP



binary-caches = http://nixos.org/binary-cache
--option binary-caches http://hydra.nixos.org

--keep-going

nix-store --verify --check-contents --repair
  --option fallback true



nix-build
  --option connect-timeout N
  --fallback -vvv -K



What we can do is build with keepgoing, then rebuild system until it works, or actually buld from source? ohhh nvm, if we use build thefallback should work right.



nix-env has options: --cores --max-jobs for parrallel; read man
--dry-run -v

 --option use-binary-caches false to nixos-rebuild or nix-env?
Have you tried adding use-binary-caches to nix.extraOptions?
--option build-use-substitutes false on the command line, is the option to disable binary caches.

TODO request info using nix-env on python package, maybe lookup source, to verify that the data is at least network accessible, otherwise is could be bc its not getting package instead of running out of mem, or mem could be mac mem problem.

 nix-store --realize https://cache.nixos.org/0cwxmyjyh1cr3xss6dqsrpmhcmwk89p4zkr59jpds1171z52k8p8.nar.xz




nix search --name foo



TODO It could be my machine running out of swap, look at glances.
Im getting the Python depen fetch fail

TODO look into nix-repl

TODO uncoomment fix GRAPHICAL in boot.sh
maybe env vars can be passed as packer build cmd args

TODO could be the ssh daemon iss sometimes coming too quick so it start typing
bootwit flag in  packer config?
maybe what we do is check system uptime, if it has been more than bootwait time
TODO ssh fail could be bc username dont match but unliely as in orignal repo its diff

TODO Root account has no password set.  Double check this isnt a problem.
Or if we should set to tough random throw away pass.

TODO replace username and `ssh_username` in packer-template.json with variable.

TODO Zero the unused space In postinstall.sh
Check this is ok to do with virtual box.  i think it is look at comments in file. its about image compression.

TODO reduce time spent enetering vars packer boot
env H={{ .HTTPIP }} P={{ .HTTPPort }} S={{ user `swap_size` }} C={{ user `nixos_channel` }}
curl http://$H:$P/boot.sh -s > boot.sh
sh boot.sh<enter><wait>


TODO NixOS Parrallel download, also cache setup
Oh and look into setting up a network cache on wifi router machine build

TODO So run sshd in verbose or enable logging or both
!!!!!!!!!  /nix/.rw-store which is a tmpfs of 2.1G is at 100% this is prob it.


swapon reveals only 788kb of usage.

nixops ssh machine

https://github.com/zefhemel/nixops-mac-setup/blob/master/install-nix.sh

TODO On CLASS and KMachines
https://nixos.org/nixos/manual/options.html#opt-power.ups.enable









-------------------

Evaluate approaches

  "provisioners": [
    {
      "type": "shell",
      "inline": [
        "mkdir -p /home/mjhoy/.ssh",
        "chown -R mjhoy:users /home/mjhoy/.ssh"
      ]
    },
    {
      "type": "file",
      "source": "/Users/mjhoy/.ssh/id_rsa_mjhoy_4096",
      "destination": "/home/mjhoy/.ssh/id_rsa_mjhoy_4096"
    },
    {
      "type": "file",
      "source": "/Users/mjhoy/.ssh/id_rsa_mjhoy_4096.pub",
      "destination": "/home/mjhoy/.ssh/id_rsa_mjhoy_4096.pub"
    },
    {
      "type": "shell",
      "inline": [
        "chmod 600 /home/mjhoy/.ssh/id_rsa_mjhoy_4096",
        "chown mjhoy:users /home/mjhoy/.ssh/id_rsa_mjhoy_4096",
        "chown mjhoy:users /home/mjhoy/.ssh/id_rsa_mjhoy_4096.pub"
      ]
    },
    {
      "type": "shell",
      "script": "postinstall.sh"
    }
  ]