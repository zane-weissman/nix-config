{
  config,
  lib,
  pkgs,
  nix-colors,
  ...
}:

### FUNCTIONS #####
{

  imports = [ ./cli ];

  config = {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    home = {
      username = "zane";
      homeDirectory = "/home/zane";
      stateVersion = "23.11"; # Please read the comment before changing.
    };

    targets.genericLinux.enable = true;

    # Let Home Manager install and manage itself.
    programs.home-manager = {
      enable = true;
      path = lib.mkForce "${config.home.homeDirectory}/nix-config";
      #backupFileExtension = "backup";
    };

    home.packages = with pkgs; [
      just
      nixfmt
    ];
  };
}
