# 500GB WD HDD (sda, Btrfs) used only for homelab services + Podman storage.
# One-time setup (immutable mountpoint, subvolumes): docs/HOMELAB.md
{ ... }:

{
  fileSystems."/mnt/homelab" = {
    device = "/dev/disk/by-uuid/e8158e89-e443-42e3-82de-0136ad1b68f4";
    fsType = "btrfs";
    options = [
      "defaults"
      "compress=zstd"
      "noatime"
      "nofail"
      "x-udisks-internal"
      "x-systemd.device-timeout=5s" # don't hang boot for 90s if the disk is missing
    ];
  };

  # Fallback if KDE still shows an eject button despite x-udisks-internal
  # (untested; uncomment and rebuild):
  # services.udev.extraRules = ''
  #   ENV{ID_FS_UUID}=="e8158e89-e443-42e3-82de-0136ad1b68f4", ENV{UDISKS_SYSTEM}="1"
  # '';

  # Podman images/layers on the HDD instead of the root SSD.
  my.podman = {
    enable = true;
    graphRoot = "/mnt/homelab/containers/storage";
  };

  # Service data goes here (back this up; containers/ is re-pullable).
  systemd.tmpfiles.rules = [
    "d /mnt/homelab/appdata 0755 root root -"
  ];
}
