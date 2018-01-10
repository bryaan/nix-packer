# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Use a suitable NixOS base
  config.vm.box = "nixos-17.09-x86_64"
  config.vm.box_url = "file:///Users/bryan/src/nixos/test.box"
  # config.vm.box         = "cstrahan/nixos-14.04-x86_64"
  # config.vm.box_version = "~> 0.1.0"

  # Setup networking
  config.vm.hostname = "nixy"
  config.vm.network "private_network", :ip => "172.16.16.16"

  # Use host keys to SSH to VM
  config.ssh.forward_agent = true

  # Don't need this since using packer?
  # TODO needs to be right directory for nixos.  prob just config sshd with nix config.
  # config.vm.provision "file", source: "keys/public", destination: "~/.ssh/authorized_keys"

  # Add NixOS config
  # config.vm.provision :nixos, :path => “configuration.nix”
 #  config.vm.provision :nixos, :expression => {
 #    environment: {
	#   systemPackages: [ :htop ]
	# }
 #  }

  # TODO Setup SWAP, visit git home for config

  config.vm.provider "virtualbox" do |v|
	v.memory = 4000
	v.gui = false
  end

end
