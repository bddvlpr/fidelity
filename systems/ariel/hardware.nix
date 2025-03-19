{ inputs, ... }:
{
  imports = [
    inputs.srvos.nixosModules.server
    inputs.hardware.nixosModules.raspberry-pi-3
  ];

  hardware.enableRedistributableFirmware = true;

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };
}
