{
  self,
  lib,
  inputs,
  ...
}: let
  inherit (self) outputs;
  inherit (inputs) deploy-rs;
  inherit (inputs.nixpkgs.lib) nixosSystem;

  mkNode = {
    host,
    system,
    type ? nixosSystem,
    modules ? [],
    profiles ? {},
  }: let
    activation = deploy-rs.lib.${system}.activate.nixos;
  in rec {
    nixosConfigurations."${host}" = outputs.lib.mkStrappedSystem host system type ([
        ./${host}
        ./${host}/hardware.nix
      ]
      ++ modules);

    deploy.nodes."${host}" = {
      hostname = "${host}.cloud.bddvlpr.com";
      profiles =
        {
          system = {
            user = "root";
            path = activation nixosConfigurations."${host}";
          };
        }
        // profiles;
    };
  };
in {
  flake = lib.mkMerge [
    (mkNode {
      host = "phobos";
      system = "aarch64-linux";
    })
  ];
}
