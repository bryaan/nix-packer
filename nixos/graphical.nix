{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    layout = "us";

	# Gnome desktop
	# Gnome3 works out of the box with xmonad
	desktopManager = {
	  gnome3.enable = true;
      default = "gnome3";
	};

	# Enable XMonad Desktop Environment. (Optional)
	# windowManager = {
	#   xmonad.enable = true; 
	#   xmonad.enableContribAndExtras = true;
	# };

	# KDE Desktop
    # displayManager.kdm.enable = true;
    # desktopManager.kde4.enable = true;
  };

  environment.systemPackages = [ pkgs.glxinfo ];

  services.xserver.videoDrivers = [ "virtualbox" ];
}
