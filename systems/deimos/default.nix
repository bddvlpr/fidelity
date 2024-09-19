{inputs, ...}: {
  imports = [
    inputs.srvos.nixosModules.mixins-terminfo
    # ./minecraft.nix
    ./synapse.nix
    ./untis-ics-sync.nix
  ];

  sysc.nginx.enable = true;

  networking = {
    hostName = "deimos";
    hostId = "3d845e22";

    interfaces.enp7s0 = {
      ipv4.addresses = [
        {
          address = "10.0.0.3";
          prefixLength = 16;
        }
      ];
    };
  };

  system.stateVersion = "24.05";
}
