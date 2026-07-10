{
  description = "My flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nixvim pins its own tested nixpkgs; don't force `follows` (upstream
    # recommendation) so the editor stays on a known-compatible package set.
    nixvim.url = "github:nix-community/nixvim";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixvim,
    sops-nix,
    stylix,
    zen-browser,
    ...
  }: let
    username = "brandon";

    # Build a NixOS configuration for one host. Set `desktop = true` to pull in
    # the Hyprland/desktop home-manager modules; headless hosts leave it off.
    mkSystem = {
      host,
      desktop ? false,
    }:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit username;};
        modules = [
          ./systems/${host}
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          stylix.nixosModules.stylix
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit username;};
            home-manager.users.${username}.imports =
              [
                ./modules/homemanager/default.nix
                nixvim.homeModules.nixvim
                sops-nix.homeManagerModules.sops
              ]
              ++ nixpkgs.lib.optionals desktop [
                ./modules/homemanager/desktop.nix
                zen-browser.homeModules.beta
              ];
          }
        ];
      };
  in {
    nixosConfigurations = {
      thinkpad = mkSystem {
        host = "thinkpad";
        desktop = true;
      };
      rose = mkSystem {
        host = "rose";
        desktop = true;
      };
      maria = mkSystem {host = "maria";};
      pipboy = mkSystem {host = "pipboy";};
    };
  };
}
