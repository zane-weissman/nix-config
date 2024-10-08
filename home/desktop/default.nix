{
  config,
  lib,
  pkgs,
  ...
}:

let
  myFuncs = import ../../lib/src.nix;
in
{
  imports = [
    ../colors
    ./alacritty.nix
    ./qtile
    ./i3
    ./sxhkd.nix
  ];
  options =
    let
      inherit (lib) mkOption types;
    in
    {
      font = mkOption { type = types.attrsOf types.anything; };
    };

  config = {

    # file symlinks
    home.file = {
      ".local/share/fonts".source = ./fontconfig/fonts;
    };

    # no longer writing to .config/fontconfig/fonts.conf
    #  {
    #    "fontconfig/fonts.conf".text = ''
    #      <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    #      <fontconfig>
    #        <dir prefix="relative">
    #          fonts
    #        </dir>
    #      </fontconfig>
    #    '';
    #  }

    # default font family
    font.family = "ComicMono Nerd Font";

    home.sessionVariables = {
      MOZ_USE_XINPUT2 = "1";
    };

    # programs
    programs = {
      alacritty = {
        #enable = true;
        settings.font.size = config.font.size.normal;
        settings.font.normal.family = config.font.family;
        #settings = import ./alacritty.nix;
      };
    };
  };
}
