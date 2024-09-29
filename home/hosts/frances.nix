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
  
  environment.systemPackages = with pkgs; [ kmonad ];
  services.kmonad = {
    enable = true;
    keyboards = {
      frameworkKeyboard = {
        device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
        config = 
          ''
(defcfg
  input  (device-file "/dev/input/by-id/usb-04d9_daskeyboard-event-kbd")
  output (uinput-sink
          "framework keyboard's kmonad out" ;; name of the created keyboard
          "....") ;; additional, environment-specific, information
  fallthrough true
  allow-cmd false ;; maybe change later?

  ;; aliases
  
  (defalias
    agr (layer-toggle altgr)
  )

  ;; srcs and layers

  (defsrc
    esc   f1   f2   f3   f4   f5   f6   f7   f8   f9   f10   f11   f12   del
    grb    1    2    3    4    5    6    7    8    9     0     -     =   bspc
    tab    q    w    e    r    t    y    u    i    o     p     [     ]    \  
    caps   a    s    d    f    g    h    j    k    l    ;      '       ret
    lsft   z    x    c    v    b    n    m    ,    .    /     up  rsft  
    lctl wkup lmet lalt      spc            ralt rctl  left  down right
  )
  (deflayer qwerty
    esc   f1   f2   f3   f4   f5   f6   f7   f8   f9   f10   f11   f12   del
    grb    1    2    3    4    5    6    7    8    9     0     -     =   bspc
    tab    q    w    e    r    t    y    u    i    o     p     [     ]    \  
    caps   a    s    d    f    g    h    j    k    l    ;      '       ret
    lsft   z    x    c    v    b    n    m    ,    .    /     up  rsft  
    lctl wkup lmet lalt      spc            agr rwin  left  down right
  )
  (deflayer altgr
    -     -    -    -    -    -    -    -    -    -    -     -     -     -   
    -      -    -    -    -    -    -    -    -    -     -     -     -   -   
    -      -    -    -    -    -    -    home pgdn pgup  end   -     -    -   
    -      -    -    -    -    -    -    left down up   right  -       -   
    -      -    -    -    -    -    -    -    -    -    -     -   -     
    -    -    -    -         -              -    -     -     -    -    
  )
)
          '';
  };
}
