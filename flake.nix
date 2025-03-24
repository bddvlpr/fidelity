{
  inputs = {
    nixpkgs = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    nixpkgs-stable = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      ref = "nixos-24.11";
    };

    flake-parts = {
      type = "github";
      owner = "hercules-ci";
      repo = "flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    colmena = {
      type = "github";
      owner = "zhaofengli";
      repo = "colmena";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        stable.follows = "nixpkgs-stable";
      };
    };

    easy-hosts = {
      type = "github";
      owner = "tgirlcloud";
      repo = "easy-hosts";
    };

    srvos = {
      type = "github";
      owner = "nix-community";
      repo = "srvos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      type = "github";
      owner = "nix-community";
      repo = "disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      type = "github";
      owner = "nix-community";
      repo = "impermanence";
    };
  };

  outputs =
    {
      self,
      flake-parts,
      nixpkgs,
      easy-hosts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      imports = [
        easy-hosts.flakeModule
      ];

      easyHosts = {
        path = ./systems;

        perClass = class: {
          modules = [
            "${self}/modules/common/default.nix"
            "${self}/modules/${class}/default.nix"
          ];
        };

        hosts = {
          strawberry = {
            arch = "aarch64";
            class = "nixos";
            # nixpkgs = inputs.nixpkgs-stable;
            deployable = true;
          };
        };
      };

      perSystem =
        { pkgs, system, ... }:
        {
          _module.args.pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          formatter = pkgs.nixfmt-tree;

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [ terraform ];
          };
        };
    };
}
