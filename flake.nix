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
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      sops-nix,
      nix-flatpak,
      ...
    }@inputs:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # Point to the desktop host folder
          ./hosts/desktop/hardware-configuration.nix
          ./hosts/desktop/configuration.nix

          inputs.sops-nix.nixosModules.sops
          inputs.nix-flatpak.nixosModules.nix-flatpak

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.aurelius = import ./modules/home/home.nix;
          }
        ];
      };
    };
}
