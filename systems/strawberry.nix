{ inputs, ... }:
{
  imports = [
    inputs.srvos.nixosModules.hardware-hetzner-cloud-arm
  ];

  system.stateVersion = "25.05";
}
