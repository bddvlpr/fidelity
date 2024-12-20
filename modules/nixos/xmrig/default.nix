{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.sysc.xmrig;
in {
  options.sysc.xmrig = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    wallet = mkOption {
      type = with types; str;
      default = "43RZ4AbimXNYzaH6GicTK4ExibtrosWtXBaH8UWhUEMmVvSReUG1ADnGcoFka6C7enhW4PEAeUwLrSKZvpb5tiduTcsF7BL";
    };

    address = mkOption {
      type = with types; nullOr str;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    services.xmrig = {
      enable = true;

      settings = {
        cpu = true;
        opencl = false;
        cuda = false;

        pools = [{url = "127.0.0.1:3000";}];
      };
    };

    systemd.services.p2pool = {
      description = "Decentralized pool for Monero mining";
      after = ["multi-user.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${getExe pkgs.p2pool} --mini --host ${cfg.address} --wallet ${cfg.wallet}";
      };
    };
  };
}
