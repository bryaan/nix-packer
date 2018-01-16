{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    layout = "us";

	# Gnome desktop
	# Gnome3 works out of the box with xmonad
	# desktopManager = {
	#   gnome3.enable = true;
    #   default = "gnome3";
	# };
	desktopManager.gnome3.enable = true;
	displayManager.gdm.enable = true;
	libinput.enable = true; # What is this?

	# Auto-login
    # displayManager.gdm.autoLogin.enable = true;
    # displayManager.gdm.autoLogin.user = "vagrant";

	# Enable XMonad Desktop Environment. (Optional)
	# windowManager = {
	#   xmonad.enable = true; 
	#   xmonad.enableContribAndExtras = true;
	# };

	# KDE Desktop
    # desktopManager.kde4.enable = true;
    # displayManager.kdm.enable = true;
  };

  environment.systemPackages = [ pkgs.glxinfo ];

  services.xserver.videoDrivers = [ "virtualbox" ];
}
