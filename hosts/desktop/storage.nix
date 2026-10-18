# Root SSD (Btrfs) options, bcache pool at /mnt/storage, swap, trim/scrub.
# (subvol= options live in hardware-configuration.nix; the homelab HDD is in homelab.nix.)
{ lib, ... }:

{
  fileSystems =
    lib.genAttrs [ "/" "/nix" "/home" ] (_: {
      options = [
        "compress=zstd"
        "noatime"
      ];
    })
    // {
      # bcache-backed game/media pool (480GB SSD cache + 1TB HDD)
      "/mnt/storage" = {
        device = "/dev/disk/by-uuid/5a1c9e0a-cafd-4f46-a596-f33e7abd9387";
        fsType = "btrfs";
        options = [
          "defaults"
          "nofail"
          "x-udisks-internal"
          "compress=zstd"
        ];
      };
    };

  services.fstrim.enable = true;
  services.btrfs.autoScrub.enable = true;

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8192;
    }
  ];
}
