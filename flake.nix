{
  description = "My flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixvim,
    sops-nix,
    jovian,
    stylix,
    nixos-hardware,
    ...
  }: let
    username = "brandon";
  in {
    nixosConfigurations = {
      ally = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit jovian username;};
        modules = [
          ./modules/common.nix
          ./modules/style.nix
          ./systems/ally/configuration.nix
          ./systems/ally/hardware-configuration.nix
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          stylix.nixosModules.stylix
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit username;
            };
            home-manager.users.brandon = {
              imports = [
                ./home.nix
                nixvim.homeModules.nixvim
                sops-nix.homeManagerModules.sops
              ];
            };
          }
        ];
      };

      thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit username;};
        modules = [
          ./modules/common.nix
          ./modules/hyprland.nix
          ./modules/nvidia.nix
          ./modules/style.nix
          ./systems/thinkpad/configuration.nix
          ./systems/thinkpad/hardware-configuration.nix
          home-manager.nixosModules.home-manager
          nixos-hardware.nixosModules.lenovo-thinkpad-p1
          sops-nix.nixosModules.sops
          stylix.nixosModules.stylix
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit username;
            };
            home-manager.users.${username} = {
              imports = [
                ./home.nix
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
        specialArgs = {inherit username;};
        modules = [
          ./modules/common.nix
          ./systems/pipboy/configuration.nix
          ./systems/pipboy/hardware-configuration.nix
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          stylix.nixosModules.stylix
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit username;
            };
            home-manager.users.${username} = {
              imports = [
                ./home.nix
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
