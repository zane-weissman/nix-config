{
  config,
  lib,
  pkgs,
  ...
}:

{

  imports = [
    ../hardware/frances.nix
    ../persistence
  ];
  networking.hostName = "frances"; # Define your hostname.
  networking.hostId = "3c68a037"; # required for zfs

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp6s0.useDHCP = lib.mkDefault true;

  services = {
    fwupd.enable = true;
    power-profiles-daemon.enable = true;
  };

  services.libinput.touchpad = {
    clickMethod = "clickfinger";
  };

  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  #environment.etc.
  security.pki.certificates = [
    #(builtins.readFile /persist/etc/ssl/certs/9f3cc5f891b54e947d422f8cca31345b8c3ec55a.cer)
    #(builtins.readFile /persist/etc/ssl/certs/zweissman.pem)
  ];

  environment.systemPackages = with pkgs; [ kmonad ];
  services.kmonad = {
    enable = true;
    keyboards = {
      frameworkKeyboard = {
        device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
        config = 
  # environment.systemPackages = with pkgs; [ kanata ];
  # services.kanata = {
  #   enable = true;
  #   keyboards.frameworkKeyboard.config = ''
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
