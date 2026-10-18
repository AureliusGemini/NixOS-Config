# scripts/ — what each script does

All scripts live in `~/nixos-config/scripts/`. Run them from anywhere:

```bash
~/nixos-config/scripts/<name>.sh
```

If one isn't executable: `chmod +x ~/nixos-config/scripts/*.sh`

Host names: **`nixos` = desktop**, **`nixos-wsl` = laptop**. The scripts use these
names, so if you ever rename a host, update the scripts too.

---

## Which one do I need?

| Situation | Script | Run on |
|---|---|---|
| I edited the config on **github.com** and want it on this machine | `pull-config.sh` | desktop or laptop |
| I edited in **VS Code** and want to apply + commit | `update.sh` | desktop or laptop |
| I'm on **campus Wi-Fi** and want to download everything for the desktop | `export-cache.sh` | laptop (WSL) |
| I'm **home, laptop and desktop connected by cable** | `sync-desktop.sh` | laptop (WSL) |
| Desktop must rebuild **without internet** | `apply-offline.sh` | desktop |

---

## pull-config.sh — pull from GitHub, then rebuild

```bash
pull-config.sh              # pull, show what changed, ask before rebuilding
pull-config.sh -y           # pull and rebuild without asking
pull-config.sh test         # choose rebuild mode: switch (default) | test | boot | build
```

- Your uncommitted edits are stashed and restored automatically (`--autostash`).
- Local unpushed commits are put on top of GitHub's (`--rebase`).
- On a conflict it stops and tells you how to continue or abort
  (`git rebase --continue` / `git rebase --abort`).
- It rebuilds the host that matches this machine's hostname.
- It runs the config you just pulled as root, so glance at the commit list it prints.

## update.sh — rebuild after editing locally (and commit)

```bash
update.sh [MODE] [HOST] [UPGRADE]
update.sh                      # switch, auto-detect host, no upgrade
update.sh switch auto true     # also run `nix flake update` first
update.sh test                 # try the config without making it the boot default
update.sh build nixos          # only build the desktop config (no activation)
```

- `MODE`: `switch` | `test` | `boot` | `build` (default `switch`)
- `HOST`: `nixos` | `nixos-wsl` | `auto` (auto = WSL → `nixos-wsl`, otherwise `nixos`)
- `UPGRADE`: `true` runs `nix flake update` before building (default `false`)

What it does, in order: stash local changes → `git pull --rebase` → restore changes →
(optional) `nix flake update` → rebuild → **only if the rebuild succeeded**, asks for a
commit message and commits. It does **not** push; run `git push` yourself.

## export-cache.sh — campus: download and save the desktop's closure

```bash
export-cache.sh /mnt/d/nix-cache     # recommended: give the folder explicitly
export-cache.sh                      # asks for a folder (default: /mnt/c/nix-cache on WSL)
```

Builds the **desktop** system (`.#nixosConfigurations.nixos`) on the laptop, copies it
into a file-based cache folder, and also copies the flake inputs (nixpkgs etc.) so the
desktop can evaluate the flake without internet. Temporarily stashes uncommitted changes
so the build matches what is committed, and restores them at the end.

## sync-desktop.sh — home: push the cache to the desktop over the cable

```bash
sync-desktop.sh                                  # 192.168.50.2, user aurelius, auto-find cache
sync-desktop.sh 192.168.50.2 aurelius /mnt/d/nix-cache
```

Arguments: `DESKTOP_IP`, `DESKTOP_USER`, `CACHE_PATH` (all optional). Cache auto-detect
order: `/mnt/d/nix-cache`, then `~/.cache/nix-export-cache`. It pings the desktop first,
then copies the cache to it with `nix copy ... ssh-ng://`.

Needs: the laptop's SSH public key authorised on the desktop
(`user.sshKeys` in `flake.nix`).

## apply-offline.sh — desktop: rebuild with no internet

```bash
apply-offline.sh                       # switch, purely offline
apply-offline.sh test /mnt/usb-cache   # test mode, with a local cache folder
```

Arguments: `MODE` (`switch` | `test` | `boot`), optional `LOCAL_CACHE` folder. Rebuilds
`.#nixos` (**desktop only**) with downloads disabled.

---

## Typical days

**Edited on github.com** → on the machine you want to update: `pull-config.sh`

**Edited in VS Code** → `update.sh`, then `git push`

**Campus day (laptop):**
1. `update.sh switch nixos-wsl true` (optional: bump versions + update the laptop)
2. `export-cache.sh /mnt/d/nix-cache`

**Home, no Wi-Fi:**
1. Laptop ↔ desktop by Ethernet cable
2. Laptop: `sync-desktop.sh`
3. Desktop: `apply-offline.sh`

---

## Known quirks (untested; tell me if one bites you)

- `export-cache.sh` defaults to `/mnt/c/nix-cache`, but `sync-desktop.sh` looks in
  `/mnt/d/nix-cache` first. Pass the same folder to both to be safe.
- `sync-desktop.sh` uses `nix copy --from file://... --all`. If Nix says `--all` isn't
  supported for that source, the fix is to copy the specific system path instead.
- `apply-offline.sh` disables all substituters, which probably also cancels the
  `extra-substituters` cache folder it adds. It still works if `sync-desktop.sh` already
  copied the closure into the desktop's store.
- `apply-offline.sh` passes `--no-link`; if `nixos-rebuild` rejects it, delete that line.

## Indonesian → English cheat sheet (for the leftover Indonesian in some scripts)

| Indonesian | English |
|---|---|
| Peringatan | Warning |
| PENTING | IMPORTANT |
| PERBAIKAN | FIX |
| Pastikan | Make sure |
| Bendera | Flags |
| Simpan sementara (Stash) | Stash temporarily |
| Batalkan perubahan lokal (Hard Reset) | Discard local changes (hard reset) |
| Batalkan proses pull | Cancel the pull |
| Mengunduh pembaruan | Downloading updates |
| Mengembalikan perubahan | Restoring changes |
| Salin / Menyalin | Copy / Copying |
| Ubah ke path absolut | Convert to absolute path |
| Opsional tapi dianjurkan | Optional but recommended |
