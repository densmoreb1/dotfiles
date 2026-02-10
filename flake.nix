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
          ./modules/system/common.nix
          ./modules/system/distributed-builds.nix
          ./modules/system/style.nix
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
            home-manager.users.${username} = {
              imports = [
                ./modules/home/common.nix
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
          ./modules/desktop/hyprland.nix
          ./modules/desktop/mail.nix
          ./modules/system/bluetooth.nix
          ./modules/system/common.nix
          ./modules/system/distributed-builds.nix
          ./modules/system/nvidia.nix
          ./modules/system/style.nix
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
                ./modules/home/common.nix
                ./modules/home/desktop-home.nix
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
          ./modules/desktop/hyprland.nix
          ./modules/desktop/mail.nix
          ./modules/system/bluetooth.nix
          ./modules/system/common.nix
          ./modules/system/style.nix
          ./systems/rose/configuration.nix
          ./systems/rose/hardware-configuration.nix
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
                ./modules/home/common.nix
                ./modules/home/desktop-home.nix
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
          ./modules/system/common.nix
          ./modules/system/distributed-builds.nix
          ./systems/maria/configuration.nix
          ./systems/maria/hardware-configuration.nix
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
                ./modules/home/common.nix
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
          ./modules/system/common.nix
          ./modules/system/distributed-builds.nix
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
                ./modules/home/common.nix
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
