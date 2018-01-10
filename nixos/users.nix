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
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCapukQPQaIMayUN4ngIjesHf/oOpynpWEacp5Ovq3qXdhSg9OL60HuH6js5TfVVGKW5fQjkzah0TAFmeHCxOnfnKpRJjT64H9n58WE75nxS5OhE7MQYvnp3NMjmSS/PN+6kIDw5dQx0CcjyiNWpNaebtH+FkyG4VKvBTREuPjwzEFu5rlX9g050UsO2n3SRyDtTM1bG7UORihVuUEr5XgTOrGiFquVeiJVs3Fo7EKSha/KapI0hklfh7kqgcWPPxOiD+Sxd/SymTcMigwSMeWarguxaQP9IAWV1HSua1PhpFx7A9JhEFNwpaFDK9ajzhQ4HEQ2Z1rLLvo0l6YcsGBPntZr3fBx8ZNtMOXcyoE2bpqfSFY+H5PO+bXODH7e2/8Kyxa+1L66yDP3F928X5RCWFZ84A1ABVwz2aKFOA4CyaQL/B6cIqkHb3x9rAxickehSkcFiDOFotQbAB0I8Cyh5f8D69gzDGDZ7DALs3bguhtxnrr2a56OEbxU/+9LkO1uoHd+tSPdDOOsfdWz1yuoTKgULxKKW6RoLlzBV+iwMDaeK6RU5pAGNzVl/7WOQsE0rmOSS9KYlO3q/YO3wnvZZGIxlsAk0nows17kB2HqZigJ+RIKN/AR+RrCNcc8fkGQRqRzuTdOgYZOrXdCzkSCtjdhEtCjw8zcMBBS4MO+fQ== bryan@Bryans-Air"
        ];
      }
    ];
  };

  # TODO I think this should be specified per user.
  # Instead of globally.
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
