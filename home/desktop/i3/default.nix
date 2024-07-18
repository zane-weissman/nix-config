{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [ i3wsr ];
  home.file = {
    ".i3/i3blocks".source = ./i3blocks;
    ".i3blocks.conf".source = ./i3blocks.conf;
    ".i3blocks2.conf".source = ./i3blocks2.conf;
    ".i3workspaceconfig".source = ./i3workspaceconfig;
    ".i3/config".text = lib.strings.concatStrings [
      (builtins.readFile ./config)
      ''
        # colors
        set_from_resource $foreground i3.foreground #FFFFFF
        set_from_resource $background i3.background #000000

        set_from_resource $black0 i3.color0 
        set_from_resource $black8 i3.color8

        set_from_resource $red1 i3.color1
        set_from_resource $red9 i3.color9

        set_from_resource $green2 i3.color2
        set_from_resource $green10 i3.color10

        set_from_resource $yellow3 i3.color3
        set_from_resource $yellow11 i3.color11

        set_from_resource $blue4 i3.color4
        set_from_resource $blue12 i3.color12

        set_from_resource $magenta5 i3.color5
        set_from_resource $magenta13 i3.color13

        set_from_resource $cyan6 i3.color6
        set_from_resource $cyan14 i3.color14

        set_from_resource $white7 i3.color7
        set_from_resource $white15 i3.color15

        set $transparent #00000000
      ''
    ];
  };
}
