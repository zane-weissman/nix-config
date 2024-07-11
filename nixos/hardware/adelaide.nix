{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ./amdgpu.nix ];

  # boot options
  boot.kernelParams = [ "boot.shell_on_fail" ];
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # file systems

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/4972b9d9-65de-4727-a269-af45aa5a4bc8";
    fsType = "btrfs";
    options = [
      "defaults"
      "subvol=root"
      "compress=zstd"
    ];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0E0B-A420";
    fsType = "vfat";
    options = [
      "umask=077"
      "defaults"
    ];
    depends = [ "/" ];
  };
  fileSystems."/storage" = {
    device = "/dev/disk/by-uuid/E9E4F5FDE9E4F5FD";
    fsType = "ntfs";
    options = [
      "defaults"
      "uid=1000"
      "gid=1000"
      "dmask=007"
      "fmask=117"
    ];
    depends = [ "/" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/c3e06da2-10b7-4743-abd5-336ed5c71828";
    fsType = "btrfs";
    options = [
      "defaults"
      "compress=zstd"
    ];
    depends = [ "/" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/4972b9d9-65de-4727-a269-af45aa5a4bc8";
    fsType = "btrfs";
    options = [
      "defaults"
      "subvol=nix"
      "compress=zstd"
      "noatime"
    ];
    depends = [ "/" ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/4972b9d9-65de-4727-a269-af45aa5a4bc8";
    fsType = "btrfs";
    options = [
      "defaults"
      "subvol=persist"
      "compress=zstd"
    ];
    depends = [ "/" ];
  };

  # bind mounts
  # DO NOT FORET ABOUT depends
  # also: systemd-boot currently requires weird workaround for depends
  # check issue: https://github.com/NixOS/nixpkgs/issues/217179
  # and PR: https://github.com/NixOS/nixpkgs/pull/233707

  # fileSystems."/etc/nixos" =
  #   { device = "/persist/etc/nixos";
  #     fsType = "none";
  #     options = [
  #       "defaults" "bind" 
  #       "x-systemd.requires-mounts-for=/sysroot"
  #       "x-systemd.requires-mounts-for=/sysroot/persist"
  #     ];
  #     #depends = [ "/persist" "/" ];
  #   };

  # fileSystems."/var/log" =
  #   { device = "/persist/var/log";
  #     fsType = "none";
  #     options = [
  #       "defaults" "bind" 
  #       "x-systemd.requires-mounts-for=/sysroot"
  #       "x-systemd.requires-mounts-for=/sysroot/persist"
  #     ];
  #     #depends = [ "/persist" "/" ];
  #   };

  swapDevices = [
    { device = "/dev/disk/by-uuid/e9c76aa0-e35a-4c75-b2fa-91d39769263e"; }
    { device = "/dev/disk/by-uuid/26d8feac-680c-41e8-8356-0bf5c6451684"; }
  ];

  # intel/x86
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
