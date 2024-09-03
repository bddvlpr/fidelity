{inputs, ...}: {
  imports = [
    inputs.srvos.nixosModules.server
    inputs.hardware.nixosModules.raspberry-pi-4
  ];

  hardware.raspberry-pi."4" = {
    dwc2.enable = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
  };
}
