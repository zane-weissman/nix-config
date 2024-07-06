{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # enable wayland and sddm
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.desktopManager.plasma6 = {
    enable = true;
  };
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
    elisa
    kate
  ];
}
