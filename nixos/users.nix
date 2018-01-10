{ config, pkgs, ... }:

{

  # Creates a "vagrant" user with password-less sudo access.
  users = {
    # Disable mutable users so we don't get prompted for password at install time
    mutableUsers = false;

    extraGroups = [ 
      { name = "vagrant"; } 
      { name = "vboxsf"; } 
    ];
    extraUsers  = [
      {
        description     = "Vagrant User";
        name            = "vagrant";  
        group           = "vagrant";
        extraGroups     = [ "users" "vboxsf" "wheel" ];
        password        = "vagrant";
        home            = "/home/vagrant";
        createHome      = true;
        # isSystemUser    = false; # What is this?
        useDefaultShell = true;
        shell = pkgs.bash;
        openssh.authorizedKeys.keys = with import misc/ssh-keys.nix; [
          macair
        ];
      }
    ];
  };

  # TODO Specify per user or global? global by default is ok.
  # https://github.com/NixOS/nixos/blob/master/modules/programs/bash/bash.nix
  # programs.bash = {
  #   # environment.etc."bashrc".source = "./bashrc";
  # };
  # users.extraUsers.adisbladis = {
  #    shell = pkgs.fish;
  #  };

  # TODO Is this sane?
  security.sudo.wheelNeedsPassword = false;
  security.sudo.configFile = ''
    Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
    Defaults:root,%wheel env_keep+=NIX_PATH
    Defaults:root,%wheel env_keep+=TERMINFO_DIRS
    Defaults env_keep+=SSH_AUTH_SOCK
    Defaults lecture = never
    root   ALL=(ALL) SETENV: ALL
    %wheel ALL=(ALL) NOPASSWD: ALL, SETENV: ALL
  '';
}
