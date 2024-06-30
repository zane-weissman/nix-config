{
  config,
  lib,
  pkgs,
  ...
}:

### FUNCTIONS #####
{

  imports = [
    ./cli
    ./desktop
  ];

  config = {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.

    targets.genericLinux.enable = true;

    # Let Home Manager install and manage itself.
    programs.home-manager = {
      enable = true;
      #backupFileExtension = "backup";
    };

    home.packages = with pkgs; [ just ];
  };
}
