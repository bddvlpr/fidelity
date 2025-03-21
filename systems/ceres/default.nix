{ inputs, ... }:
{
  imports = [
    inputs.srvos.nixosModules.mixins-terminfo
    ./arr
    # ./apcupsd
    # ./eufy-security-ws
    # ./home-assistant
    ./nextcloud
    # ./spoolman
    ./vrchat-jellyfin
    # ./radiosonde-auto-rx
  ];

  sysc = {
    nginx.enable = true;
    prometheus.enable = true;
    alertmanager.enable = true;
  };

  networking = {
    hostName = "ceres";
    hostId = "3d845e20";
  };

  systemd.network = {
    enable = true;

    networks."20-eno1" = {
      matchConfig.Name = "eno1";

      address = [ "192.168.14.23/24" ];
      routes = [
        {
          Gateway = "192.168.14.1";
        }
      ];
      linkConfig.RequiredForOnline = "routable";
    };
  };

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "sd_mod"
  ];

  system.stateVersion = "24.05";
}
