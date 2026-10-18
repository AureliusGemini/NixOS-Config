# ~/nixos-config/flake.nix
{
  description = "My NixOS Flake Configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Follow our nixpkgs so the WSL host doesn't pull a second copy of nixpkgs.
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # Single source of truth for "who am I". Used by both hosts (NixOS user)
      # and by Home Manager (git identity).
      user = {
        name = "aurelius";
        description = "AureliusGemini";
        git = {
          name = "AureliusGemini";
          email = "93374856+AureliusGemini@users.noreply.github.com";
        };
        # Public SSH keys allowed to log in as this user, e.g.
        #   sshKeys = [ "ssh-ed25519 AAAA... aurelius@laptop" ];
        sshKeys = [ ];
      };

      mkHost =
        { hostModules, homeModule }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs user; };
          modules = hostModules ++ [
            ./modules/nixos
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = { inherit inputs user; };
                users.${user.name}.imports = [ homeModule ];
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        nixos = mkHost {
          hostModules = [
            ./hosts/desktop
            inputs.sops-nix.nixosModules.sops
          ];
          homeModule = ./modules/home/desktop.nix;
        };

        nixos-wsl = mkHost {
          hostModules = [
            inputs.nixos-wsl.nixosModules.default
            ./hosts/wsl
          ];
          homeModule = ./modules/home/wsl.nix;
        };
      };

      # Custom packages, available as pkgs.<name> on every host.
      overlays.default = final: _prev: {
        kate-discord-rpc = final.callPackage ./pkgs/kate-discord-rpc.nix { };
        obs-aitum-vertical = final.callPackage ./pkgs/obs-aitum-vertical.nix { };
      };

      # Lets you test them alone: nix build .#kate-discord-rpc
      packages.${system} =
        let
          withOverlay = pkgs.extend self.overlays.default;
        in
        {
          inherit (withOverlay) kate-discord-rpc obs-aitum-vertical;
        };

      formatter.${system} = pkgs.nixfmt;
    };
}
