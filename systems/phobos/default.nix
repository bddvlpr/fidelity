{inputs, ...}: {
  imports = with inputs.srvos.nixosModules; [
    mixins-terminfo
    mixins-systemd-boot
    ./alertmanager.nix
    ./grafana.nix
    ./mediamtx.nix
    ./prometheus.nix
  ];

  sysc.nginx.enable = true;

  networking = {
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
