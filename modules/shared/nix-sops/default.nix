{
  inputs,
  config,
  ...
}: let
  host = config.networking.hostName;
in {
  imports = [inputs.sops-nix.nixosModules.sops];

  sops.defaultSopsFile = ../../../systems/${host}/secrets.yaml;
}
