{
  inputs,
  lib,
  pkgs,
  ...
}: {
  boot = {
    tmp.useTmpfs = true;
    kernelPackages = lib.mkForce inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.linuxKernel.packages.linux_rpi4;
    initrd.systemd.enable = false;
    loader.systemd-boot.enable = lib.mkForce false;
  };

  networking = {
    hostName = "pallas";
    hostId = "3d845e23";

    nameservers = ["1.1.1.1" "1.0.0.1"];
  };

  systemd.network = {
    enable = true;

    networks."20-end0" = {
      matchConfig.Name = "end0";

      address = ["192.168.14.26/24"];
      routes = [
        {
          Gateway = "192.168.14.1";
        }
      ];
      linkConfig.RequiredForOnline = "routable";
    };
  };

  system.stateVersion = "24.05";
}
