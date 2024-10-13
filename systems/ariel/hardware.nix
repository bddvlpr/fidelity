{inputs, ...}: {
  imports = [
    inputs.srvos.nixosModules.server
    inputs.hardware.nixosModules.raspberry-pi-3
  ];

  hardware = {
    enableRedistributableFirmware = true;
    rtl-sdr.enable = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
  };
}
