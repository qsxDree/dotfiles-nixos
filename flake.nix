{
    description = "My first flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

        # Home Manager (follow nixpkgs)
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    };

    outputs = {
        self,
        nixpkgs,
        home-manager,
        nixos-hardware,
        ...
    }:  let
            lib = nixpkgs.lib;
            system = "x86_64-linux";
            pkgs = nixpkgs.legacyPackages.${system};
        in {
        nixosConfigurations = {
            nixos = lib.nixosSystem {
                inherit system;
                modules = [
                    ./configuration.nix
                    nixos-hardware.nixosModules.asus-fx506hm
                ];
            };
        };

        nixpkgs.config.allowUnfree = true;

        homeConfigurations = {
            reee = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                modules = [ ./home.nix ];
            };
        };
    };
}
