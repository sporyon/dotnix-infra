{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";
  inputs.dotnix-core.url = "github:sporyon/dotnix-core";

  outputs = { nixpkgs, disko, dotnix-core, ... }:
    {
      # tested with 2GB/2CPU droplet, 1GB droplets do not have enough RAM for kexec
      nixosConfigurations.dotnix-infra = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
#          dotnix-core
          ./configuration.nix
        ];
      };
    };
}
