{ inputs, ... }:
{
  imports = [
    inputs.srvos.nixosModules.mixins-terminfo
    ./grafana
  ];

  sysc = {
    nginx.enable = true;
    prometheus.enable = true;
    alertmanager.enable = true;
  };

  networking = {
    hostName = "phobos";
    hostId = "3d845e1f";

    interfaces.enp7s0 = {
      ipv4.addresses = [
        {
          address = "10.0.0.2";
          prefixLength = 16;
        }
      ];
    };
  };

  system.stateVersion = "24.05";
}
