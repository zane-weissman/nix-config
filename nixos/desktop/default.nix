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

}
