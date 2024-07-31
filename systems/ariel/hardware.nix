{inputs, ...}: {
  imports = with inputs.srvos.nixosModules; [
    server
  ];

  raspberry-pi-nix.board = "bcm2711";

  hardware = {
    bluetooth.enable = true;
    raspberry-pi.config.all.base-dt-params = {
      krnbt = {
        enable = true;
        value = "on";
      };
    };
  };
}
