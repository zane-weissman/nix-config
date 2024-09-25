{
  config,
  lib,
  pkgs,
  ...
}:

{
  # rollback btrfs
  # Note `lib.mkBefore` is used instead of `lib.mkAfter` here.
  boot.initrd.postDeviceCommands = pkgs.lib.mkBefore ''
    mkdir -p /mnt

    # We first mount the btrfs root to /mnt
    # so we can manipulate btrfs subvolumes.
    mount -o subvol=/ /dev/disk/by-uuid/3dcd06da-78b9-40dd-83f4-09158757ca51 /mnt

    # While we're tempted to just delete /root and create
    # a new snapshot from /root-blank, /root is already
    # populated at this point with a number of subvolumes,
    # which makes `btrfs subvolume delete` fail.
    # So, we remove them first.
    #
    # /root contains subvolumes:
    # - /root/var/lib/portables
    # - /root/var/lib/machines
    #
    # I suspect these are related to systemd-nspawn, but
    # since I don't use it I'm not 100% sure.
    # Anyhow, deleting these subvolumes hasn't resulted
    # in any issues so far, except for fairly
    # benign-looking errors from systemd-tmpfiles.
    btrfs subvolume list -o /mnt/local/root |
    cut -f9 -d' ' |
    while read subvolume; do
      echo "deleting /$subvolume subvolume..."
      btrfs subvolume delete "/mnt/$subvolume"
    done &&
    echo "deleting /local/root subvolume..." &&
    btrfs subvolume delete /mnt/local/root

    echo "restoring blank /local/root subvolume..."
    btrfs subvolume snapshot /mnt/local/root-blank /mnt/local/root

    # while we're at it, delete logs older than 48 hours
    # find /mnt/safe/log/* -mtime +2 -delete

    # Once we're done rolling back to a blank snapshot,
    # we can unmount /mnt and continue on the boot process.
    umount /mnt
  '';

  # etc files
  environment.etc = {
    # machine
    "adjtime".source = /persist/etc/adjtime;
    "machine-id".source = /persist/etc/machine-id;
    #"NetworkManager/system-connections".source = /persist/etc/NetworkManager/system-connections;
    #"NetworkManager/VPN".source = /persist/etc/NetworkManager/VPN;
  };

  # symlinks
  systemd.tmpfiles.rules = [
    "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
    "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
  ];

  # networkmanager - set path for system-connections folder
  networking.networkmanager.settings.keyfile.path = "/persist/etc/NetworkManager/system-connections/";
  #[keyfile]
  #path="/persist/etc/NetworkManager/system-connections/"

  # sudo lecture
  security.sudo.extraConfig = ''
    # rollback results in sudo lecture after reboot - disable it
    Defaults lecture = never
  '';
}
