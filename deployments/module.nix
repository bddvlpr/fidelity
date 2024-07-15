{
  self,
  inputs,
  ...
}: let
  inherit (self) outputs;
  inherit (builtins) mapAttrs;
  inherit (inputs) deploy-rs;
in {
  flake.deploy.nodes =
    mapAttrs (host: value: let
      inherit (value.config.nixpkgs) system;

      activation = deploy-rs.lib.${system}.activate.nixos;
    in {
      hostname = "${host}.cloud.bddvlpr.com";
      profiles = {
        system = {
          user = "root";
          path = activation outputs.nixosConfigurations."${host}";
        };
      };
    })
    outputs.nixosConfigurations;
}
