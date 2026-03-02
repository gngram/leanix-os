{
  description = "My NixOS configurations for multiple platforms";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }: {
    nixosConfigurations = {
      lenovo-x1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules
          ./targets/lenovo-x1
          home-manager.nixosModules.home-manager
        ];
      };

      seclab-beast = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules
          ./targets/seclab-beast
          home-manager.nixosModules.home-manager
        ];
      };
    };
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
  };
}

