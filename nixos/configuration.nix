{ config, pkgs, ... }:

let
  inherit (pkgs) lib;
  inherit (builtins) hasAttr;
in {

  # ** If importing a file here make sure it gets copied in
  # nixos/configuration.nix
  # TODO See if we can inject that from here.
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
   binary-caches-parallel-connections = 50
   connect-timeout = 5
  '';


  # TODO Think we need to generate keys first
  # https://unix.stackexchange.com/questions/295947/local-nix-cache-is-ignored-because-nar-info-file-lacks-a-signature
  nix.binaryCaches = [
    https://cache.nixos.org/
    https://hydra.nixos.org/
  ];
  nix.trustedBinaryCaches = [ http://127.0.0.1:8080/ ];
  # nix.binaryCachePublicKeys = [ "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" ];
  # nix.requireSignedBinaryCaches = false;


  # nix.gc.automatic = true;
  # nix.gc.dates = "monthly";
  # nix.gc.options = "--delete-older-than 90d";
  # nix.optimise.automatic = true;
  # # FIXME nix.optimise.dates = "weekly";

# Make sure this is just a time client not server.
# services.ntp.enable = true

  # Packages for Vagrant
  # TODO Move the Vagrant group of packges into their own key.
  # Import key here, should be able to have duplcates specified w/o issue.
  environment.systemPackages = with pkgs; [
    findutils
    gnumake
    iputils
    jq
    nettools
    netcat
    nfs-utils
    rsync
  ]
  ++ lib.optionals (hasAttr "biosdevname" pkgs) [pkgs.biosdevname]; # Vagrant plugin support.
}
