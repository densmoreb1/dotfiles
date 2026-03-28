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
      thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit username;};
        modules = [
          ./systems/thinkpad
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
                ./modules/homemanager/default.nix
                ./modules/desktop/desktop-home.nix
                nixvim.homeModules.nixvim
                sops-nix.homeManagerModules.sops
              ];
            };
          }
        ];
      };

      rose = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit jovian username;};
        modules = [
          ./systems/rose
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
                ./modules/homemanager/default.nix
                ./modules/desktop/desktop-home.nix
                nixvim.homeModules.nixvim
                sops-nix.homeManagerModules.sops
              ];
            };
          }
        ];
      };

      maria = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit username;};
        modules = [
          ./systems/maria
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
                ./modules/homemanager/default.nix
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
          ./systems/pipboy
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
                ./modules/homemanager/default.nix
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
