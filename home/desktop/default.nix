{
  config, lib, pkgs, ...
}:

let
  myFuncs = import ../../lib/src.nix;
in
{
  imports = [
    ./alacritty.nix
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
    
    xdg.configFile = 
      let
        inherit (myFuncs) src;
      in
      src ./. [
        "qtile"
      ];
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

    home.sessionVariables = {
      MOZ_USE_XINPUT2 = "1";
    };

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
