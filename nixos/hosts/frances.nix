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
    (builtins.readFile /persist/etc/ssl/certs/9f3cc5f891b54e947d422f8cca31345b8c3ec55a.cer)
    (builtins.readFile /persist/etc/ssl/certs/zweissman.pem)
  ];
}
