{
  inputs,
  host,
  ...
}: {
  imports = [inputs.sops-nix.nixosModules.sops];

  sops.defaultSopsFile = ../../../systems/${host}/secrets.yaml;
}
