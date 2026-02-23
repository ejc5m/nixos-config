{
  description = "Nixos config flake";

  inputs =
  {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager =
    {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      mkSystem = { system, pathName, hostName ? pathName}:
      nixpkgs.lib.nixosSystem
      {
        inherit system;
        modules =
        [
          ./hosts/${pathName}/configuration.nix
          inputs.home-manager.nixosModules.default
          {
            modules.system.network.hostName = hostName;
          }
        ];
        specialArgs = {inherit inputs;};
      };
    in
    {
    nixosConfigurations =
      {
        desktop = mkSystem
        {
          system = "x86_64-linux";
          pathName = "desktop";
        };
        chromebook = mkSystem
        {
          system = "x86_64-linux";
          pathName = "chromebook";
        };
        };
      };
    }
