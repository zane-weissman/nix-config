{
  config,
  lib,
  pkgs,
  ...
}:
let
  firefox = "flatpak run org.mozilla.firefox";
  terminal = "nixGL alacritty";
  rofi = "rofi -font \"Roboto Mono Bold 10.5\" -show";
  files = "nemo";
in
{

  xdg.configFile."sxhkd/sxhkdrc".text = ''
    super{_, + shift} + w
      {${firefox}, microsoft-edge}
    super{_, + shift} + Return
      {${terminal}, xterm}
    super + e
      ${files}
    super + n
      ${firefox} localhost:631/jobs
    super{_, + shift} + d
      ${rofi} {drun, run}
    super + x
      autorandr -c
    XF86AudioRaiseVolume 
      pactl set-sink-volume 0 +5% 
    XF86AudioLowerVolume 
      pactl set-sink-volume 0 -5% 
    XF86AudioMute 
      pactl set-sink-mute 0 toggle 
    {_,any + }XF86MonBrightness{Down,Up}
      light {-U 5, -S 0, -A 5, -S 100}
    super{_, + shift} + p
      passmenu{_,-add}
  '';
}
