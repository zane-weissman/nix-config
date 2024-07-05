{
  config,
  lib,
  pkgs,
  nix-colors,
  ...
}:

{
  imports = [ nix-colors.homeManagerModules.default ];

  #colorScheme = nix-colors.colorSchemes.papercolor-dark;
  colorScheme = import ./green;

  programs =
    let
    in
    #c = hex: ("${config.colorScheme.palette.base " + hex + "}");
    {
      alacritty.settings.colors = with config.colorScheme.palette; {
        primary = {
          background = "0x${base00}";
          foreground = "0x${base07}";
        };
        normal = {
          black = "0x${base00}";
          red = "0x${base01}";
          green = "0x${base02}";
          yellow = "0x${base03}";
          blue = "0x${base04}";
          magenta = "0x${base05}";
          cyan = "0x${base06}";
          white = "0x${base07}";
        };
        bright = {
          black = "0x${base08}";
          red = "0x${base09}";
          green = "0x${base0A}";
          yellow = "0x${base0B}";
          blue = "0x${base0C}";
          magenta = "0x${base0D}";
          cyan = "0x${base0E}";
          white = "0x${base0F}";
        };
        footer_bar = {
          background = "0x${base01}";
          foreground = "0x${base08}";
        };
        #line_indicator = { }
        #hints = { };
      };
    };
}
