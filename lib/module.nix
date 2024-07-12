{
  self,
  inputs,
  withSystem,
  ...
}: let
  inherit (self) outputs;
in {
  flake.lib = rec {
    mkPkgs = system:
      import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

    mkStrappedSystem = host: system: type: modules:
      mkSystem host system type (modules
        ++ builtins.attrValues outputs.nixosModules
        ++ builtins.attrValues outputs.sharedModules);

    mkSystem = host: system: type: modules:
      withSystem system ({pkgs, ...}:
        type {
          inherit system modules;
          pkgs = mkPkgs system;
          specialArgs = {inherit inputs outputs host;};
        });
  };
}
