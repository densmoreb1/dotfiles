{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = {
    self,
    nixpkgs,
  }: {
    nixosConfigurations.pipboy = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [./configuration.nix];
    };
  };
}
