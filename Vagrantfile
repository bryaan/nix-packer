# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Use a suitable NixOS base
  config.vm.box = "nixos-18.03-x86_64"
  config.vm.box_url = "file://nixos-18.03-x86_64-virtualbox.box"

  # Setup networking
  config.vm.hostname = "nixy"
  config.vm.network "private_network", :ip => "172.16.16.16"

  # Use host keys to SSH to VM
  config.ssh.forward_agent = true
  config.ssh.private_key_path = "~/.ssh/id_vagrant"

  config.vm.provider "virtualbox" do |v|
  	v.memory = 4000
  	v.gui = false
  end

end
