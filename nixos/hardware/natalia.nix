# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "usb_storage" ];
  boot.initrd.kernelModules = [ "usb_storage" ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # load usb storage drivers for initrd to be able to mount /
  # fileSystems."/" =
  #   { device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
  #     fsType = "ext4";
  #   };

  # fileSystems."/swap" =
  #   { device = "/dev/sdb1";
  #     fsType = "btrfs";
  #     options = [ "subvol=swap" ];
  #   };

  # fileSystems."/mnt" =
  #   { device = "/dev/sdb1";
  #     fsType = "btrfs";
  #   };

  # swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.end0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  # mountpoints and filesystems
  fileSystems =
    let

      mainStorage = {
        device = "/dev/disk/by-uuid/cb333210-2ec2-4765-a8fa-6c10f1d8e5cf";
        fsType = "btrfs";
      };

      makeSubvolMount =
        {
          subvol,
          extra-opts ? {
            ${null} = true;
          },
        }: # default case - extra opts do not get added
        (
          mainStorage
          // {
            options = [
              "subvol=${subvol}"
              "noatime"
              "compress=zstd"
            ];
          }
          // extra-opts
        );
    in
    {
      "/sd" = {
        device = "/dev/disk/by-uuid/d2351334-057e-4ebc-a7b8-71751b47a7c1";
        fsType = "ext4";
      };
      "/" = (makeSubvolMount { subvol = "root"; });
      "/home" = (makeSubvolMount { subvol = "home"; });
      "/nix" = (makeSubvolMount { subvol = "nix"; });
      "/var/log" = (
        makeSubvolMount {
          subvol = "log";
          extra-opts = {
            neededForBoot = true;
          };
        }
      );
      "/persist" = (makeSubvolMount { subvol = "persist"; });
      "/boot" = {
        depends = [
          "/sd"
          "/"
        ];
        device = "/sd/boot";
        fsType = "none";
        options = [ "bind" ];
      };
    };

  # swap
  swapDevices = [
    { device = "/dev/disk/by-uuid/d2351334-057e-4ebc-a7b8-71751b47a7c1"; }
    { device = "/dev/disk/by-uuid/dca46aa0-cb6a-4fb1-bd61-583f32371ecb"; }
  ];
}
