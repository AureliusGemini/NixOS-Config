# Homelab drive (`/mnt/homelab`) + Podman storage

Desktop only. Drive: 500GB WD HDD (`sda`), Btrfs, UUID `e8158e89-e443-42e3-82de-0136ad1b68f4`.
Declared in `hosts/desktop/homelab.nix`; Podman is configured in
`modules/nixos/features/podman.nix`.

## One-time setup (before the first `switch`)

```bash
# 1. Mountpoint that cannot be written to while the disk is NOT mounted.
#    (nofail lets boot continue without the disk; without this, Podman could
#    silently fill the root SSD underneath a missing mount.)
sudo mkdir -p /mnt/homelab
sudo chattr +i /mnt/homelab

# 2. Rebuild
sudo nixos-rebuild test --flake .#nixos      # try first
sudo nixos-rebuild switch --flake .#nixos

# 3. After it is mounted: separate subvolumes
findmnt /mnt/homelab                          # confirm it is mounted
sudo btrfs subvolume create /mnt/homelab/containers   # images/layers: re-pullable
sudo btrfs subvolume create /mnt/homelab/appdata      # service data: BACK THIS UP
```

The tmpfiles rule creates `/mnt/homelab/appdata` as a plain folder. If you want it
to be a subvolume, create the subvolume **before** the first switch, or move the
folder aside and recreate it.

## Check the KDE eject button

Open Dolphin -> Devices. If "homelab" still shows an eject/unmount button,
uncomment the `services.udev.extraRules` block in `hosts/desktop/homelab.nix`.
I'm not certain `x-udisks-internal` alone is honoured; the udev rule is the
documented alternative. Both are untested here.

## Podman

- Rootful (system) Podman. `docker` is only an alias, no Docker is installed.
- Images/layers: `/mnt/homelab/containers/storage` (driver `overlay`).
- Changing `graphRoot` does **not** move existing images. After the first switch:
  ```bash
  sudo podman images          # should be empty (new location)
  # re-pull what you need; then reclaim the old space:
  sudo rm -rf /var/lib/containers/storage   # only after you are sure
  ```
- Containers refuse to start if `/mnt/homelab` is not mounted
  (`RequiresMountsFor`), so nothing falls back to the root SSD.
- Prefer **bind mounts** for data you care about:
  `/mnt/homelab/appdata/<service>:/data`. They are visible and easy to back up.
- Databases: `sudo chattr +C /mnt/homelab/appdata/<db>` on the **empty** folder
  disables Btrfs copy-on-write for it (also disables compression/checksums there).

## Hardware note

An old HDD: check it with `sudo smartctl -a /dev/sda` and keep a copy of
`appdata` somewhere else.

## AdGuard Home (optional, off by default)

Enable in `hosts/desktop/default.nix`: `my.adguard.enable = true;`

- It runs as a native NixOS service (not a container), so DNS does not depend on
  Podman or the HDD. Web UI: http://127.0.0.1:3000 (first-run wizard).
- Default: answers on `127.0.0.1` only, so it filters **this desktop**. There is no
  home router/Wi-Fi to serve other devices. `my.adguard.lanDns = true;` opens port 53
  so the laptop (over the cable) or Tailscale devices can use it.
- To use it, point the desktop's DNS at it, keeping a fallback so DNS still works if
  AdGuard is down:
  ```bash
  nmcli con mod "<connection name>" ipv4.dns "127.0.0.1 9.9.9.9" ipv4.ignore-auto-dns yes
  ```
- Its state (config + 7 days of query logs) stays in `/var/lib/AdGuardHome`; that is
  small, so it is not moved to the HDD.
- If `services.resolved` is ever enabled, add `services.resolved.extraConfig =
  "DNSStubListener=no";` (port 53 conflict).
- Only helpful while the desktop is switched on. A browser ad blocker (uBlock Origin)
  covers most of the same ground for web browsing.
