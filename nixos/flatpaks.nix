{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.flatpak = {
    packages = [ "com.microsoft.Edge" ];
  };
}
