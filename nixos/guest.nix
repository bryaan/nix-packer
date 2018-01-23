{ config, pkgs, ... }:

{
  # Enable guest additions.
  virtualisation.virtualbox.guest.enable = true;

  # # Use the GRUB 2 boot loader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # boot.loader.grub.device = "/dev/sda";

  # Boot settings.
  boot = {
    initrd = {
      # Disable journaling check on boot because virtualbox doesn't need it
      checkJournalingFS = false;
      # Make it pretty
      kernelModules = [ "fbcon" ];
    };

    # Use the GRUB 2 boot loader.
    loader.grub = {
      enable = true;
      version = 2;
      # Drive to install GRUB on.
      device = "/dev/sda";
    };
  };

  # For now this is handled by Vagrantfile and vagrant-nixos plugin.
  # Enable networking.
  # networking = {
  #   hostName = "mycomputer"; # Define your hostname.
  #   hostId = # (use whatever was generated)
  #   # wireless.enable = true;  # not needed with virtualbox
  # };

  # Enable the OpenSSH daemon.
  # TODO Might want a seperate openssh user? Actually who is it running under?
  services.openssh = {
	enable = true;
    permitRootLogin = "no";
    ports = [ 22 ];
	passwordAuthentication = false;
	# TODO Seem to need this for packer build to work.
	# Should be off in production, or on bare metal.
	challengeResponseAuthentication = true;
	hostKeys = [
	  { type = "rsa"; bits = 4096; path = "/etc/ssh/ssh_host_rsa_key"; }
	];
	# extraConfig = ''
	#   AllowUsers vagrant
	# '';
  };

  # Enable DBus
  # services.dbus.enable    = true;

  # Replace nptd by timesyncd
  # services.timesyncd.enable = true;

}
