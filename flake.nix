{
  description = "My flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nixvim.url = "github:nix-community/nixvim";
    sops-nix.url = "github:Mic92/sops-nix";
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    jovian.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixvim,
    sops-nix,
    jovian,
    ...
  }: {
    nixosConfigurations = {
      ally = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit jovian;};
        modules = [
          ./modules/common.nix
          ./systems/ally/configuration.nix
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.brandon = {
              imports = [
                ./systems/ally/home.nix
                nixvim.homeModules.nixvim
                sops-nix.homeManagerModules.sops
              ];
            };
          }
        ];
      };

      thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/common.nix
          ./systems/thinkpad/configuration.nix
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.brandon = {
              imports = [
                ./systems/thinkpad/home.nix
                nixvim.homeModules.nixvim
                sops-nix.homeManagerModules.sops
              ];
            };
          }
        ];
      };

      pipboy = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/common.nix
          ./systems/pipboy/configuration.nix
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.bdenzy = {
              imports = [
                ./systems/pipboy/home.nix
                nixvim.homeModules.nixvim
                sops-nix.homeManagerModules.sops
              ];
            };
          }
        ];
      };
    };
  };
}
