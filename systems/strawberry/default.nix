{ inputs, ... }:
{
  imports = [
    inputs.srvos.nixosModules.hardware-hetzner-cloud-arm
    ./hardware.nix
  ];

  system.stateVersion = "25.05";
}
