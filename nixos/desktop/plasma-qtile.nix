{
  config,
  lib,
  pkgs,
}:
{
  imports = [ ]; # todo - import plasma6
  enviornment.systemPackages = with pkgs; [ qtile ];
  services.displayManager.sessionPackages = [
    (pkgs.writeTextDir "share/wayland-sessions/plasma-qtile.desktop" ''
      [Desktop Entry]
      Exec=env KDEWM=${pkgs.qtile}/bin/qtile ${pkgs.kde}/bin/startplasma-wayland
      DesktopNames=KDE
      Name=Plasma with qtile
      Comment=Plasma with qtile
    '')
  ];
}
