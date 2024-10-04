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
  environment.systemPackages = with pkgs; [ kanata ]; # change to kanata-with-cmd?
  services.kanata = {
    enable = true;
    keyboards.frameworkKeyboard = {
      devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
      extraDefCfg = "";
      config = lib.string.concatLines [
        ../keyboard/framework-kanata.kbd
        ../keyboard/homerow-mods.kbd
      ];
    };
  };

  # environment.systemPackages = with pkgs; [ kmonad ];
  # services.kmonad = {
  #   enable = true;
  #   keyboards = {
  #     frameworkKeyboard = {
  #       device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
  #       config = builtins.readFile ../keyboard/framework-kmonad.kbd;
  #     };
  #   };
  # };
}
