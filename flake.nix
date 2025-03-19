{
  description = "Luna's server system configurations and modules";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-24.05";

    flake-parts.url = "github:hercules-ci/flake-parts";

    hardware.url = "github:nixos/nixos-hardware";

    srvos = {
      url = "github:nix-community/srvos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    colmena = {
      url = "github:zhaofengli/colmena";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        stable.follows = "nixpkgs-stable";
      };
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    eufy-security-ws = {
      url = "github:bropat/eufy-security-ws";
      flake = false;
    };

    hass-pyloxone = {
      url = "github:jodehli/pyloxone";
      flake = false;
    };

    hass-eufy_security = {
      url = "github:fuatakgun/eufy_security";
      flake = false;
    };

    nix-minecraft = {
      url = "github:infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    untis-ics-sync = {
      url = "github:bddvlpr/untis-ics-sync";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixarr = {
      url = "github:rasmus-kirk/nixarr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      imports = [
        ./checks/module.nix
        ./deployments/module.nix
        ./lib/module.nix
        ./modules/module.nix
        ./overlays/module.nix
        ./pkgs/module.nix
        ./systems/module.nix
      ];

      perSystem =
        {
          pkgs,
          inputs',
          ...
        }:
        {
          formatter = pkgs.nixfmt-tree;

          devShells.default =
            let
              inherit (inputs'.colmena.packages) colmena;
            in
            pkgs.mkShell {
              buildInputs = with pkgs; [
                sops
                colmena
              ];
            };
        };
    };
}
