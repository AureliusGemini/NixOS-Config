# Nix daemon settings, overlays, garbage collection (via nh).
{ inputs, user, ... }:

{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "@wheel"
    ];
    # Flaky / slow networks (campus, tethering)
    download-attempts = 10;
    connect-timeout = 20;
    # 500 MB: avoids "download buffer is full" stalls on fast campus links
    download-buffer-size = 524288000;
  };
  nix.optimise.automatic = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [ inputs.self.overlays.default ];

  # `nh os switch` / `nh clean all`. Its weekly clean takes the place of
  # nix.gc, so do NOT also enable nix.gc.automatic.
  programs.nh = {
    enable = true;
    flake = "/home/${user.name}/nixos-config";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 14d --keep 5";
    };
  };
}
