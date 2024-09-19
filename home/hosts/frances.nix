{
  config,
  lib,
  pkgs,
  nix-colors,
  ...
}:
{
  #colorScheme = nix-colors.colorSchemes.catppuccin-mocha;
  colorScheme = import ../colors/catppuccin-mocha-custom.nix;
}
