{
  self,
  inputs,
  ...
}: let
  inherit (self) outputs;
  inherit (inputs.nixpkgs.lib) nixosSystem;

  mkNode = {
    host,
    system,
    type ? nixosSystem,
    modules ? [],
  }: {
    name = host;
    value = outputs.lib.mkStrappedSystem host system type ([
        ./${host}
        ./${host}/hardware.nix
      ]
      ++ modules);
  };
in {
  flake.nixosConfigurations = builtins.listToAttrs [
    (mkNode {
      host = "ceres";
      system = "x86_64-linux";
    })
    (mkNode {
      host = "phobos";
      system = "aarch64-linux";
    })
  ];
}
