{
  config,
  lib,
  pkgs,
  ...
}:

{

  imports = [ ../hardware/frances.nix ];
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
}
