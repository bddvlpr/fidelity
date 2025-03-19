{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.sysc.bind;
in
{
  options.sysc.bind = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.bind = {
      enable = true;

      forwarders = [
        "1.1.1.1"
        "1.0.0.1"
      ];

      cacheNetworks = [
        "10.0.0.0/8"
        "127.0.0.0/8"
        "127.16.0.0/12"
        "192.168.14.0/24"
        "100.64.0.0/10"
        "FE80::/10"
        "::1/128"
      ];

      listenOn = [
        "127.0.0.1"
        "100.96.41.51"
      ];

      zones."in.bddvlpr.cloud" = {
        master = true;
        file = ./in.bddvlpr.cloud.zone;
      };
    };

    networking.firewall = {
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [ 53 ];
    };
  };
}
