{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.flatpak = {
    packages = [
      "us.zoom.Zoom"
      "com.microsoft.Edge"
    ];
  };
}
