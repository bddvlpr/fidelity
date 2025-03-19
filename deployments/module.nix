{
  self,
  inputs,
  ...
}:
let
  inherit (self) outputs;
  inherit (builtins) mapAttrs;

  systems = self.nixosConfigurations;
in
{
  flake = {
    colmena =
      (mapAttrs (host: config: {
        imports = config._module.args.modules;
        deployment = {
          targetHost = "${host}.host.bddvlpr.cloud";
          targetUser = null;
        };
      }) systems)
      // {
        meta = {
          nixpkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
          nodeNixpkgs = builtins.mapAttrs (_host: config: config.pkgs) systems;
          nodeSpecialArgs = builtins.mapAttrs (_host: config: config._module.specialArgs) systems;
        };
      };

    colmenaHive = inputs.colmena.lib.makeHive outputs.colmena;
  };
}
