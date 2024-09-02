{inputs, ...}: {
  imports = with inputs.srvos.nixosModules;
    [
      server
    ]
    ++ [inputs.hardware.nixosModules.raspberry-pi-3];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
  };
}
