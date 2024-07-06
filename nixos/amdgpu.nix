{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot.initrd.kernelModules = [ "amdgpu" ];
  
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # for Southern Islands (SI i.e. GCN 1) cards
  #boot.kernelParams = [ "radeon.si_support=0" "amdgpu.si_support=1" ];
  # for Sea Islands (CIK i.e. GCN 2) cards
  #boot.kernelParams = [ "radeon.cik_support=0" "amdgpu.cik_support=1" ];
  #

  hardware.graphics.enable = true;

  #hardware.opengl.driSupport = true; # This is already enabled by default and no longer works
  #hardware.graphics.driSupport32Bit = true; # For 32 bit applications (also no longer exists, apparently)
  
  
  # enable amdvlk too, 
  hardware.graphics.extraPackages = with pkgs; [
    amdvlk
  ];
  # For 32 bit applications 
  hardware.graphics.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];

}
