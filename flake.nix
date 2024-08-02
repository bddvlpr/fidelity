{
  description = "Luna's server system configurations and modules";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-24.05";

    flake-parts.url = "github:hercules-ci/flake-parts";

    hardware.url = "github:nixos/nixos-hardware";

    rpi-nix.url = "github:nix-community/raspberry-pi-nix";

    srvos.url = "github:nix-community/srvos";
    srvos.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    grafana-node-dashboard.url = "github:rfmoz/grafana-dashboards";
    grafana-node-dashboard.flake = false;

    grafana-blackbox-dashboard.url = "github:aaabramov/grafana-dashboards";
    grafana-blackbox-dashboard.flake = false;

    hass-pyloxone.url = "github:jodehli/pyloxone";
    hass-pyloxone.flake = false;
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
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
        ./systems/module.nix
      ];

      perSystem = {
        pkgs,
        inputs',
        ...
      }: {
        formatter = pkgs.alejandra;

        devShells.default = let
          inherit (inputs'.deploy-rs.packages) deploy-rs;
        in
          pkgs.mkShell {
            buildInputs = with pkgs; [sops deploy-rs];
          };
      };
    };
}
