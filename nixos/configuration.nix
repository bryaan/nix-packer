{ config, pkgs, ... }:

let
  inherit (pkgs) lib;
  inherit (builtins) hasAttr;
in {

  # ** If adding a file here make sure it gets copied in 
  # nixos/configuration.nix  TODO See if we can inject that from here.
  imports = [ 
    # Include the results of the hardware scan.
    ./hardware-configuration.nix 
    ./graphical.nix
    ./guest.nix
    ./users.nix
    ./vagrant.nix
    ./vagrant-network.nix
    ./vagrant-hostname.nix
  ];

  nix.useSandbox = true;

  # Try to improve nix pkg download time.
  nix.extraOptions = ''
   binary-caches-parallel-connections = 5
   connect-timeout = 5
  '';

  # # Packages for Vagrant
  # It is auto-append as evidenced by graphical .nix TODO remove me
  # environment.systemPackages = with pkgs; [
  #   findutils
  #   gnumake
  #   iputils
  #   jq
  #   nettools
  #   netcat
  #   nfs-utils
  #   rsync
  # ];


  environment.systemPackages =
    [ ]
    ++ lib.optionals (hasAttr "biosdevname" pkgs) [pkgs.biosdevname]; # Vagrant plugin support.
}
