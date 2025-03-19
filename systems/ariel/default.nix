{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
{
  sops.secrets."wireless/env" = { };

  boot = {
    tmp.useTmpfs = true;
    kernelPackages =
      lib.mkForce
        inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.linuxKernel.packages.linux_rpi3;
    initrd.systemd.enable = false;
    loader.systemd-boot.enable = lib.mkForce false;
  };

  networking = {
    hostName = "ariel";
    hostId = "3d845e21";

    wireless = {
      enable = true;
      secretsFile = config.sops.secrets."wireless/env".path;
      networks = {
        Capybara.pskRaw = "ext:psk_capybara";
      };
    };
  };

  systemd.network = {
    enable = true;

    # networks."20-wlan0" = {
    #   matchConfig.Name = "wlan0";

    #   address = ["192.168.14.25/24"];
    #   routes = [
    #     {
    #       Gateway = "192.168.14.1";
    #     }
    #   ];
    # linkConfig.RequiredForOnline = "routable";
    # };

    networks."20-enu1u1" = {
      matchConfig.Name = "enu1u1";

      address = [ "192.168.14.25/24" ];
      routes = [
        {
          Gateway = "192.168.14.1";
        }
      ];
    };
  };

  system.stateVersion = "24.05";
}
