# Every shared Home Manager module. Features are off until a host's file
# (desktop.nix / wsl.nix) turns them on with `my.<name>.enable = true;`.
{ ... }:

{
  imports = [
    ./common

    ./features/kate.nix
    ./features/obs.nix
    ./features/vscode.nix
    ./features/apps.nix
    ./features/game-launchers.nix
  ];
}
