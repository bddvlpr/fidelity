{
  lib,
  config,
  outputs,
  ...
}:
with lib; let
  cfg = config.sysc.alertmanager;
in {
  options.sysc.alertmanager = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."alertmanager/env" = {};

    services.prometheus.alertmanager = {
      enable = true;

      environmentFile = config.sops.secrets."alertmanager/env".path;
      checkConfig = false;

      extraFlags =
        [
          "--cluster.listen-address=0.0.0.0:9094"
          "--cluster.reconnect-timeout=5m"
        ]
        ++ (let
          otherPeers =
            filter (peer: peer != config.networking.hostName)
            (mapAttrsToList (host: nixosConfig: host) (filterAttrs (
                host: nixosConfig: nixosConfig.config.services.prometheus.alertmanager.enable or false
              )
              outputs.nixosConfigurations));
        in
          concatMap (peer: ["--cluster.peer=${peer}.cloud.bddvlpr.com:9094"]) otherPeers);

      configuration = {
        global = {
          smtp_smarthost = "smtp.mailbox.org:587";
          smtp_from = "$SMTP_FROM";
          smtp_require_tls = true;
          smtp_auth_username = "$SMTP_USERNAME";
          smtp_auth_password = "$SMTP_PASSWORD";
        };

        route = {
          receiver = "cloud.bddvlpr.com";
          group_wait = "30s";
          group_interval = "5m";
          repeat_interval = "1h";
          group_by = ["host"];
        };

        receivers = [
          {
            name = "cloud.bddvlpr.com";
            email_configs = [
              {to = "luna@bddvlpr.com";}
            ];
            discord_configs = [
              {webhook_url = "$DISCORD_WEBHOOK";}
            ];
          }
        ];
      };
    };
  };
}
