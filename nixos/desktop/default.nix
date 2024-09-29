{
  config,
  lib,
  pkgs,
  ...
}:

{
  # system packages for desktop
  environment.systemPackages = with pkgs; [
    alacritty
    firefox
    gimp
    wlr-randr
    wl-clipboard
    brave
  ];

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  #misc services
  services = {
    printing.enable = true;
  };
  # auto-discover printers
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

}
