{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
      ./amdgpu.nix
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  # boot.initrd.postDeviceCommands = lib.mkAfter ''
  #   btrfs subvolume snapshot local/root-blank local
  # '';
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = ["zfs"];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/3dcd06da-78b9-40dd-83f4-09158757ca51";
      fsType = "btrfs";
      options = [ "defaults"
                  "compress=zstd"
                  "subvol=local/root" 
                  "noatime"
                ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/3dcd06da-78b9-40dd-83f4-09158757ca51";
      fsType = "btrfs";
      options = [ "defaults"
                  "compress=zstd"
                  "subvol=local/nix" 
                  "noatime"
                ];
    };

  fileSystems."/persist" =
    { device = "/dev/disk/by-uuid/3dcd06da-78b9-40dd-83f4-09158757ca51";
      fsType = "btrfs";
      options = [ "defaults"
                  "compress=zstd"
                  "subvol=safe/persist" 
                ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/3dcd06da-78b9-40dd-83f4-09158757ca51";
      fsType = "btrfs";
      options = [ "defaults"
                  "compress=zstd"
                  "subvol=safe/home" 
                ];
    };
  
  fileSystems."/var/log" = 
    { device = "/dev/disk/by-uuid/3dcd06da-78b9-40dd-83f4-09158757ca51";
      fsType = "btrfs";
      options = [ "defaults"
                  "compress=zstd"
                  "subvol=safe/log" 
                ];
      neededForBoot = true;
    };


  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/5003-7E81";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };


  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
